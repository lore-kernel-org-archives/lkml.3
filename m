Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755181AbaCELQZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 06:16:25 -0500
Received: from merlin.infradead.org ([205.233.59.134]:48003 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751459AbaCELQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 06:16:24 -0500
Date: Wed, 5 Mar 2014 12:16:15 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Ingo Molnar <mingo@redhat.com>, linux-mips@linux-mips.org,
        linux-ia64@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 0/2] sched: Removed unused mc_capable() and smt_capable()
Message-ID: <20140305111615.GV9987@twins.programming.kicks-ass.net>
References: <20140304210621.16893.8772.stgit@bhelgaas-glaptop.roam.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140304210621.16893.8772.stgit@bhelgaas-glaptop.roam.corp.google.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 04, 2014 at 02:07:31PM -0700, Bjorn Helgaas wrote:
> This is just cleanup of a couple unused interfaces and (for sparc64) a
> supporting variable.
> 

Thanks!
