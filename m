Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932140AbaCTI1a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 04:27:30 -0400
Received: from merlin.infradead.org ([205.233.59.134]:57203 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754736AbaCTI12 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 04:27:28 -0400
Date: Thu, 20 Mar 2014 09:27:21 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: "Yan, Zheng" <zheng.z.yan@intel.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, acme@infradead.org,
        eranian@google.com, andi@firstfloor.org
Subject: Re: [PATCH v2 4/4] perf/x86/uncore: modularize Intel uncore driver
Message-ID: <20140320082721.GG8557@laptop.programming.kicks-ass.net>
References: <1395295426-12391-1-git-send-email-zheng.z.yan@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1395295426-12391-1-git-send-email-zheng.z.yan@intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 20, 2014 at 02:03:46PM +0800, Yan, Zheng wrote:
> This patch adds support for building Intel uncore driver as module.
> It adds clean-up code and config option for the Intel uncore driver
> 
> Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
> ---
> Changes since v1:
>  move config option to "General setup/Kernel Performance Events and Counters"

Thanks!
