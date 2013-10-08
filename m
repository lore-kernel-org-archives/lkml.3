Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755633Ab3JHPka (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 11:40:30 -0400
Received: from smtpauth03h.mfg.siteprotect.com ([64.26.60.134]:51865 "EHLO
	smtpauth03.mfg.siteprotect.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754417Ab3JHPk1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 11:40:27 -0400
Date: Tue, 8 Oct 2013 11:42:15 -0400 (EDT)
From: Vince Weaver <vince@deater.net>
X-X-Sender: vince@pianoman.cluster.toy
To: Ingo Molnar <mingo@kernel.org>
cc: Andi Kleen <andi@firstfloor.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, peterz@infradead.org,
        Andi Kleen <ak@linux.intel.com>, fweisbec@gmail.com
Subject: Re: [PATCH 6/6] x86: Allow disabling HW_BREAKPOINTS and
 PERF_EVENTS
In-Reply-To: <20131008065938.GA4333@gmail.com>
Message-ID: <alpine.DEB.2.02.1310081134120.24409@pianoman.cluster.toy>
References: <1380922788-23112-1-git-send-email-andi@firstfloor.org> <1380922788-23112-7-git-send-email-andi@firstfloor.org> <20131006164934.GA15167@gmail.com> <20131008065938.GA4333@gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-CTCH-Spam: Unknown
X-CTCH-RefID: str=0001.0A020207.5254276B.005B,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Oct 2013, Ingo Molnar wrote:

> The base cost of perf is +151k - not small but a far cry from your claimed 
> +700k ...

Things might get that bad if we enable full event lists in the kernel for 
all of x86, as Power is starting to do.

The patch to add all Power7 events cfe0d8ba14a1d98245b371e486c68f37eba1ca52
increased kernel size by like 50k.  Imagine 10 different x86 event tables
times 50k each and you're talking a big chunk of memory.

Vince
