Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964972AbaKNI4m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 03:56:42 -0500
Received: from svenfoo.org ([82.94.215.22]:57004 "EHLO mail.zonque.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754642AbaKNI4l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 03:56:41 -0500
Message-ID: <5465C3C5.2040606@zonque.org>
Date: Fri, 14 Nov 2014 09:56:37 +0100
From: Daniel Mack <daniel@zonque.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Michael Ellerman <mpe@ellerman.id.au>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: linux-api@vger.kernel.org, linux-kernel@vger.kernel.org,
        john.stultz@linaro.org, arnd@arndb.de, tj@kernel.org,
        marcel@holtmann.org, desrt@desrt.ca, hadess@hadess.net,
        dh.herrmann@gmail.com, tixxdz@opendz.org,
        simon.mcvittie@collabora.co.uk, alban.crequy@collabora.co.uk,
        javier.martinez@collabora.co.uk, teg@jklm.no
Subject: Re: kdbus: add selftests
References: <1414620056-6675-1-git-send-email-gregkh@linuxfoundation.org>	 <1414620056-6675-13-git-send-email-gregkh@linuxfoundation.org> <1415936530.26378.2.camel@concordia>
In-Reply-To: <1415936530.26378.2.camel@concordia>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/14/2014 04:42 AM, Michael Ellerman wrote:
> On Wed, 2014-10-29 at 15:00 -0700, Greg Kroah-Hartman wrote:
>> From: Daniel Mack <daniel@zonque.org>
>>
>> This patch adds a quite extensive test suite for kdbus that checks
>> the most important code pathes in the driver. The idea is to extend
>> the test suite over time.
>>
>> Also, this code can serve as an example implementation to show how to
>> use the kernel API from userspace.
> 
> Great to see selftests included.
> 
> I needed this to get them building:

Thanks a lot for testing! I've added your hunks to the patch set now.


Daniel


