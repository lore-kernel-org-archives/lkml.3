Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754776AbaHAPUG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 11:20:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11413 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754084AbaHAPUD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 11:20:03 -0400
Date: Fri, 1 Aug 2014 17:19:20 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Jiri Olsa <jolsa@kernel.org>, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>, Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH 1/3] perf: Do not allow to create kernel events without
 handler
Message-ID: <20140801151920.GA1186@krava.brq.redhat.com>
References: <1406896382-18404-1-git-send-email-jolsa@kernel.org>
 <1406896382-18404-2-git-send-email-jolsa@kernel.org>
 <20140801145637.GB9918@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140801145637.GB9918@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 01, 2014 at 04:56:37PM +0200, Peter Zijlstra wrote:
> On Fri, Aug 01, 2014 at 02:33:00PM +0200, Jiri Olsa wrote:
> > Force kernel events to specify the handler, because
> > there's no use for kernel perf event without it.
> > 
> 
> I think I found a reason; although there is currently no such user, the
> simple counting events, they don't have overflow handlers at all.

ah right.. ok 

jirka
