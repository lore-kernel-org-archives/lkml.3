Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752061AbbA1VBk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 16:01:40 -0500
Received: from mail.skyhub.de ([78.46.96.112]:35325 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756586AbbA1VAg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 16:00:36 -0500
Date: Wed, 28 Jan 2015 18:21:27 +0100
From: Borislav Petkov <bp@alien8.de>
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        H Peter Anvin <h.peter.anvin@intel.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        "Kani, Toshimitsu" <toshi.kani@hp.com>,
        "Knippers, Linda" <linda.knippers@hp.com>
Subject: Re: [PATCH v3 1/2] x86: Add support for the pcommit instruction
Message-ID: <20150128172127.GF7569@pd.tnic>
References: <1422377631-8986-1-git-send-email-ross.zwisler@linux.intel.com>
 <1422377631-8986-2-git-send-email-ross.zwisler@linux.intel.com>
 <94D0CD8314A33A4D9D801C0FE68B40295A75C517@G9W0745.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B40295A75C517@G9W0745.americas.hpqcorp.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 28, 2015 at 05:10:46PM +0000, Elliott, Robert (Server Storage) wrote:
> Should this patch series also add defines for the virtual 
> machine control data structure changes?
> 
> 1. Add the new VM-Execution Controls bit 21 as
>     SECONDARY_EXEC_PCOMMIT_EXITING 0x00200000
> to arch/x86/include/asm/vmx.h.
> 
> 2. Add the new exit reason of 64 (0x41) as
> 	EXIT_REASON_PCOMMIT  64
> to arch/x86/include/uapi/asm/vmx.h and (with a
> VMX_EXIT_REASONS string) to usr/include/asm/vmx.h.
> 
> 3. Add a kvm_vmx_exit_handler to arch/x86/kvm/vmx.c.

These look like a separate patchset for kvm enablement to me.

-- 
Regards/Gruss,
    Boris.

ECO tip #101: Trim your mails when you reply.
--
