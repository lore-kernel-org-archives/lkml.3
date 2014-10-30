Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759532AbaJ3LxE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 07:53:04 -0400
Received: from svenfoo.org ([82.94.215.22]:47364 "EHLO mail.zonque.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759051AbaJ3LxB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 07:53:01 -0400
Message-ID: <5452269A.9050003@zonque.org>
Date: Thu, 30 Oct 2014 12:52:58 +0100
From: Daniel Mack <daniel@zonque.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, Tom Gundersen <teg@jklm.no>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux API <linux-api@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>, Tejun Heo <tj@kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>, Ryan Lortie <desrt@desrt.ca>,
        Bastien Nocera <hadess@hadess.net>,
        David Herrmann <dh.herrmann@gmail.com>,
        Djalal Harouni <tixxdz@opendz.org>,
        Simon McVittie <simon.mcvittie@collabora.co.uk>,
        "alban.crequy" <alban.crequy@collabora.co.uk>,
        "javier.martinez" <javier.martinez@collabora.co.uk>
Subject: Re: kdbus: add header file
References: <1414620056-6675-1-git-send-email-gregkh@linuxfoundation.org> <3546486.lOZcZMmXYe@wuerfel> <CAG-2HqV_mXyARMs=9GOpbCBHPU+2XMkDcm=sGekYnnujNPAYqQ@mail.gmail.com> <6078917.F7Y7rNpK9C@wuerfel>
In-Reply-To: <6078917.F7Y7rNpK9C@wuerfel>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/30/2014 12:26 PM, Arnd Bergmann wrote:
> On Thursday 30 October 2014 12:02:39 Tom Gundersen wrote:

>> The nice thing about enums is of course that it helps with debugging
>> as gdb can show the string representation rather than the number,
>> because in contrast to #defines, an enum is something the compliler
>> knows about.
> 
> This doesn't get passed as an enum in user space though, and when debugging
> the kernel it only helps within one function.

Hmm, this is the header exported to userspace, so having enums in would
make our lives easier, right?

Hence, for now, I'd propose we keep it the way it is, and add new ioctls
with defines once they are implemented. Are you okay with this? I'll add
a comment to the file to give a heads-up.


Thanks,
Daniel

