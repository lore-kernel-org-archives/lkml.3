Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933040Ab3EBTnc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 15:43:32 -0400
Received: from mail-ea0-f177.google.com ([209.85.215.177]:45826 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751974Ab3EBTnb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 15:43:31 -0400
Date: Thu, 2 May 2013 21:43:26 +0200
From: Ingo Molnar <mingo@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Borislav Petkov <bp@alien8.de>, David Rientjes <rientjes@google.com>,
        linux-kernel@vger.kernel.org, Pekka Enberg <penberg@kernel.org>,
        levinsasha928@gmail.com, mtosatti@redhat.com, tglx@linutronix.de,
        Borislav Petkov <bp@suse.de>, fengguang.wu@intel.com,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86/kconfig:  Add a Kconfig shortcut for
 building working KVM guest kernels
Message-ID: <20130502194326.GA3553@gmail.com>
References: <20130501211011.GD4466@pd.tnic>
 <alpine.DEB.2.02.1305011419020.20298@chino.kir.corp.google.com>
 <20130501215604.GA15623@pd.tnic>
 <alpine.DEB.2.02.1305011503200.3267@chino.kir.corp.google.com>
 <20130501222850.GB15623@pd.tnic>
 <alpine.DEB.2.02.1305011531320.8804@chino.kir.corp.google.com>
 <20130501230254.GC15623@pd.tnic>
 <51819F6C.1030201@zytor.com>
 <20130502070633.GA26361@gmail.com>
 <5182A300.9050603@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5182A300.9050603@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* H. Peter Anvin <hpa@zytor.com> wrote:

> > That should be possible here as well, driven by any weird randconfig 
> > build failures that get found. Such a set of selects quickly 
> > converges.
> 
> The problem is that it is a moving target.  We really need a 
> dependency-resolving version of select.

Dependencies are always a moving target - sometimes config names change, 
new dependencies come in.

I've maintained a similar solution for years, and once the initial list of 
selects has settled it's a low maintenance overhead thing.

Thanks,

	Ingo
