Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756433Ab3CFWOM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 17:14:12 -0500
Received: from mail-ia0-f171.google.com ([209.85.210.171]:51670 "EHLO
	mail-ia0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753809Ab3CFWOK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 17:14:10 -0500
MIME-Version: 1.0
In-Reply-To: <5137B9DB.6000605@linux.intel.com>
References: <CA+55aFx0HcOXKpxmZzM5jcbAaOroxafomX5ggMFV4A=py1qh-Q@mail.gmail.com>
	<20130306080642.GA535@polaris.bitmath.org>
	<51370990.5040508@linux.intel.com>
	<20130306100743.GA407@polaris.bitmath.org>
	<CAE9FiQXT4O3GOzm_OoFJG=vc=5LpfBkTEbAO_3xjerBGS_Gy=A@mail.gmail.com>
	<20130306193612.GA513@polaris.bitmath.org>
	<51379A4F.4020200@linux.intel.com>
	<20130306195457.GA449@polaris.bitmath.org>
	<CAE9FiQWK0ZnG9o8WgU-pcTPpir=PUyULQqk-TRVC+sh6UpU8VA@mail.gmail.com>
	<20130306204500.GA335@polaris.bitmath.org>
	<5137AE06.8060200@linux.intel.com>
	<CAE9FiQW6SegoYjoveCVGWS3h-0UOHp5_wuAwnVh14oKLyYQFKA@mail.gmail.com>
	<5137B9DB.6000605@linux.intel.com>
Date: Wed, 6 Mar 2013 14:14:09 -0800
X-Google-Sender-Auth: FsmZc9YkDmuOZTfBC0zbPbA-mvA
Message-ID: <CAE9FiQX557z1SXTbVoBO1RHRbU=Re=WnPR-F+B=QfhaFVr9D9g@mail.gmail.com>
Subject: Re: Linux 3.9-rc1
From: Yinghai Lu <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Henrik Rydberg <rydberg@euromail.se>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 6, 2013 at 1:49 PM, H. Peter Anvin <hpa@linux.intel.com> wrote:
> On 03/06/2013 01:33 PM, Yinghai Lu wrote:
>> On Wed, Mar 6, 2013 at 12:58 PM, H. Peter Anvin <hpa@linux.intel.com> wrote:
>>
>>> Excellent.  Yinghai, can you write up the patch with a proper
>>> description and I'll put it into x86/urgent.
>>
>> I made it more robust: make sure real_end have 8M below it.
>> Please check attached one.
>>
>
> Sigh.  This is why "keep the page tables together" is fundamentally the
> wrong strategy.
>
> 8M means that we won't even be able to boot on machines with less than
> 16M or so of RAM... I'm not sure if anyone still cares, but that is a
> pretty aggressive heuristic.

Henrik's system has 5M holes, so i picked 8M.

Current what is minimum ram is required for boot x86 32bit kernel? 8M?

Thanks

Yinghai
