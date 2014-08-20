Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752002AbaHTBTz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 21:19:55 -0400
Received: from smtprelay0186.hostedemail.com ([216.40.44.186]:41715 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751728AbaHTBTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 21:19:54 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:599:965:966:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1568:1593:1594:1711:1714:1730:1747:1777:1792:2106:2196:2199:2393:2559:2562:2828:2901:3138:3139:3140:3141:3142:3622:3865:3866:3867:3868:3870:4250:4321:4385:4390:4395:4605:5007:6117:6119:6120:7652:8957:10004:10400:10848:11026:11232:11658:11914:12043:12291:12517:12519:12683:12740:13069:13311:13357:14110:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: floor84_55f3847a18b4e
X-Filterd-Recvd-Size: 1563
Message-ID: <1408497589.23250.12.camel@joe-AO725>
Subject: Re: [RFC PATCH 1/4 v2] drivers/bus: Added Freescale Management
 Complex APIs
From: Joe Perches <joe@perches.com>
To: "J. German Rivera" <German.Rivera@freescale.com>
Cc: gregkh@linuxfoundation.org, arnd@arndb.de, linux-kernel@vger.kernel.org,
        stuart.yoder@freescale.com, linuxppc-release@linux.freescale.net
Date: Tue, 19 Aug 2014 18:19:49 -0700
In-Reply-To: <1408496070-6252-2-git-send-email-German.Rivera@freescale.com>
References: <1408496070-6252-1-git-send-email-German.Rivera@freescale.com>
	 <1408496070-6252-2-git-send-email-German.Rivera@freescale.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-08-19 at 19:54 -0500, J. German Rivera wrote:
> APIs to access the Management Complex (MC) hardware
> module of Freescale LS2 SoCs. This patch includes
> APIs to check the MC firmware version and to manipulate
> DPRC objects in the MC.
[]
>  include/linux/fsl_dpmng.h          |  120 ++++++
>  include/linux/fsl_dprc.h           |  790 ++++++++++++++++++++++++++++++++++++
>  include/linux/fsl_mc_cmd.h         |  182 +++++++++
>  include/linux/fsl_mc_sys.h         |   50 +++

Why should any of these files be put in include/linux?


