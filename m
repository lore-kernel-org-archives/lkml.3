Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752011AbaAOPnB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 10:43:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28010 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751259AbaAOPnA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 10:43:00 -0500
Date: Wed, 15 Jan 2014 16:42:16 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: acme@infradead.org, namhyung@kernel.org, mingo@kernel.org,
        dsahern@gmail.com, fweisbec@gmail.com, adrian.hunter@intel.com,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 3/6] perf, tools: Add --branch-history option to report v2
Message-ID: <20140115154216.GD17358@krava.redhat.com>
References: <1389661461-18996-1-git-send-email-andi@firstfloor.org>
 <1389661461-18996-4-git-send-email-andi@firstfloor.org>
 <20140115144442.GA14966@krava.redhat.com>
 <20140115152344.GO20765@two.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140115152344.GO20765@two.firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 15, 2014 at 04:23:44PM +0100, Andi Kleen wrote:
> > this sort of settings needs to be in for the previous patch,
> > to make the following command work:
> > 
> >   $ perf report --call-graph=fractal,0.5,callee,function,branch
> > 
> > will just set symbol_conf.use_callchain, but the sorting stays
> > as SORT_MODE__BRANCH.. and callchains are invisible
> 
> You can use --no-branch-stack

that works.. w/o srcline

> 
> > as you said in the changelog, this should be 'short cut to make this nicer to use',
> > but it's actually currently the only way..
> 
> It works, it's just very long and cumbersome.

well I'd like to see it anyway.. wouldn't need to figure out
it by looking to the code

and the example could be in the next patch then,
it's misleading to reference non existing option

jirka
