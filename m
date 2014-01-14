Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751897AbaANT1O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 14:27:14 -0500
Received: from mail.skyhub.de ([78.46.96.112]:51749 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751503AbaANT1I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 14:27:08 -0500
Date: Tue, 14 Jan 2014 20:27:02 +0100
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org,
        Aravind.Gopalakrishnan@amd.com, tglx@linutronix.de, bp@suse.de,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/microcode] x86, microcode: Move to a proper location
Message-ID: <20140114192702.GN29865@pd.tnic>
References: <tip-bad5fa631fca5466401cd4a48e30cc1f1cb6101e@git.kernel.org>
 <52D56174.9010608@zytor.com>
 <20140114185802.GB29871@pd.tnic>
 <52D58DA1.2070400@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <52D58DA1.2070400@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 14, 2014 at 11:18:57AM -0800, H. Peter Anvin wrote:
> arch/x86/cpu/microcode seems clean. I'm wondering if what is mostly
> currently in arch/x86/kernel/cpu should be mostly in something like
> arch/x86/cpu/init.

Yeah, I can start reorganizing stuff slowly and with time, the best
place will dawn on us. One thing's for sure, the "kernel" in the path is
kinda redundant because, as Ingo said, it is all kernel.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
