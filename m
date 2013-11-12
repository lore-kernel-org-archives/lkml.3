Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757336Ab3KLWps (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 17:45:48 -0500
Received: from cantor2.suse.de ([195.135.220.15]:52477 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756787Ab3KLWpk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 17:45:40 -0500
Date: Tue, 12 Nov 2013 23:45:11 +0100
From: Borislav Petkov <bp@suse.de>
To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        stable@kernel.org, tglx@linutronix.de, trenn@suse.de, bp@suse.de
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86/microcode/amd: Tone down printk(), don' t
 treat a missing firmware file as an error
Message-ID: <20131112224511.GJ12854@pd.tnic>
References: <1384274383-43510-1-git-send-email-trenn@suse.de>
 <tip-11f918d3e2d3861b6931e97b3aa778e4984935aa@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <tip-11f918d3e2d3861b6931e97b3aa778e4984935aa@git.kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 12, 2013 at 01:58:00PM -0800, tip-bot for Thomas Renninger wrote:
> Commit-ID:  11f918d3e2d3861b6931e97b3aa778e4984935aa
> Gitweb:     http://git.kernel.org/tip/11f918d3e2d3861b6931e97b3aa778e4984935aa
> Author:     Thomas Renninger <trenn@suse.de>
> AuthorDate: Tue, 12 Nov 2013 17:39:43 +0100
> Committer:  Ingo Molnar <mingo@kernel.org>
> CommitDate: Tue, 12 Nov 2013 22:03:49 +0100
> 
> x86/microcode/amd: Tone down printk(), don't treat a missing firmware file as an error
> 
> Do it the same way as done in microcode_intel.c: use pr_debug()
> for missing firmware files.
> 
> There seem to be CPUs out there for which no microcode update
> has been submitted to kernel-firmware repo yet resulting in
> scary sounding error messages in dmesg:
> 
>   microcode: failed to load file amd-ucode/microcode_amd_fam16h.bin
> 
> Signed-off-by: Thomas Renninger <trenn@suse.de>
> Acked-by: Borislav Petkov <bp@suse.de>
> Cc: <stable@kernel.org>

Shouldn't that be <stable@vger.kernel.org> ?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
