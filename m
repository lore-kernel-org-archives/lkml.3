Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756934Ab3GVQEg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 12:04:36 -0400
Received: from merlin.infradead.org ([205.233.59.134]:47193 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755530Ab3GVQEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 12:04:35 -0400
Date: Mon, 22 Jul 2013 13:04:29 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        fweisbec@gmail.com
Subject: Re: [PATCH] perf, tools: Support callchain sorting based on addresses
Message-ID: <20130722160429.GH2157@ghostprotocols.net>
References: <1374187370-14183-1-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374187370-14183-1-git-send-email-andi@firstfloor.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Jul 18, 2013 at 03:42:50PM -0700, Andi Kleen escreveu:
> From: Andi Kleen <ak@linux.intel.com>
> 
> With programs with very large functions it can be useful to distinguish
> the callgraph nodes on more than just function names. So for example if
> you have multiple calls to the same function, it ends up being
> separate nodes in the chain.
> 
> This patch adds a new key field to the callgraph options, that
> allows comparing nodes on functions (as today, default) and addresses.

Thanks, applied.

- Arnaldo
