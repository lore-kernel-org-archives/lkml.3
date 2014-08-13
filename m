Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753012AbaHMUOk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 16:14:40 -0400
Received: from mail.kernel.org ([198.145.19.201]:50570 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752580AbaHMUOj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 16:14:39 -0400
Date: Wed, 13 Aug 2014 17:14:34 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: naota@elisp.net, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH] perf report: Set proper sort__mode for the branch option
Message-ID: <20140813201434.GI2718@kernel.org>
References: <87y4v1fylq.fsf@elisp.net>
 <877g2ddjsx.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <877g2ddjsx.fsf@sejong.aot.lge.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Aug 13, 2014 at 02:45:34PM +0900, Namhyung Kim escreveu:
> Hi Naohiro,
> 
> (CC'ing Stephane)
> 
> > When you specify "--branch-stack"("-b" for short) or
> > "--no-branch-stack", "branch_mode" variable is set to 1 or 0
> > respectively. However, the code is just checking if the variable is -1
> > or not, ignoring "branch_mode == 1" case. Thus "perf report -b" dose not
> > show its result with the branch sorted mode. This patch fix the problem.
> >
> > Signed-off-by: Naohiro Aota <naota@elisp.net>
> 
> Acked-by: Namhyung Kim <namhyung@kernel.org>
> 
> Thanks for fixing this!
> Namhyung

Thanks, applied.

- Arnaldo
