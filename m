Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756847AbaBFT7H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 14:59:07 -0500
Received: from mga02.intel.com ([134.134.136.20]:45822 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752659AbaBFT7E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 14:59:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,795,1384329600"; 
   d="scan'208";a="479235665"
From: Andi Kleen <andi@firstfloor.org>
To: David Rientjes <rientjes@google.com>
Cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        x86@kernel.org
Subject: Re: [patch 1/4] x86, apic: Only use default_wait_for_init_deassert
References: <alpine.DEB.2.02.1402042353030.7839@chino.kir.corp.google.com>
Date: Thu, 06 Feb 2014 11:59:01 -0800
In-Reply-To: <alpine.DEB.2.02.1402042353030.7839@chino.kir.corp.google.com>
	(David Rientjes's message of "Tue, 4 Feb 2014 23:54:58 -0800 (PST)")
Message-ID: <87txcc57y2.fsf@tassilo.jf.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Rientjes <rientjes@google.com> writes:

> es7000_wait_for_init_deassert() is functionally equivalent to 
> default_wait_for_init_deassert(), so remove the duplicate code and use
> only a single function.

It would surprise me if anyone uses the es7000 anymore -- it may be
reasonable to just deprecate the complete port.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
