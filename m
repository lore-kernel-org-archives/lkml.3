Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756132AbaAIJCy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 04:02:54 -0500
Received: from merlin.infradead.org ([205.233.59.134]:54248 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753437AbaAIJCm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 04:02:42 -0500
Date: Thu, 9 Jan 2014 10:02:28 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        Chad Paradis <chad.paradis@umit.maine.edu>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [patch] perf tools: perf list broken on ARM
Message-ID: <20140109090228.GD7572@laptop.programming.kicks-ass.net>
References: <alpine.DEB.2.10.1312301536150.28814@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.10.1401081629200.4410@vincent-weaver-1.um.maine.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1401081629200.4410@vincent-weaver-1.um.maine.edu>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 08, 2014 at 04:30:17PM -0500, Vince Weaver wrote:
> 
> just checking on the status of this patch.  Am I sending it to the wrong 
> place?  Did it get lost in the post-holiday e-mail purges?  
> 
> The bug is annoying if you're trying to use perf on ARM systems.

Its for acme and he seems on the Cc, I suppose you got stuck in the
holiday backlog.
