Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752085AbaAOPXs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 10:23:48 -0500
Received: from one.firstfloor.org ([193.170.194.197]:34159 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684AbaAOPXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 10:23:45 -0500
Date: Wed, 15 Jan 2014 16:23:44 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, acme@infradead.org, namhyung@kernel.org,
        mingo@kernel.org, dsahern@gmail.com, fweisbec@gmail.com,
        adrian.hunter@intel.com, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 3/6] perf, tools: Add --branch-history option to report
 v2
Message-ID: <20140115152344.GO20765@two.firstfloor.org>
References: <1389661461-18996-1-git-send-email-andi@firstfloor.org>
 <1389661461-18996-4-git-send-email-andi@firstfloor.org>
 <20140115144442.GA14966@krava.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140115144442.GA14966@krava.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> this sort of settings needs to be in for the previous patch,
> to make the following command work:
> 
>   $ perf report --call-graph=fractal,0.5,callee,function,branch
> 
> will just set symbol_conf.use_callchain, but the sorting stays
> as SORT_MODE__BRANCH.. and callchains are invisible

You can use --no-branch-stack

> as you said in the changelog, this should be 'short cut to make this nicer to use',
> but it's actually currently the only way..

It works, it's just very long and cumbersome.

-Andi
