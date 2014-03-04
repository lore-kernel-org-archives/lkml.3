Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755736AbaCDCWB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 21:22:01 -0500
Received: from smtprelay0162.hostedemail.com ([216.40.44.162]:51407 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754241AbaCDCV7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 21:21:59 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3351:3622:3865:3867:3870:4321:4559:5007:7652:7809:7974:10004:10400:10848:11232:11658:11914:12517:12519:12555:12740:13019:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: table00_68563576d8b0e
X-Filterd-Recvd-Size: 1822
Message-ID: <1393899715.20435.8.camel@joe-AO722>
Subject: Re: [PATCH] MAINTAINERS: add maintainers for arm64 acpi
From: Joe Perches <joe@perches.com>
To: Graeme Gregory <graeme.gregory@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-pm@vger.kernel.org, linux-acpi@vger.kernel.org,
        grant.likely@linaro.org, catalin.marinas@arm.com, will.deacon@arm.com,
        lenb@kernel.org, rjw@rjwysocki.net
Date: Mon, 03 Mar 2014 18:21:55 -0800
In-Reply-To: <1393899345-7397-2-git-send-email-graeme.gregory@linaro.org>
References: <1393899345-7397-1-git-send-email-graeme.gregory@linaro.org>
	 <1393899345-7397-2-git-send-email-graeme.gregory@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-03-04 at 10:15 +0800, Graeme Gregory wrote:
> Add maintainers for the arm-core file for arm64 ACPI support

Shouldn't something have to be in the kernel
tree before there's a MAINTAINERS entry?

> diff --git a/MAINTAINERS b/MAINTAINERS
> index c6d0e93..c770d3a 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -259,6 +259,13 @@ F:	drivers/pci/*/*acpi*
>  F:	drivers/pci/*/*/*acpi*
>  F:	tools/power/acpi
>  
> +ACPI ARM64
> +M:	Hanjun Guo <hanjun.guo@linaro.org>
> +M:	Graeme Gregory <graeme.gregory@linaro.org>
> +S:	Supported
> +L:	linux-acpi@vger.kernel.org
> +F:	drivers/acpi/plat/arm-core.c
> +
>  ACPI COMPONENT ARCHITECTURE (ACPICA)
>  M:	Robert Moore <robert.moore@intel.com>
>  M:	Lv Zheng <lv.zheng@intel.com>



