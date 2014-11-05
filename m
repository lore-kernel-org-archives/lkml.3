Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754241AbaKEK4i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 05:56:38 -0500
Received: from mail-ob0-f180.google.com ([209.85.214.180]:33315 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751403AbaKEK4g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 05:56:36 -0500
MIME-Version: 1.0
In-Reply-To: <CAFLxGvywuEox+2fYZ-+ZLop=Za7Kum8P+q1kHx3cFWF2nG6O5A@mail.gmail.com>
References: <CAOD=uF4L+jvR=ckMdo3o4wdSsRcGynQnv_KOpDeyJst74YOxuA@mail.gmail.com>
	<CAFLxGvywuEox+2fYZ-+ZLop=Za7Kum8P+q1kHx3cFWF2nG6O5A@mail.gmail.com>
Date: Wed, 5 Nov 2014 16:26:35 +0530
Message-ID: <CAOD=uF6oBZ0cmNH4Jf9Hs4ZU3Y4WO-wfvc4k0b7Ezpo63S7Dag@mail.gmail.com>
Subject: Re: How to access Linux Kernel environment Variables ?
From: santosh nayak <santoshprasadnayak@gmail.com>
To: Richard Weinberger <richard.weinberger@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Richard for your response.

Is there any system call in Linux which can access and set variables
in /proc/cmdline ?  (Similar to kenv() in FreeBSD which can access and
set variables in /boot/loader.conf).

I would like to use that system call in linux C code, the  way I am
using kenv() in freeBSD environment.

Regards
Santosh

On Wed, Nov 5, 2014 at 2:44 PM, Richard Weinberger
<richard.weinberger@gmail.com> wrote:
> On Wed, Nov 5, 2014 at 9:03 AM, santosh prasad nayak
> <santoshprasadnayak@gmail.com> wrote:
>> Hi all,
>>
>> Is there any system call in Linux which serve the purpose of  "kenv()"
>> of FreeBSD ?
>>
>>
>> In FreeBSD:
>> -----------------
>> Kernel environment variables are saved at "/boot/loader.conf"  and
>> those variables can be accessed using "kenv()"  system call in C
>> program.
>> ----------------
>>
>>
>> Is there any similar functionality available in Linux kernel ?
>
> /proc/cmdline?
>
> --
> Thanks,
> //richard
