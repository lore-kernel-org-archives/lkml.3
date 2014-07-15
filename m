Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758609AbaGOKCt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 06:02:49 -0400
Received: from mga11.intel.com ([192.55.52.93]:53690 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758557AbaGOKCr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 06:02:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="361802385"
Message-ID: <53C4FC29.2010703@linux.intel.com>
Date: Tue, 15 Jul 2014 18:02:17 +0800
From: "Li, Aubrey" <aubrey.li@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@linux.intel.com>,
        "alan@linux.intel.com" <alan@linux.intel.com>,
        Adam Williamson <awilliam@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Resend PATCHv3 0/3] x86: new Intel atom SOC power management
 controller driver
References: <53B0FEA9.6060707@linux.intel.com>
In-Reply-To: <53B0FEA9.6060707@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ping......

On 2014/6/30 14:07, Li, Aubrey wrote:
> From: Aubrey Li <aubrey.li@linux.intel.com>
> 
> The Power Management Controller (PMC) controls many of the power
> management features present in the SoC. This driver provides the power
> off functionality and s0ix residency control, also provides the SOC
> device state and platform sleep state observation via debugfs.
> 
> v3:
> - split the driver into tree pieces: the power off functionality, the
> s0ix residency control, and the debugfs exports.
> 
> v2:
> - allow pmc_atom and lpc_ich to work at the same time.
> 
> Aubrey Li (3):
>   X86 platform: New Intel Atom SOC power management controller driver
>   x86/pmc_atom: disable a few S0ix wake up events for S0ix residency
>   x86/pmc_atom: expose PMC device state and platform sleep state
> 
>  arch/x86/Kconfig                |    4 +
>  arch/x86/include/asm/pmc_atom.h |  107 +++++++++++++
>  arch/x86/kernel/Makefile        |    1 +
>  arch/x86/kernel/pmc_atom.c      |  321
> +++++++++++++++++++++++++++++++++++++++
>  4 files changed, 433 insertions(+)
>  create mode 100644 arch/x86/include/asm/pmc_atom.h
>  create mode 100644 arch/x86/kernel/pmc_atom.c
> 

