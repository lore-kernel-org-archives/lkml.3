Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752018AbaANQg1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 11:36:27 -0500
Received: from mail.skyhub.de ([78.46.96.112]:36273 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751492AbaANQgX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 11:36:23 -0500
Date: Tue, 14 Jan 2014 17:36:17 +0100
From: Borislav Petkov <bp@alien8.de>
To: Ingo Molnar <mingo@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Aravind.Gopalakrishnan@amd.com, tglx@linutronix.de, bp@suse.de,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/microcode] x86, microcode: Move to a proper location
Message-ID: <20140114163617.GA29871@pd.tnic>
References: <tip-bad5fa631fca5466401cd4a48e30cc1f1cb6101e@git.kernel.org>
 <52D56174.9010608@zytor.com>
 <20140114162203.GB31037@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140114162203.GB31037@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 14, 2014 at 05:22:03PM +0100, Ingo Molnar wrote:
> Absolutely. I think moving arch/x86/kernel/cpu/ to arch/x86/cpu/
> would be a first good step. It's all kernel code, there's other
> subdirectories there that are kernel code ('pci/', 'platform/', etc.),
> so there's little point in continuing the historic accident of a
> 'kernel/' subdirectory.
>
> Once that is done we can move certain things outside as well - for
> example arch/x86/cpu/perf/ could probably move to arch/x86/events/,
> because that code is not about CPU events anymore either.

All fine and dandy with me, but I'd prefer to do this after the merge
window, i.e. for 3.15. Rushing it now would just cause unnecessary
trouble IMO.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
