Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754484AbaCSUR6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 16:17:58 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:59664 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751384AbaCSUR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 16:17:57 -0400
Date: Wed, 19 Mar 2014 20:16:42 +0000
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
Subject: Re: [GIT PULL] uprobes: Add uprobes support for ARM
Message-ID: <20140319201642.GJ7528@n2100.arm.linux.org.uk>
References: <1394223040-17129-1-git-send-email-dave.long@linaro.org> <531F5799.2070302@linaro.org> <20140317235229.GQ21483@n2100.arm.linux.org.uk> <5328C585.6070100@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5328C585.6070100@linaro.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 18, 2014 at 06:15:33PM -0400, David Long wrote:
> OK, I consulted with a couple coworkers and the fix for this was  
> particularly easy.  The respun branch is in place now.  Same repo, same  
> branch name, based on v3.14-rc5.  Sorry for the newbie mistake.
>
> I'm assuming a new git-pull request is not required (until I hear  
> otherwise).

That's fine, I've re-pulled it and it all looks perfect now.  Thanks
for the quick response.

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
