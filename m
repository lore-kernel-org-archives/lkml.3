Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752749Ab3JaFrc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 01:47:32 -0400
Received: from smtprelay0037.hostedemail.com ([216.40.44.37]:56813 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750845Ab3JaFrb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 01:47:31 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:3871:3874:4250:4321:5007:7652:10004:10400:10848:11026:11232:11657:11658:11914:12043:12438:12517:12519:12740:13069:13311:13357:13972,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: sheep73_4176386390d46
X-Filterd-Recvd-Size: 1642
Message-ID: <1383198448.24582.3.camel@joe-AO722>
Subject: Re: [PATCH 2/2] perf/x86/intel: Add Ivy Bridge-EP uncore IRP box
 support
From: Joe Perches <joe@perches.com>
To: "Yan, Zheng" <zheng.z.yan@intel.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, ak@linux.intel.com,
        eranian@google.com
Date: Wed, 30 Oct 2013 22:47:28 -0700
In-Reply-To: <1383197815-17706-2-git-send-email-zheng.z.yan@intel.com>
References: <1383197815-17706-1-git-send-email-zheng.z.yan@intel.com>
	 <1383197815-17706-2-git-send-email-zheng.z.yan@intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-10-31 at 13:36 +0800, Yan, Zheng wrote:
> Unlike other uncore boxes, IRP boxes live in PCI buses with no UBOX
> device. For PCI bus without UBOX device, we find the next bus that
> has UBOX device and use its 'bus to socket' mapping.
[]
> diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
[]
> @@ -997,6 +997,20 @@ static int snbep_pci2phy_map_init(int devid)
[]
> +/* registers in IRP boxes are not properly aligned */
> +static unsigned ivt_uncore_irp_ctls[] = {0xd8, 0xdc, 0xe0, 0xe4};
> +static unsigned ivt_uncore_irp_ctrs[] = {0xa0, 0xb0, 0xb8, 0xc0};

Using this sort of naming is like asking for a typo
or a copy/paste defect.


