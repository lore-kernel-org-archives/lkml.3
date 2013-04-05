Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1163067Ab3DEXiq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 19:38:46 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:57694 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162944Ab3DEXip convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 19:38:45 -0400
MIME-Version: 1.0
In-Reply-To: <20130405220039.GA31680@kroah.com>
References: <1365078758-28674-1-git-send-email-serban.constantinescu@arm.com>
	<20130405220039.GA31680@kroah.com>
Date: Fri, 5 Apr 2013 16:38:45 -0700
Message-ID: <CAMP5Xgeh-5nLY1CLBOma2jNcS7J2tMMCkZO8Jg-_W0vCke4zmw@mail.gmail.com>
Subject: Re: [PATCH 0/8] Android Binder IPC Fixes
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Serban Constantinescu <serban.constantinescu@arm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Android Kernel Team <kernel-team@android.com>,
        John Stultz <john.stultz@linaro.org>,
        Dave Butcher <Dave.Butcher@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 5, 2013 at 3:00 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Thu, Apr 04, 2013 at 01:32:30PM +0100, Serban Constantinescu wrote:
>> Hi all,
>>
>> This set of patches will clean-up and fix some of the issues that arise
>> with the current binder interface when moving to a 64bit kernel. All these
>> changes will not affect the existing 32bit Android interface and are meant
>> to stand as the base for the 64bit binder compat layer.
>>
>> This patch set has been successfully tested on 32bit platforms(ARMv7 VExpress)
>> and 64bit platforms(ARMv8 RTSM) running a 32bit Android userspace and an in
>> kernel binder compat layer.
>
> I need some acks from some of the Android developers before I can take
> this.
>

I still think it is better to change user-space to use 64 bit pointer
types when running on a 64 bit kernel. These changes do not seem to
allow 64 bit user-space processes on a 64 bit kernel.

--
Arve Hjønnevåg
