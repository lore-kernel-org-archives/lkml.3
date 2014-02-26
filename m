Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753951AbaBZXh1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 18:37:27 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47143 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751510AbaBZXh0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 18:37:26 -0500
Message-ID: <530E7AAF.3070908@zytor.com>
Date: Wed, 26 Feb 2014 15:37:19 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: The sheer number of sparse warnings in the kernel
References: <530E6F76.1070605@zytor.com> <20140226232859.GA9213@kroah.com> <20140226232954.GA17791@kroah.com> <530E7963.10209@zytor.com>
In-Reply-To: <530E7963.10209@zytor.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/26/2014 03:31 PM, H. Peter Anvin wrote:
> On 02/26/2014 03:29 PM, Greg KH wrote:
>> On Wed, Feb 26, 2014 at 03:28:59PM -0800, Greg KH wrote:
>>> On Wed, Feb 26, 2014 at 02:49:26PM -0800, H. Peter Anvin wrote:
>>>> The number of sparse errors in the current kernel is staggering, and it
>>>> makes sparse a lot less valuable of a tool that it otherwise could be.
>>>> On a build of x86-64 allyesconfig I'm getting 20,676 sparse messages.
>>>> Out of those, 12,358 come from linux/err.h.  Given that the latter
>>>> basically spams *everything*, I can only conclude that almost noone uses
>>>> sparse unless they have a filter script.
>>>
>>> What errors are you seeing from err.h?  I don't see those when building
>>> different subdirectories with sparse (which is how I normally use it.)
>>>
>>> And what version of sparse are you running:
>>> 	$ sparse --version
>>> 	v0.4.5-rc1-407-g345e8943fc36
>>
>> Ah, 0.5.0 is now out, maybe you should update to that version?
>>
> 
> Yes... it looks like the 0.4.5-rc1 that shipped in Fedora is indeed out
> of date.  With 0.5.0 I "only" see 8,207 messages, which means that at
> least the linux/err.h issue is gone.
> 

For what it's worth, the rpm is called sparse-0.4.5.rc1-2.fc19.x86_64
and sparse --version reports 0.4.4...

	-hpa

