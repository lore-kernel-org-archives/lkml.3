Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754601AbaHNKkw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 06:40:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57175 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753902AbaHNKkv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 06:40:51 -0400
Date: Thu, 14 Aug 2014 12:40:10 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, namhyung@kernel.org, acme@kernel.org,
        mingo@kernel.org, peterz@infradead.org
Subject: Re: Implement lbr-as-callgraph v9
Message-ID: <20140814104010.GC10997@krava.brq.redhat.com>
References: <1406827029-7991-1-git-send-email-andi@firstfloor.org>
 <20140812135017.GB13247@krava.brq.redhat.com>
 <20140812205524.GF4120@two.firstfloor.org>
 <20140813072449.GA2370@krava.brq.redhat.com>
 <20140813182425.GG4120@two.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140813182425.GG4120@two.firstfloor.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 13, 2014 at 08:24:25PM +0200, Andi Kleen wrote:
> > > > When I captured data like you above and run pure 'perf report'
> > > > I did not get callchains displayed at all.
> 
> But you get the LBR view right? 

argh thats LBR view.. missed that

> 
> That was always like this, dating back to the first LBR patches.
> -b auto enables it.  To get non LBR callgraph view you need --no-branch-stack
> 
> The goal of my patchkit is really to get a more useful (to me)
> LBR view, but I didn't change the existing one if the option
> is not specified.

right, ook

jirka
