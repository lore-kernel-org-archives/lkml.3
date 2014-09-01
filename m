Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753000AbaIASs4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 14:48:56 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55963 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752914AbaIASsz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 14:48:55 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <20140901174322.GA15533@khazad-dum.debian.net>
References: <20140809231911.GA4843@khazad-dum.debian.net> <20140831194548.GA12628@khazad-dum.debian.net> <54037C07.8060703@zytor.com> <20140831201126.GB12628@khazad-dum.debian.net> <20140901051302.GA28402@nazgul.tnic> <5404A035.3070707@zytor.com> <20140901174322.GA15533@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: early microcode: how to disable at runtime?
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Mon, 01 Sep 2014 11:48:03 -0700
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
CC: Borislav Petkov <bp@alien8.de>, Fenghua Yu <fenghua.yu@intel.com>,
        linux-kernel@vger.kernel.org
Message-ID: <ea40f7c4-ec8d-4be5-8f8c-bbd11ab07252@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No, it is worse to rename it and have older kernels behave differently.  Kernel options are basically super obscure to most people anyway.

On September 1, 2014 10:43:22 AM PDT, Henrique de Moraes Holschuh <hmh@hmh.eng.br> wrote:
>On Mon, 01 Sep 2014, H. Peter Anvin wrote:
>> On 08/31/2014 10:13 PM, Borislav Petkov wrote:
>> > On Sun, Aug 31, 2014 at 05:11:26PM -0300, Henrique de Moraes
>Holschuh wrote:
>> >>> Probably more like something more like arch/x86/boot/cmdline.c. 
>Maybe
>> >>> we could even make it sharable.
>> >>
>> >> Looks like that would work, yes.
>> > 
>> > Guys, guys, please relax and check the code first: "dis_ucode_ldr".
>> > 
>> 
>> Yeah.  It is an absolutely horrific option name (something like
>> "noearlyucode" would have been so much nicer; we generally use the
>no-
>> prefix and no underscores) but I should have objected to that one
>much
>> sooner.
>
>It wasn't properly documented, it is obscure as all heck, and early
>microcode updates active by default is a very recent development on
>distros.
>
>You cannot even find "dis_ucode_ldr" being cited by anyone through
>google
>searches.
>
>I believe it is actually possible to fix this still: either by directly
>renaming, or by using a deprecation period and testing for a new name
>and
>the "dis_ucode_ldr" name.

-- 
Sent from my mobile phone.  Please pardon brevity and lack of formatting.
