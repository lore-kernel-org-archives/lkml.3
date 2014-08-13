Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753889AbaHMSY2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 14:24:28 -0400
Received: from one.firstfloor.org ([193.170.194.197]:55599 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753245AbaHMSY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 14:24:27 -0400
Date: Wed, 13 Aug 2014 20:24:25 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        namhyung@kernel.org, acme@kernel.org, mingo@kernel.org,
        peterz@infradead.org
Subject: Re: Implement lbr-as-callgraph v9
Message-ID: <20140813182425.GG4120@two.firstfloor.org>
References: <1406827029-7991-1-git-send-email-andi@firstfloor.org>
 <20140812135017.GB13247@krava.brq.redhat.com>
 <20140812205524.GF4120@two.firstfloor.org>
 <20140813072449.GA2370@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140813072449.GA2370@krava.brq.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > When I captured data like you above and run pure 'perf report'
> > > I did not get callchains displayed at all.

But you get the LBR view right? 

That was always like this, dating back to the first LBR patches.
-b auto enables it.  To get non LBR callgraph view you need --no-branch-stack

The goal of my patchkit is really to get a more useful (to me)
LBR view, but I didn't change the existing one if the option
is not specified.

-Andi
