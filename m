Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751957AbaAODCk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 22:02:40 -0500
Received: from smtprelay0249.hostedemail.com ([216.40.44.249]:60827 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751722AbaAODCg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 22:02:36 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1568:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3622:3865:3868:3872:3873:4321:5007:7652:7903:10004:10400:10848:11232:11658:11914:12043:12296:12517:12519:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: name03_8ae2c57726004
X-Filterd-Recvd-Size: 1463
Message-ID: <1389754951.14001.4.camel@joe-AO722>
Subject: Re: [PATCH] regulator: pfuze100-regulator: Fix some checkpatch
 complaints
From: Joe Perches <joe@perches.com>
To: Fabio Estevam <festevam@gmail.com>
Cc: broonie@kernel.org, linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Date: Tue, 14 Jan 2014 19:02:31 -0800
In-Reply-To: <1389754365-31863-1-git-send-email-festevam@gmail.com>
References: <1389754365-31863-1-git-send-email-festevam@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-01-15 at 00:52 -0200, Fabio Estevam wrote:
> Fix the following checkpatch error and warning:

While you're at it:

> diff --git a/drivers/regulator/pfuze100-regulator.c b/drivers/regulator/pfuze100-regulator.c
[]
> @@ -309,14 +309,17 @@ static int pfuze_identify(struct pfuze_chip *pfuze_chip)
[]
> +	case 0x8:
> +		dev_info(pfuze_chip->dev, "Assuming misprogrammed ID=0x8");

missing "\n" terminating newline and
missing break (or fallthrough comment)

> +	case 0x0:
> +		break;
> +	default:
> +		dev_warn(pfuze_chip->dev, "Illegal ID: %x\n", value);

invalid vs illegal


