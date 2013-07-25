Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756341Ab3GYQ2F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 12:28:05 -0400
Received: from merlin.infradead.org ([205.233.59.134]:42560 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755552Ab3GYQ2B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 12:28:01 -0400
Date: Thu, 25 Jul 2013 18:27:49 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Vince Weaver <vince@deater.net>
Cc: Adrian Hunter <adrian.hunter@intel.com>, mingo@kernel.org, hpa@zytor.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] perf: Update perf_event_type documentation
Message-ID: <20130725162749.GW27075@twins.programming.kicks-ass.net>
References: <20130716150907.GL23818@dyad.programming.kicks-ass.net>
 <tip-a5cdd40c9877e9aba704c020fd65d26b5cfecf18@git.kernel.org>
 <alpine.DEB.2.02.1307241348250.7828@pianoman.cluster.toy>
 <51F0C41C.8080005@intel.com>
 <alpine.DEB.2.02.1307250832010.18434@pianoman.cluster.toy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1307250832010.18434@pianoman.cluster.toy>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 25, 2013 at 08:34:51AM -0400, Vince Weaver wrote:
> Yes, I meant the addition of the sample_id fields to the existing sample 
> values.  Though if Peter is right and those have always been there since 
> the beginning and just not documented then that won't break anything.  
> The commit message wasn't really as clear as it could be.

/me writes "I shall write better Changelogs." a hundred times.
