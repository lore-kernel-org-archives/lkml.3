Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932540AbaCDVsN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 16:48:13 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:37406 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755583AbaCDVsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 16:48:09 -0500
Date: Tue, 04 Mar 2014 16:48:06 -0500 (EST)
Message-Id: <20140304.164806.1723542180554308406.davem@davemloft.net>
To: bhelgaas@google.com
Cc: peterz@infradead.org, mingo@redhat.com, linux-mips@linux-mips.org,
        linux-ia64@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/2] sparc64: Remove unused sparc64_multi_core
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140304210744.16893.75929.stgit@bhelgaas-glaptop.roam.corp.google.com>
References: <20140304210621.16893.8772.stgit@bhelgaas-glaptop.roam.corp.google.com>
	<20140304210744.16893.75929.stgit@bhelgaas-glaptop.roam.corp.google.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 04 Mar 2014 13:48:09 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 04 Mar 2014 14:07:44 -0700

> Remove sparc64_multi_core because it's not used any more.
> 
> It was added by a2f9f6bbb30e ("Fix {mc,smt}_capable()"), and the last uses
> were removed by e637d96bf462 ("sched: Remove unused mc_capable() and
> smt_capable()").
> 
> Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>

Acked-by: David S. Miller <davem@davemloft.net>
