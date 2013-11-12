Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753184Ab3KLJZP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 04:25:15 -0500
Received: from merlin.infradead.org ([205.233.59.134]:54231 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751959Ab3KLJZM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 04:25:12 -0500
Date: Tue, 12 Nov 2013 10:24:58 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>, Dave Jones <davej@redhat.com>
Subject: Re: perf/tracepoint yet another lockup
Message-ID: <20131112092458.GL5056@laptop.programming.kicks-ass.net>
References: <alpine.DEB.2.10.1311111158420.25509@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.10.1311111720190.26895@vincent-weaver-1.um.maine.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1311111720190.26895@vincent-weaver-1.um.maine.edu>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 11, 2013 at 05:28:21PM -0500, Vince Weaver wrote:
> So are all tracepoints unsafe?  Or just a subset?

No, most should be fine. But finding the special ones seems interesting
:/

Disabling them all for now sure seems like the safe option.
