Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753856Ab3GXSxz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 14:53:55 -0400
Received: from smtpauth12.mfg.siteprotect.com ([64.26.60.150]:48995 "EHLO
	smtpauth02.mfg.siteprotect.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753538Ab3GXSxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 14:53:53 -0400
Date: Wed, 24 Jul 2013 14:54:49 -0400 (EDT)
From: Vince Weaver <vince@deater.net>
X-X-Sender: vince@pianoman.cluster.toy
To: Sasha Levin <sasha.levin@oracle.com>
cc: Andi Kleen <andi@firstfloor.org>, Andi Kleen <ak@linux.intel.com>,
        acme@infradead.org, mingo@kernel.org, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, torvalds@linux-foundation.org,
        trinity@vger.kernel.org
Subject: Re: [PATCH 1/2] tools, perf: Add a precise event qualifier v2
In-Reply-To: <51EF222D.9070909@oracle.com>
Message-ID: <alpine.DEB.2.02.1307241449450.8520@pianoman.cluster.toy>
References: <1374501138-13496-1-git-send-email-andi@firstfloor.org> <alpine.DEB.2.02.1307230137160.18617@pianoman.cluster.toy> <20130723060108.GA18396@tassilo.jf.intel.com> <alpine.DEB.2.02.1307231717580.27628@pianoman.cluster.toy> <20130723225150.GT6123@two.firstfloor.org>
 <51EF222D.9070909@oracle.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-CTCH-Spam: Unknown
X-CTCH-RefID: str=0001.0A020204.51F022C1.00E7,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Jul 2013, Sasha Levin wrote:

> It's probably fine to change a testing ABI once in a while, but when things
> like trinity start breaking that often due to ABI changes in the same exact
> place, that's too much IMO.

The problem is they want the ABI to be "whatever our closely-coupled 
userspace perf tool accepts as input" which is an often-changing 
complicated (and undocumented) set of LEX and YACC parsers.

I guess we could just give in and declare that to be the official 
perf sysfs interface in the ABI documentation.  

It's frustrating trying to maintain tools that use the perf_event 
interface because the inclusion of perf in the kernel is used as an excuse 
to constantly break the ABI.

Vince
