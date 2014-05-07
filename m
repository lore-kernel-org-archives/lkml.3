Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751479AbaEGQ6U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 12:58:20 -0400
Received: from mail-lb0-f170.google.com ([209.85.217.170]:49071 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282AbaEGQ6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 12:58:15 -0400
Date: Wed, 7 May 2014 20:58:11 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: perf_fuzzer crash on pentium 4
Message-ID: <20140507165811.GG1444@moon>
References: <alpine.DEB.2.10.1405061137560.3220@vincent-weaver-1.umelst.maine.edu>
 <20140506202307.GA1458@moon>
 <alpine.DEB.2.10.1405061729350.4849@vincent-weaver-1.umelst.maine.edu>
 <20140506214630.GB1458@moon>
 <alpine.DEB.2.10.1405071244570.6340@vincent-weaver-1.umelst.maine.edu>
 <20140507164902.GD1444@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140507164902.GD1444@moon>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 07, 2014 at 08:49:02PM +0400, Cyrill Gorcunov wrote:
> On Wed, May 07, 2014 at 12:46:24PM -0400, Vince Weaver wrote:
> > 
> > sorry for the delay, I like to compile kernels locally and it takes a 
> > really long time to build a ftrace-enabled kernel on a pentium 4 it seems.
> > 
> > Anyway I threw some printks in, and this is what I get:
> > 
> > [  447.572626] VMW: bind=NULL config=6b6b6b6b6b6b6b6b
> > 
> > I have slab poisoning turned on.  Use after free?
> 
> Looks so. It's list poison iirc, thus i think it comes from upper level,
> ie from perf general code.

Vince, I'm trying to figure out where it might come from, but no
ideas yet.
