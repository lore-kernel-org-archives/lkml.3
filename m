Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756975Ab3HLPQp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 11:16:45 -0400
Received: from merlin.infradead.org ([205.233.59.134]:57507 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755720Ab3HLPQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 11:16:44 -0400
Date: Mon, 12 Aug 2013 17:16:32 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Yan, Zheng" <zheng.z.yan@intel.com>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, ak@linux.intel.com
Subject: Re: [PATCH 3/3] perf, uncore: enable ev_sel_ext bit for PCU.
Message-ID: <20130812151632.GM27162@twins.programming.kicks-ass.net>
References: <1375856245-10717-1-git-send-email-zheng.z.yan@intel.com>
 <1375856245-10717-3-git-send-email-zheng.z.yan@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375856245-10717-3-git-send-email-zheng.z.yan@intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 07, 2013 at 02:17:25PM +0800, Yan, Zheng wrote:
> From: "Yan, Zheng" <zheng.z.yan@intel.com>
> 
> PCU uncore event control register has a undocumented ev_sel_ext bit.
> The bit is needed by Andi's pmu-tools.

Please provide documentation. Andi needing it isn't a good changelog (or
even reason).
