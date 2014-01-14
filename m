Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752480AbaANWN5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 17:13:57 -0500
Received: from www.sr71.net ([198.145.64.142]:54333 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751562AbaANWN4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 17:13:56 -0500
Message-ID: <52D5B649.9050103@sr71.net>
Date: Tue, 14 Jan 2014 14:12:25 -0800
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH 00/12] [v2] Reorganize x86 Kconfig menu
References: <20140113192245.3F682C7F@viggo.jf.intel.com> <20140114142533.GC29887@pd.tnic>
In-Reply-To: <20140114142533.GC29887@pd.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/14/2014 06:25 AM, Borislav Petkov wrote:
> On Mon, Jan 13, 2014 at 11:22:45AM -0800, Dave Hansen wrote:
> * CONFIG_X86_X2APIC could go into "Processor Options and Features"
> 
> * We should put "Processor family (...) --->" into the main menu since
> it is one of the most important ones.
> 
> * "Preemption Model" could be merged with "x86 Scheduler Options"
> 
> * Move CONFIG_SECCOMP, CONFIG_COMPAT_VDSO to obscure options?

I actually axed SECCOMP in another set of (arch-independent) patches.

> * Move CONFIG_PHYSICAL_START to "Memory and NUMA Options"
>
> * Maybe group CONFIG_RELOCATABLE, CONFIG_CC_STACKPROTECTOR,
>  CONFIG_PHYSICAL_ALIGN to a separate "Kernel image options" menu.

This is used in concert with a few of the crash dump options, so I think
it makes sense to keep them grouped together.

> * CONFIG_CMDLINE_BOOL - I don't know about this one, it certainly
> doesn't fit anywhere..
> 
> Anyway, just a couple of suggestions

Yup, thanks!  Those are all good suggestions.  I'll definitely take a
look at doing this in the next round.  My focus at this point is to get
this set merged before I accrue too large of a pile.
