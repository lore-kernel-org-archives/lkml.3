Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754476AbaDRQtY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 12:49:24 -0400
Received: from one.firstfloor.org ([193.170.194.197]:40838 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751667AbaDRQtQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 12:49:16 -0400
Date: Fri, 18 Apr 2014 18:49:14 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: "Yan, Zheng" <zheng.z.yan@intel.com>, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, acme@infradead.org, eranian@google.com,
        andi@firstfloor.org
Subject: Re: [PATCH v2 4/4] perf/x86/uncore: modularize Intel uncore driver
Message-ID: <20140418164914.GL22728@two.firstfloor.org>
References: <1395295426-12391-1-git-send-email-zheng.z.yan@intel.com>
 <20140418105354.GA29167@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140418105354.GA29167@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So I'm not willing to apply this patch until the documentation of 
> perf_event_intel_uncore.c is improved. Right now the file starts 
> without a single comment (!). Just lines after lines of code, without 
> any explanation what it does, what its scope is, etc.
> 
> How should even a knowledgable user know about what it's all about?

While I agree with you that the lack of documentation is bad,
I want to point out that the rest of perf (except for some recent
code from Stephane) doesn't have any such file comments and useful
Kconfig descriptions either.

It seems unfair and inconsistent to require contributors to follow rules that
is not followed by the original code.

-Andi

