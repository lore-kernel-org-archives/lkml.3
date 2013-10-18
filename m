Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755701Ab3JRVVu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 17:21:50 -0400
Received: from smtprelay0018.hostedemail.com ([216.40.44.18]:42914 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752814Ab3JRVVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 17:21:49 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2198:2199:2393:2559:2562:2731:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:4321:5007:7652:7809:9010:10004:10400:10848:11026:11232:11657:11658:11914:12043:12517:12519:12679:12740:13069:13180:13215:13229:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: tub98_2cc98e8631c3a
X-Filterd-Recvd-Size: 2165
Message-ID: <1382131306.2041.7.camel@joe-AO722>
Subject: Re: [PATCH 1/3] MAINTAINERS: INTEL MID SOC: add maintainers
From: Joe Perches <joe@perches.com>
To: David Cohen <david.a.cohen@linux.intel.com>
Cc: tglx@linutronix.de, hpa@zytor.com, mingo@redhat.com, x86@kernel.org,
        sathyanarayanan.kuppuswamy@linux.intel.com,
        linux-kernel@vger.kernel.org
Date: Fri, 18 Oct 2013 14:21:46 -0700
In-Reply-To: <1382131130-10903-2-git-send-email-david.a.cohen@linux.intel.com>
References: <1382131130-10903-1-git-send-email-david.a.cohen@linux.intel.com>
	 <1382131130-10903-2-git-send-email-david.a.cohen@linux.intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-10-18 at 14:18 -0700, David Cohen wrote:
> Low-power Intel MID SoC support is currently quite outdated.
> The code is meant for the old Moorestown platform and has not proper
> support for newer platforms like Medfield, Clovertrail, Merrifield, ...
> 
> This patch adds official maintainers for such platforms in order to get
> things in a better shape from now on.

>From MAINTAINERS:

Note: For the hard of thinking, this list is meant to remain in alphabetical
order. If you could add yourselves to it in alphabetical order that would be
so much easier [Ed]

> diff --git a/MAINTAINERS b/MAINTAINERS

> @@ -7570,6 +7570,15 @@ F:	arch/x86/platform/sfi/
>  F:	drivers/sfi/
>  F:	include/linux/sfi*.h
>  
> +LOW-POWER INTEL MID SOC SUPPORT
> +M:	David Cohen <david.a.cohen@linux.intel.com>
> +M:	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
> +S:	Supported
> +F:	arch/x86/platform/intel-mid/
> +F:	arch/x86/pci/intel_mid_pci.c
> +F:	arch/x86/include/asm/intel-mid.h
> +F:	arch/x86/include/asm/intel_mid*.h
> +
>  SIMTEC EB110ATX (Chalice CATS)
>  P:	Ben Dooks
>  P:	Vincent Sanders <vince@simtec.co.uk>


