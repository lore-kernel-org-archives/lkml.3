Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756070Ab3GKNri (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 09:47:38 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:55443 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755025Ab3GKNrh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 09:47:37 -0400
MIME-Version: 1.0
In-Reply-To: <20130711131845.GB8900@pd.tnic>
References: <CAF2Nc0xVKS+aL0CXdDFQHSapvRxM35KZkjeKeigQ7X43+2NVBA@mail.gmail.com>
	<20130711104307.GB28131@pd.tnic>
	<CAF2Nc0xjxtWkpmurODWKNMCC9D+4Xf6gMnQAqAiec6zn4V0z3w@mail.gmail.com>
	<20130711123548.GA8900@pd.tnic>
	<CAF2Nc0ybnoQ7ZYoYzZNci4PaPnH5PA8--8-OBw4u0b3COT6tDQ@mail.gmail.com>
	<20130711131845.GB8900@pd.tnic>
Date: Thu, 11 Jul 2013 15:47:36 +0200
Message-ID: <CAF2Nc0yyLAmTmd6a0MDGALwKqnJ295A7Hfa45jDKq6r+EV0_1A@mail.gmail.com>
Subject: Re: Error 2: No rule to make target kernel/timeconst.pl
From: Konrad Vrba <konrad.vrba@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/11/13, Borislav Petkov <bp@alien8.de> wrote:
> On Thu, Jul 11, 2013 at 02:56:46PM +0200, Konrad Vrba wrote:
>> .config is attached
>
> Your config builds just fine here.
>
> And you must be having some garbage lying around because 3.10 doesn't
> have timeconst.pl:
>
> $ git describe
> v3.10
> $ git ls-files | grep timeconst
> kernel/timeconst.bc
>
> --
> Regards/Gruss,
>     Boris.
>
> Sent from a fat crate under my desk. Formatting is fine.
> --
>

You are right.
I have now tried compiling on another machine, and that works fine.
But I am using the same config and same kernel tar.xz
that does not make sense
