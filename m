Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754409AbbAVEq7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 23:46:59 -0500
Received: from smtprelay0070.hostedemail.com ([216.40.44.70]:35621 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751013AbbAVEqv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 23:46:51 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1431:1437:1515:1516:1518:1534:1539:1568:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:2895:3138:3139:3140:3141:3142:3622:3865:3867:4321:5007:6261:9010:10004:10400:10848:11232:11658:11914:12517:12519:12740:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: prose21_146585c19c0a
X-Filterd-Recvd-Size: 1590
Message-ID: <1421902005.18480.3.camel@perches.com>
Subject: Re: [PATCH] MAINTAINERS: update Qualcomm support entry
From: Joe Perches <joe@perches.com>
To: Andy Gross <agross@codeaurora.org>
Cc: Kumar Gala <galak@codeaurora.org>, David Brown <davidb@codeaurora.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-msm@vger.kernel.org
Date: Wed, 21 Jan 2015 20:46:45 -0800
In-Reply-To: <1421901564-8854-1-git-send-email-agross@codeaurora.org>
References: <1421901564-8854-1-git-send-email-agross@codeaurora.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2015-01-21 at 22:39 -0600, Andy Gross wrote:
> Added myself as a co-maintainer.  Updated the files to include the Qualcomm SoC
> directory.  Added linux-soc mailing list.
[]
> diff --git a/MAINTAINERS b/MAINTAINERS
[]
> @@ -1284,9 +1284,12 @@ S:	Maintained
>  ARM/QUALCOMM SUPPORT
>  M:	Kumar Gala <galak@codeaurora.org>
>  M:	David Brown <davidb@codeaurora.org>
> +M:	Andy Gross <agross@codeaurora.org>
>  L:	linux-arm-msm@vger.kernel.org
> +L:	linux-soc@vger.kernel.org
>  S:	Maintained
>  F:	arch/arm/mach-qcom/
> +F:	drivers/soc/qcom

Please add a terminating /

F:	drivers/soc/qcom/


