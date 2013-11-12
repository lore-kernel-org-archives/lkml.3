Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755308Ab3KLOE5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 09:04:57 -0500
Received: from mail.skyhub.de ([78.46.96.112]:46037 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751534Ab3KLOEz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 09:04:55 -0500
Date: Tue, 12 Nov 2013 15:04:30 +0100
From: Borislav Petkov <bp@alien8.de>
To: Ingo Molnar <mingo@kernel.org>
Cc: Yinghai Lu <yinghai@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] x86/smpboot: Make the code more consistent
Message-ID: <20131112140430.GE12849@pd.tnic>
References: <20131111170558.GA12741@gmail.com>
 <CAE9FiQWrzZB+wpSXGeQTPKi2o7MKvONFkk0_POe-E+wco07Erw@mail.gmail.com>
 <20131112103422.GA12849@pd.tnic>
 <20131112112338.GA12801@gmail.com>
 <20131112113208.GC12849@pd.tnic>
 <20131112113710.GA12998@gmail.com>
 <20131112115230.GD12849@pd.tnic>
 <20131112123937.GA13057@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20131112123937.GA13057@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 12, 2013 at 01:39:37PM +0100, Ingo Molnar wrote:
> Mind applying the attached cleanup patch first, before doing fixes to
> the printout? No change in functionality. Mildly tested.

Yeah, boots fine in my strange topology kvm configuration here. We still
need http://git.kernel.org/tip/2a929242ee50db84c1a561c81897bb0551f2c32f
as I don't see it in Linus' tree as of now.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
