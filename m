Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030491Ab3E3Jhq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 05:37:46 -0400
Received: from merlin.infradead.org ([205.233.59.134]:43071 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030472Ab3E3Jhg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 05:37:36 -0400
Date: Thu, 30 May 2013 11:37:17 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Dave Hansen <dave@sr71.net>
Cc: mingo@redhat.com, paulus@samba.org, acme@ghostprotocols.net,
        tglx@linutronix.de, x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [v3][PATCH 2/4] x86: warn when NMI handlers take large amounts
 of time
Message-ID: <20130530093717.GM12193@twins.programming.kicks-ass.net>
References: <20130529222756.25535229@viggo.jf.intel.com>
 <20130529222759.6D8C68B2@viggo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130529222759.6D8C68B2@viggo.jf.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 29, 2013 at 03:27:59PM -0700, Dave Hansen wrote:
 
> +static u64 nmi_longest_ns = 1000 * 1000 * 1000;

1s? Isn't that a tad too long?

FWIW there's NSEC_PER_{U,M,}SEC for such cases, I find those macros
increase readability.
