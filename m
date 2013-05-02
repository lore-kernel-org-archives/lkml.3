Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761679Ab3EBTqv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 15:46:51 -0400
Received: from mail.skyhub.de ([78.46.96.112]:59527 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761356Ab3EBTqD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 15:46:03 -0400
Date: Thu, 2 May 2013 21:48:03 +0200
From: Borislav Petkov <bp@alien8.de>
To: Ingo Molnar <mingo@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, David Rientjes <rientjes@google.com>,
        linux-kernel@vger.kernel.org, Pekka Enberg <penberg@kernel.org>,
        levinsasha928@gmail.com, mtosatti@redhat.com, tglx@linutronix.de,
        Borislav Petkov <bp@suse.de>, fengguang.wu@intel.com,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86/kconfig:  Add a Kconfig shortcut for
 building working KVM guest kernels
Message-ID: <20130502194803.GD16684@pd.tnic>
References: <alpine.DEB.2.02.1305011419020.20298@chino.kir.corp.google.com>
 <20130501215604.GA15623@pd.tnic>
 <alpine.DEB.2.02.1305011503200.3267@chino.kir.corp.google.com>
 <20130501222850.GB15623@pd.tnic>
 <alpine.DEB.2.02.1305011531320.8804@chino.kir.corp.google.com>
 <20130501230254.GC15623@pd.tnic>
 <51819F6C.1030201@zytor.com>
 <20130502070633.GA26361@gmail.com>
 <5182A300.9050603@zytor.com>
 <20130502194326.GA3553@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130502194326.GA3553@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 02, 2013 at 09:43:26PM +0200, Ingo Molnar wrote:
> Dependencies are always a moving target - sometimes config names
> change, new dependencies come in.
>
> I've maintained a similar solution for years, and once the initial
> list of selects has settled it's a low maintenance overhead thing.

Yeah, hpa's rebasing urgent anyway and he's taken it out so that I can
bake this a bit longer.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
