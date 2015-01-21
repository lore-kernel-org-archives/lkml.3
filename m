Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753465AbbAUMw1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 07:52:27 -0500
Received: from mail.kernel.org ([198.145.29.136]:36450 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753334AbbAUMvr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 07:51:47 -0500
Date: Wed, 21 Jan 2015 09:51:42 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        mpe@ellerman.id.au, ananth@in.ibm.com
Subject: Re: [RFC PATCH 0/8] Fix perf probe issues on powerpc
Message-ID: <20150121125142.GC3420@kernel.org>
References: <cover.1418146300.git.naveen.n.rao@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1418146300.git.naveen.n.rao@linux.vnet.ibm.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Dec 09, 2014 at 11:03:58PM +0530, Naveen N. Rao escreveu:
> This patchset fixes various issues with perf probe on powerpc
> across ABIv1 and ABIv2:
> - in the presence of DWARF debug-info,
> - in the absence of DWARF, but with the symbol table, and
> - in the absence of debug-info, but with kallsyms.
> 
> Applies cleanly on v3.18 and on -tip with minor changes to patch 6.
> Tested on ppc64 BE and LE.
> 
> - Naveen
> 
> Naveen N. Rao (8):
>   kprobes: Fix kallsyms lookup across powerpc ABIv1 and ABIv2
>   perf probe powerpc: Fix symbol fixup issues due to ELF type
>   perf probe: Improve detection of file/function name in the probe
>     pattern
>   perf probe powerpc: Handle powerpc dot symbols
>   perf probe powerpc: Allow matching against dot symbols
>   perf tools powerpc: Fix PPC64 ELF ABIv2 symbol decoding
>   perf probe powerpc: Use DWARF info only if necessary
>   perf probe powerpc: Fixup function entry if using kallsyms lookup

Naveen,

	I saw several comments by Michael, have you tried to address
those comments and have you resubmitted this patchset?

Best regards,

- Arnaldo
