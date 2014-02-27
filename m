Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753717AbaB0BTw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 20:19:52 -0500
Received: from mail-oa0-f50.google.com ([209.85.219.50]:35393 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753115AbaB0BTv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 20:19:51 -0500
MIME-Version: 1.0
In-Reply-To: <530E7AAF.3070908@zytor.com>
References: <530E6F76.1070605@zytor.com>
	<20140226232859.GA9213@kroah.com>
	<20140226232954.GA17791@kroah.com>
	<530E7963.10209@zytor.com>
	<530E7AAF.3070908@zytor.com>
Date: Wed, 26 Feb 2014 20:19:51 -0500
X-Google-Sender-Auth: 362OSaPIkXFZC9thp5wX15_znAs
Message-ID: <CA+5PVA6Y2R1OP1dwvh+zE2puE0nJr0ChUgXz9wsMU3XZ2ZwfZg@mail.gmail.com>
Subject: Re: The sheer number of sparse warnings in the kernel
From: Josh Boyer <jwboyer@fedoraproject.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 26, 2014 at 6:37 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 02/26/2014 03:31 PM, H. Peter Anvin wrote:
>> On 02/26/2014 03:29 PM, Greg KH wrote:
>>> On Wed, Feb 26, 2014 at 03:28:59PM -0800, Greg KH wrote:
>>>> On Wed, Feb 26, 2014 at 02:49:26PM -0800, H. Peter Anvin wrote:
>>>>> The number of sparse errors in the current kernel is staggering, and it
>>>>> makes sparse a lot less valuable of a tool that it otherwise could be.
>>>>> On a build of x86-64 allyesconfig I'm getting 20,676 sparse messages.
>>>>> Out of those, 12,358 come from linux/err.h.  Given that the latter
>>>>> basically spams *everything*, I can only conclude that almost noone uses
>>>>> sparse unless they have a filter script.
>>>>
>>>> What errors are you seeing from err.h?  I don't see those when building
>>>> different subdirectories with sparse (which is how I normally use it.)
>>>>
>>>> And what version of sparse are you running:
>>>>     $ sparse --version
>>>>     v0.4.5-rc1-407-g345e8943fc36
>>>
>>> Ah, 0.5.0 is now out, maybe you should update to that version?
>>>
>>
>> Yes... it looks like the 0.4.5-rc1 that shipped in Fedora is indeed out
>> of date.  With 0.5.0 I "only" see 8,207 messages, which means that at
>> least the linux/err.h issue is gone.
>>
>
> For what it's worth, the rpm is called sparse-0.4.5.rc1-2.fc19.x86_64
> and sparse --version reports 0.4.4...

Fedora rawhide has sparse-0.5.0-1.fc21.  If it matters, we could
probably update F20 and F19 with that.

josh
