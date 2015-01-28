Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753369AbbA1Ux4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:53:56 -0500
Received: from mga14.intel.com ([192.55.52.115]:44922 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753124AbbA1Uxu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:53:50 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,481,1418112000"; 
   d="scan'208";a="644036909"
Message-ID: <1422466075.14725.7.camel@theros.lm.intel.com>
Subject: Re: [PATCH v3 1/2] x86: Add support for the pcommit instruction
From: Ross Zwisler <ross.zwisler@linux.intel.com>
To: Borislav Petkov <bp@alien8.de>
Cc: "Elliott, Robert (Server Storage)" <Elliott@hp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        H Peter Anvin <h.peter.anvin@intel.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        "Kani, Toshimitsu" <toshi.kani@hp.com>,
        "Knippers, Linda" <linda.knippers@hp.com>
Date: Wed, 28 Jan 2015 10:27:55 -0700
In-Reply-To: <20150128172127.GF7569@pd.tnic>
References: <1422377631-8986-1-git-send-email-ross.zwisler@linux.intel.com>
	 <1422377631-8986-2-git-send-email-ross.zwisler@linux.intel.com>
	 <94D0CD8314A33A4D9D801C0FE68B40295A75C517@G9W0745.americas.hpqcorp.net>
	 <20150128172127.GF7569@pd.tnic>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20.rez) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2015-01-28 at 18:21 +0100, Borislav Petkov wrote:
> On Wed, Jan 28, 2015 at 05:10:46PM +0000, Elliott, Robert (Server Storage) wrote:
> > Should this patch series also add defines for the virtual 
> > machine control data structure changes?
> > 
> > 1. Add the new VM-Execution Controls bit 21 as
> >     SECONDARY_EXEC_PCOMMIT_EXITING 0x00200000
> > to arch/x86/include/asm/vmx.h.
> > 
> > 2. Add the new exit reason of 64 (0x41) as
> > 	EXIT_REASON_PCOMMIT  64
> > to arch/x86/include/uapi/asm/vmx.h and (with a
> > VMX_EXIT_REASONS string) to usr/include/asm/vmx.h.
> > 
> > 3. Add a kvm_vmx_exit_handler to arch/x86/kvm/vmx.c.
> 
> These look like a separate patchset for kvm enablement to me.

Agreed, I think they are a separate patch set.

