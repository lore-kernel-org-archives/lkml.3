Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756700Ab3GDM5u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 08:57:50 -0400
Received: from merlin.infradead.org ([205.233.59.134]:39196 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756523Ab3GDM5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 08:57:47 -0400
Date: Thu, 4 Jul 2013 14:57:00 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Michael Ellerman <michael@ellerman.id.au>
Cc: Vince Weaver <vince@deater.net>, Runzhen Wang <runzhen@linux.vnet.ibm.com>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        paulus@samba.org, acme@redhat.com, mingo@kernel.org,
        vincent.weaver@maine.edu, Stephane Eranian <eranian@google.com>,
        sukadev@linux.vnet.ibm.com, xiaoguangrong@linux.vnet.ibm.com
Subject: Re: [PATCH v2 2/2] perf tools: Make Power7 events available for perf
Message-ID: <20130704125700.GM18898@dyad.programming.kicks-ass.net>
References: <1372170933-4538-1-git-send-email-runzhen@linux.vnet.ibm.com>
 <1372170933-4538-3-git-send-email-runzhen@linux.vnet.ibm.com>
 <alpine.DEB.2.02.1306251240440.25443@pianoman.cluster.toy>
 <20130704125218.GA21134@concordia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130704125218.GA21134@concordia>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 04, 2013 at 10:52:18PM +1000, Michael Ellerman wrote:
> I don't think it even needs libpfm4, just some csv files in tools/perf
> would do the trick.

Right; I think Stephane and Jiri are in favour of creating a 'new' project that
includes just the event definitions in a plain text format and a little library
with parser to be used by all interested parties.

Its just not something that's moving along at any pace at all atm :/
