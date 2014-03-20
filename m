Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759227AbaCTPGy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 11:06:54 -0400
Received: from fbr03.mfg.siteprotect.com ([64.26.60.138]:59971 "EHLO
	fbr03.mfg.siteprotect.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758109AbaCTPGv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 11:06:51 -0400
X-Greylist: delayed 556 seconds by postgrey-1.27 at vger.kernel.org; Thu, 20 Mar 2014 11:06:51 EDT
Date: Thu, 20 Mar 2014 11:01:34 -0400 (EDT)
From: Vince Weaver <vince@deater.net>
X-X-Sender: vince@pianoman.cluster.toy
To: "Yan, Zheng" <zheng.z.yan@intel.com>
cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, mingo@kernel.org,
        acme@infradead.org, eranian@google.com, andi@firstfloor.org
Subject: Re: [PATCH 4/4] perf/x86/uncore: modularize Intel uncore driver
In-Reply-To: <1395133004-23205-4-git-send-email-zheng.z.yan@intel.com>
Message-ID: <alpine.DEB.2.02.1403201059250.8477@pianoman.cluster.toy>
References: <1395133004-23205-1-git-send-email-zheng.z.yan@intel.com> <1395133004-23205-4-git-send-email-zheng.z.yan@intel.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-CTCH-Spam: Unknown
X-CTCH-RefID: str=0001.0A020202.532B01DE.020B,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Mar 2014, Yan, Zheng wrote:

> This patch adds support for building Intel uncore driver as module.
> It adds clean-up code and config option for the Intel uncore driver

so just curious, after all this time why are we suddenly making 
modularizable perf pmu drivers?

Will other pmus be modularized, or is the uncore a special case?

I'm not necessarily against the idea, it's just it's tricky enough as it 
is trying to help people with uncore pmu issues and now I will have to add 
"make sure the relevant kernel module is loaded" to the list of things 
that could be going wrong.

Vince
