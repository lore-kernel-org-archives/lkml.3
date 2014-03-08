Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751792AbaCHLSM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 06:18:12 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:42989 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751013AbaCHLSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 06:18:07 -0500
Date: Sat, 8 Mar 2014 11:17:15 +0000
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
Subject: Re: [PATCH v7 01/15] uprobes: Kconfig dependency fix
Message-ID: <20140308111715.GU21483@n2100.arm.linux.org.uk>
References: <1394223040-17129-1-git-send-email-dave.long@linaro.org> <1394223040-17129-2-git-send-email-dave.long@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394223040-17129-2-git-send-email-dave.long@linaro.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 07, 2014 at 03:10:26PM -0500, David Long wrote:
> From: "David A. Long" <dave.long@linaro.org>
> 
> Suggested change from Oleg Nesterov. Fixes incomplete dependencies
> for uprobes feature.
> 
> Signed-off-by: David A. Long <dave.long@linaro.org>

I think Oleg needs to ack this change before it can be taken.

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
