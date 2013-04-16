Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754885Ab3DPLfK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 07:35:10 -0400
Received: from mail-bk0-f41.google.com ([209.85.214.41]:60855 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751820Ab3DPLfJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 07:35:09 -0400
Date: Tue, 16 Apr 2013 13:35:04 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>, X86 ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>
Subject: Re: [GIT PULL] Rebase tip:x86/cpu
Message-ID: <20130416113504.GC10452@gmail.com>
References: <20130412094724.GA2368@pd.tnic>
 <20130412112628.GB2368@pd.tnic>
 <20130415100858.GB18024@gmail.com>
 <20130415101734.GB26524@pd.tnic>
 <20130415101825.GD18024@gmail.com>
 <20130415155415.GB12144@pd.tnic>
 <20130415220406.GD12144@pd.tnic>
 <20130416092528.GF9569@gmail.com>
 <20130416094852.GA5332@pd.tnic>
 <20130416100853.GC5332@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130416100853.GC5332@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Borislav Petkov <bp@alien8.de> wrote:

> Hi,
> 
> here it is.
> 
> Original tip:x86/cpu tree state is this:
> 
> 3019653a5758 x86/fpu: Fix FPU initialization
> 042c16f14161 x86, CPU, AMD: Drop useless label
> 982f33db626e x86, AMD: Correct {rd,wr}msr_amd_safe warnings
> e277a4938574 x86: Fold-in trivial check_config function
> c70293d0e3fe x86: Get rid of ->hard_math and all the FPU asm fu
> 7d7dc116e56c x86, cpu: Convert AMD Erratum 400
> e6ee94d58dfd x86, cpu: Convert AMD Erratum 383
> c5b41a67505c x86, cpu: Convert Cyrix coma bug detection
> 93a829e8e2c2 x86, cpu: Convert FDIV bug detection
> e2604b49e8a8 x86, cpu: Convert F00F bug detection
> 65fc985b37dc x86, cpu: Expand cpufeature facility to include cpu bugs
> 
> and the rebased one is this:
> 
> 1077c932db63 x86, CPU, AMD: Drop useless label
> 682469a5db6f x86, AMD: Correct {rd,wr}msr_amd_safe warnings
> 55a36b65ee71 x86: Fold-in trivial check_config function
> 7d7dc116e56c x86, cpu: Convert AMD Erratum 400
> e6ee94d58dfd x86, cpu: Convert AMD Erratum 383
> c5b41a67505c x86, cpu: Convert Cyrix coma bug detection
> 93a829e8e2c2 x86, cpu: Convert FDIV bug detection
> e2604b49e8a8 x86, cpu: Convert F00F bug detection
> 65fc985b37dc x86, cpu: Expand cpufeature facility to include cpu bugs
> 
> Commits c70293d0e3fe and 3019653a5758 are gone and the three commits
> in-between have received new commit ids. Those 6 before that are
> unchanged, as their commit ids show.

Thanks, I started testing this.

	Ingo
