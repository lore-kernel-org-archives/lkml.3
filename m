Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757130AbaDQDSL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 23:18:11 -0400
Received: from smtprelay0180.hostedemail.com ([216.40.44.180]:57671 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754390AbaDQDSJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 23:18:09 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 30,2,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3350:3622:3867:3871:4321:5007:7652:7809:10004:10400:10848:11232:11658:11914:12043:12517:12519:12740:13069:13311:13357:13523:13524,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: man60_63e4856153450
X-Filterd-Recvd-Size: 1727
Message-ID: <1397704685.14062.14.camel@joe-AO725>
Subject: Re: [PATCH v3 1/4] MAINTAINERS: Add entry for APM X-Gene SoC
 ethernet driver
From: Joe Perches <joe@perches.com>
To: Iyappan Subramanian <isubramanian@apm.com>
Cc: davem@davemloft.net, netdev@vger.kernel.org, devicetree@vger.kernel.org,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, jcm@redhat.com, patches@apm.com,
        Ravi Patel <rapatel@apm.com>, Keyur Chudgar <kchudgar@apm.com>
Date: Wed, 16 Apr 2014 20:18:05 -0700
In-Reply-To: <1397702368-4846-2-git-send-email-isubramanian@apm.com>
References: <1397702368-4846-1-git-send-email-isubramanian@apm.com>
	 <1397702368-4846-2-git-send-email-isubramanian@apm.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-04-16 at 19:39 -0700, Iyappan Subramanian wrote:
> This patch adds a MAINTAINERS entry for APM X-Gene SoC
> ethernet driver.
[]
> diff --git a/MAINTAINERS b/MAINTAINERS
[]
> @@ -686,6 +686,14 @@ S:	Maintained
>  F:	drivers/net/appletalk/
>  F:	net/appletalk/
>  
> +APPLIED MICRO (APM) X-GENE SOC ETHERNET DRIVER
> +M:	Iyappan Subramanian <isubramanian@apm.com>
> +M:	Keyur Chudgar <kchudgar@apm.com>
> +M:	Ravi Patel <rapatel@apm.com>
> +S:	Maintained
> +F:	drivers/net/ethernet/apm/xgene

Please add a terminating slash to show this is a directory.

F:	drivers/net/ethernet/apm/xgene/


