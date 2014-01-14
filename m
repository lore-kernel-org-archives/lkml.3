Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751512AbaANOZk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 09:25:40 -0500
Received: from mail.skyhub.de ([78.46.96.112]:39764 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751413AbaANOZi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 09:25:38 -0500
Date: Tue, 14 Jan 2014 15:25:33 +0100
From: Borislav Petkov <bp@alien8.de>
To: Dave Hansen <dave@sr71.net>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH 00/12] [v2] Reorganize x86 Kconfig menu
Message-ID: <20140114142533.GC29887@pd.tnic>
References: <20140113192245.3F682C7F@viggo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140113192245.3F682C7F@viggo.jf.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 13, 2014 at 11:22:45AM -0800, Dave Hansen wrote:
> 
> Changes from v1:
>  * put MTRR under "Processor Options"
>  * fix circular dependency introduced in the paravirt shuffle
>  * dump extended platforms down to the end of the menu
> 
> --
> 
> The x86 "Processor type and features" menu has really been
> letting itself go over the years.  It needs to be put on a
> diet as a new-year's resolution.
> 
> This takes us from about 80 lines of options down to about 20.

Definitely a step in the right direction - thanks for doing that. A
couple of notes after staring at the new Kconfing menu:

* CONFIG_X86_X2APIC could go into "Processor Options and Features"

* We should put "Processor family (...) --->" into the main menu since
it is one of the most important ones.

* "Preemption Model" could be merged with "x86 Scheduler Options"

* Move CONFIG_SECCOMP, CONFIG_COMPAT_VDSO to obscure options?

* Move CONFIG_PHYSICAL_START to "Memory and NUMA Options"

* Maybe group CONFIG_RELOCATABLE, CONFIG_CC_STACKPROTECTOR,
 CONFIG_PHYSICAL_ALIGN to a separate "Kernel image options" menu.

* CONFIG_CMDLINE_BOOL - I don't know about this one, it certainly
doesn't fit anywhere..

Anyway, just a couple of suggestions.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
