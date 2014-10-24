Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755534AbaJXHtR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 03:49:17 -0400
Received: from smtp1.it.da.ut.ee ([193.40.5.66]:37770 "EHLO smtp1.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752127AbaJXHtP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 03:49:15 -0400
Date: Fri, 24 Oct 2014 10:49:12 +0300 (EEST)
From: Meelis Roos <mroos@linux.ee>
To: David Miller <davem@davemloft.net>
cc: linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org
Subject: Re: unaligned accesses in SLAB etc.
In-Reply-To: <20141023.172258.1371479087269518956.davem@davemloft.net>
Message-ID: <alpine.LRH.2.11.1410241048290.15464@adalberg.ut.ee>
References: <20141022.163949.1761351331649936601.davem@davemloft.net> <alpine.LRH.2.11.1410230221360.28745@adalberg.ut.ee> <20141023.130258.548864295965807596.davem@davemloft.net> <20141023.172258.1371479087269518956.davem@davemloft.net>
User-Agent: Alpine 2.11 (LRH 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > I can reproduce and I know what the problem is, fixed patch coming up
> > shortly.
> 
> Ok, please test this patch below.

Thank you, it works fine on my V210, V440 and newly added V245.

-- 
Meelis Roos (mroos@linux.ee)
