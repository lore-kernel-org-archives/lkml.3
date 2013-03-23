Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751934Ab3CWSnT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Mar 2013 14:43:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41640 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751673Ab3CWSnS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Mar 2013 14:43:18 -0400
Date: Sat, 23 Mar 2013 19:08:01 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        benh@kernel.crashing.org, ppcdev <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [PATCH v2 1/4] uprobes: add trap variant helper
Message-ID: <20130323180801.GA4667@redhat.com>
References: <20130322151627.GB20010@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130322151627.GB20010@in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22, Ananth N Mavinakayanahalli wrote:
>
> Some architectures like powerpc have multiple variants of the trap
> instruction. Introduce an additional helper is_trap_insn() for run-time
> handling of non-uprobe traps on such architectures.

Looks fine to me.

I am going to take this into my tree, hopefully Ben won't object. The
main change is arch-agnostic and the changes in arch/powerpc are trivial.

Oleg.

