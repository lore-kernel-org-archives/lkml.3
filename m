Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933622AbaLEB5z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 20:57:55 -0500
Received: from smtprelay0007.hostedemail.com ([216.40.44.7]:38717 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933599AbaLEB5t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 20:57:49 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:599:800:960:967:968:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1431:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2198:2199:2393:2525:2561:2564:2682:2685:2731:2828:2859:2895:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3352:3622:3865:3868:3870:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4250:4321:4659:5007:6117:6119:6261:7514:7809:7903:9010:9012:9025:10004:10400:10848:11232:11658:11914:12043:12296:12517:12519:12740:13069:13072:13255:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: gold67_612bbe0f0b305
X-Filterd-Recvd-Size: 1787
Message-ID: <1417744666.2721.33.camel@perches.com>
Subject: Re: [PATCH 1/1] tpm_ibmvtpm: Update email address in maintainers
 list and ibmvtpm driver
From: Joe Perches <joe@perches.com>
To: Ashley Lai <ashleydlai@gmail.com>
Cc: tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Date: Thu, 04 Dec 2014 17:57:46 -0800
In-Reply-To: <1417742242-13016-1-git-send-email-ashleydlai@gmail.com>
References: <1417742242-13016-1-git-send-email-ashleydlai@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-12-04 at 19:17 -0600, Ashley Lai wrote:
> Added myself as a maintainer for the IBM vtpm driver and removed myself
> from the tpm maintainer list. Also, updated the tpm_ibmvtpm driver with
> my current email address.
[]
> diff --git a/MAINTAINERS b/MAINTAINERS
[]
> @@ -9297,13 +9297,19 @@ F:	drivers/media/usb/tm6000/
>  
>  TPM DEVICE DRIVER
>  M:	Peter Huewe <peterhuewe@gmx.de>
> -M:	Ashley Lai <ashley@ashleylai.com>
>  M:	Marcel Selhorst <tpmdd@selhorst.net>
>  W:	http://tpmdd.sourceforge.net
>  L:	tpmdd-devel@lists.sourceforge.net (moderated for non-subscribers)
>  S:	Maintained
>  F:	drivers/char/tpm/
>  
> +IBM VTPM DEVICE DRIVER
> +M:	Ashley Lai <ashleydlai@gmail.com>
> +W:	http://tpmdd.sourceforge.net
> +L:	tpmdd-devel@lists.sourceforge.net (moderated for non-subscribers)
> +S:	Maintained
> +F:	drivers/char/tpm/tpm_ibmvtpm*
> +

Please keep this file sections in alphabetical order

