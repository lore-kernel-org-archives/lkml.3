Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751999AbaCHLS7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 06:18:59 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:43008 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751013AbaCHLS6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 06:18:58 -0500
Date: Sat, 8 Mar 2014 11:18:38 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: David Long <dave.long@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, Rabin Vincent <rabin@rab.in>,
        "Jon Medhurst (Tixy)" <tixy@linaro.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        davem@davemloft.net, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 00/15] uprobes: Add uprobes support for ARM
Message-ID: <20140308111838.GV21483@n2100.arm.linux.org.uk>
References: <1394223040-17129-1-git-send-email-dave.long@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394223040-17129-1-git-send-email-dave.long@linaro.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 07, 2014 at 03:10:25PM -0500, David Long wrote:
> From: "David A. Long" <dave.long@linaro.org>
> 
> This patch series adds basic uprobes support to ARM. It is based on patches
> developed earlier by Rabin Vincent. That approach of adding hooks into
> the kprobes instruction parsing code was not well received. This approach
> separates the ARM instruction parsing code in kprobes out into a separate set
> of functions which can be used by both kprobes and uprobes. Both kprobes and
> uprobes then provide their own semantic action tables to process the results of
> the parsing.

When you eventually get around to resubmitting this (with all the acks)
please submit as a git pull, rather than a series of patches.  Thanks.

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
