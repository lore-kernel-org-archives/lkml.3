Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756491Ab3BRRZs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 12:25:48 -0500
Received: from mail-ve0-f181.google.com ([209.85.128.181]:51826 "EHLO
	mail-ve0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756085Ab3BRRZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 12:25:46 -0500
Date: Mon, 18 Feb 2013 12:24:38 -0500
From: Frederik Deweerdt <frederik.deweerdt@xprog.eu>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [patch] perf stat: --repeat forever
Message-ID: <20130218172438.GB5199@ks398093.ip-192-95-24.net>
References: <20130215222849.GA5199@ks398093.ip-192-95-24.net>
 <20130218150444.GB1915@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130218150444.GB1915@ghostprotocols.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnaldo,

On Mon, Feb 18, 2013 at 12:04:44PM -0300, Arnaldo Carvalho de Melo wrote:
> Em Fri, Feb 15, 2013 at 05:28:49PM -0500, Frederik Deweerdt escreveu:
> > Hi,
> > 
> > The following patch causes 'perf stat --repeat 0' to be interpreted as
> > 'forever', displaying the stats for every run.
> > 
> > We act as if a single run was asked, and reset the stats in each
> > iteration. In this mode SIGINT is passed to perf to be able to stop the
> > loop with Ctrl+C.
> 
> It is not applying to my perf/core branch, please take a look at:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux
> 
> branch perf/core
> 
Noted, I'll base the next version based on this branch.

> Also please consider removing the need to specify 0, i.e. I think this
> is possible and shorter:
> 
> # perf stat -a --repeat sleep 1

I'm unsure how to achieve that. I've looked at the different OPT_*
defines, but I can't find one that would do the job. Any pointers?

Thanks,
Frederik
