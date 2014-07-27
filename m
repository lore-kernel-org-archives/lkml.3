Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751697AbaG0CiV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 22:38:21 -0400
Received: from mail-vc0-f176.google.com ([209.85.220.176]:35868 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309AbaG0CiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 22:38:20 -0400
MIME-Version: 1.0
In-Reply-To: <CAPDOMVi71aVdP1F65CunbLvaVe4MYi584n+hHP26Df3iE-T9=A@mail.gmail.com>
References: <CAPDOMVjiT8JKyzLdcFpVVC337p9nC=V66MjePk+1KwNm3owZQg@mail.gmail.com>
	<53D3672A.20206@roeck-us.net>
	<CAPDOMVjMs=y6QpnFSW5uwAmT6meALsmdBHJq7VVk6YJ7U4ZSrQ@mail.gmail.com>
	<CAPDOMVi71aVdP1F65CunbLvaVe4MYi584n+hHP26Df3iE-T9=A@mail.gmail.com>
Date: Sat, 26 Jul 2014 22:38:19 -0400
Message-ID: <CAPDOMVg-jBEoER-B01oVSsJB9Ugj_ui1yhFTSvxDgimukqHTSQ@mail.gmail.com>
Subject: Re: Bug on Boot of Ubuntu 14.04 with kernel 3.16 r6 release
From: Nick Krause <xerofoify@gmail.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 26, 2014 at 10:27 PM, Nick Krause <xerofoify@gmail.com> wrote:
> On Sat, Jul 26, 2014 at 9:49 PM, Nick Krause <xerofoify@gmail.com> wrote:
>> On Sat, Jul 26, 2014 at 4:30 AM, Guenter Roeck <linux@roeck-us.net> wrote:
>>> On 07/25/2014 06:34 PM, Nick Krause wrote:
>>>>
>>>> Hey Guys,
>>>> After building my first rc kernel. I am sad to state it doesn't
>>>> boot.It states that it can't find my root uuid for my ssd boot drive.
>>>> I am using GSP with UEFI, on a Sandy Bridge i5 2500k build I have  had
>>>> for a few years. The kernel boots and after a few seconds
>>>> drops to a busybox ash shell stating it can't find my root device. I
>>>> am using the default Ubuntu build for this and it did boot
>>>> before with x86_64 defconfig without my sound through. Seems to me an
>>>> issue with the Ubuntu built kernel and not upstream
>>>> at least from what I can tell. I will attach my .config to help
>>>> through or my sound drivers.
>>>
>>>
>>> I'd put in a wild guess that you did not install a matching initramfs.
>>>
>>> Guenter
>>>
>> Guenter,
>> Thanks your probably right there.
>> Cheers Nick
>
>
> Guenter and others,
> I have enabled sound on my computer with what I believed was needed to
> get sound.
> I can't seem to get sound working. I am going to attach my config and
> see if building
> the kernel with other settings enabled gets sound.
> Cheers Nick


Sound works but will not build as a module needs to enabled at boot to
work not sure if this is a bug or just the way sound
works.
Cheers NIck
