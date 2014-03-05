Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756516AbaCEEhr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 23:37:47 -0500
Received: from gate.crashing.org ([63.228.1.57]:54907 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755070AbaCEEhp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 23:37:45 -0500
Message-ID: <1393994178.11372.2.camel@pasglop>
Subject: Re: [PATCH 1/2] sched: Remove unused mc_capable() and smt_capable()
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        linux-mips@linux-mips.org, linux-ia64@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-arm-kernel@lists.infradead.org
Date: Wed, 05 Mar 2014 15:36:18 +1100
In-Reply-To: <20140304210737.16893.54289.stgit@bhelgaas-glaptop.roam.corp.google.com>
References: <20140304210621.16893.8772.stgit@bhelgaas-glaptop.roam.corp.google.com>
	 <20140304210737.16893.54289.stgit@bhelgaas-glaptop.roam.corp.google.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.11.90 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-03-04 at 14:07 -0700, Bjorn Helgaas wrote:
> Remove mc_capable() and smt_capable().  Neither is used.
> 
> Both were added by 5c45bf279d37 ("sched: mc/smt power savings sched
> policy").  Uses of both were removed by 8e7fbcbc22c1 ("sched: Remove stale
> power aware scheduling remnants and dysfunctional knobs").
> 
> Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>

Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>


