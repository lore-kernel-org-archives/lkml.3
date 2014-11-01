Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759682AbaKARTP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 13:19:15 -0400
Received: from mail.skyhub.de ([78.46.96.112]:54351 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759392AbaKARTM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2014 13:19:12 -0400
Date: Sat, 1 Nov 2014 18:19:09 +0100
From: Borislav Petkov <bp@alien8.de>
To: Steven Honeyman <stevenhoneyman@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Jiri Kosina <trivial@kernel.org>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86, cpu: trivial printk formatting fixes
Message-ID: <20141101171909.GA5034@pd.tnic>
References: <1414856696-8094-1-git-send-email-stevenhoneyman@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1414856696-8094-1-git-send-email-stevenhoneyman@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 01, 2014 at 03:44:56PM +0000, Steven Honeyman wrote:
> A 2 line printk makes dmesg output messy, because the second line does not get a timestamp.
> For example:
> 
> [    0.012863] CPU0: Thermal monitoring enabled (TM1)
> [    0.012869] Last level iTLB entries: 4KB 1024, 2MB 1024, 4MB 1024
> Last level dTLB entries: 4KB 1024, 2MB 1024, 4MB 1024, 1GB 4
> [    0.012958] Freeing SMP alternatives memory: 28K (ffffffff81d86000 - ffffffff81d8d000)
> [    0.014961] dmar: Host address width 39

It looks just fine here, albeit with repeated timestamp:

$ dmesg | grep -E "[id]TLB"
[    0.269607] Last level iTLB entries: 4KB 512, 2MB 1024, 4MB 512
[    0.269607] Last level dTLB entries: 4KB 1024, 2MB 1024, 4MB 512, 1GB 0

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
