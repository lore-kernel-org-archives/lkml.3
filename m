Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752055AbaCHPab (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 10:30:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53786 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751555AbaCHPa3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 10:30:29 -0500
Date: Sat, 8 Mar 2014 16:29:08 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: David Long <dave.long@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>, Rabin Vincent <rabin@rab.in>,
        "Jon Medhurst (Tixy)" <tixy@linaro.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        davem@davemloft.net, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 01/15] uprobes: Kconfig dependency fix
Message-ID: <20140308152908.GA19605@redhat.com>
References: <1394223040-17129-1-git-send-email-dave.long@linaro.org> <1394223040-17129-2-git-send-email-dave.long@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394223040-17129-2-git-send-email-dave.long@linaro.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/07, David Long wrote:
>
> From: "David A. Long" <dave.long@linaro.org>
>
> Suggested change from Oleg Nesterov.

Actually this was suggested by Srikar ;) I hope he won't mind.

> Fixes incomplete dependencies
> for uprobes feature.

Acked-by: Oleg Nesterov <oleg@redhat.com>



Once this change is merged I'll try to untangle UPROBES and PERF.
Perhaps we should change Makefiles as Russell suggests, or we can
simply move uprobes.c to kernel/.

Oleg.

