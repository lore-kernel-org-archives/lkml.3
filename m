Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752700AbaLGXPN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2014 18:15:13 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:65275 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751224AbaLGXPM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2014 18:15:12 -0500
Message-ID: <5484DF7C.7060600@nod.at>
Date: Mon, 08 Dec 2014 00:15:08 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Michael Neuling <mikey@neuling.org>, linuxppc-dev@lists.ozlabs.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arch: powerpc: kernel: signal_32.c: Remove unused function
References: <1417990021-18696-1-git-send-email-rickard_strandqvist@spectrumdigital.se> <5484D240.30506@nod.at> <CAFo99gYvkzCTi6FZXfPOCqafNYn6y4H4hx62KqJjex60KV70_A@mail.gmail.com>
In-Reply-To: <CAFo99gYvkzCTi6FZXfPOCqafNYn6y4H4hx62KqJjex60KV70_A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 08.12.2014 um 00:11 schrieb Rickard Strandqvist:
> Hi
> 
> Ok, sorry :-(
> 
> But I really do not. I've hacked together a script that will scan all
> the code for the function, and test builds with some different config
> options turned on.

Looks like you did not build a powerpc32 kernel. :-)

FWIW, this is the reference to the function:
arch/powerpc/include/asm/systbl.h:OLDSYS(debug_setcontext)

Thanks,
//richard
