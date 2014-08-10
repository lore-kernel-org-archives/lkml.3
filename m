Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751699AbaHJVAz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2014 17:00:55 -0400
Received: from smtprelay0087.hostedemail.com ([216.40.44.87]:45246 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751215AbaHJVAx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2014 17:00:53 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3868:3873:4321:5007:7652:10004:10400:10848:11026:11657:11658:11914:12043:12438:12517:12519:12740:13069:13311:13357:14096:14097:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: start60_419fcb9802834
X-Filterd-Recvd-Size: 2001
Message-ID: <1407704449.4082.11.camel@joe-AO725>
Subject: Re: [PATCH] staging: soc_camera.c: fixed coding style: lines over
 80 char
From: Joe Perches <joe@perches.com>
To: Suman Kumar <suman@inforcecomputing.com>
Cc: hverkuil@xs4all.nl, g.liakhovetski@gmx.de, m.chehab@samsung.com,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Date: Sun, 10 Aug 2014 14:00:49 -0700
In-Reply-To: <1407703301-2037-1-git-send-email-suman@inforcecomputing.com>
References: <1407703301-2037-1-git-send-email-suman@inforcecomputing.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-08-11 at 02:11 +0530, Suman Kumar wrote:
>     Fixes a coding style issue of 'lines over 80 char' reported by
>     checkpatch.pl
[]
> diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
[]
> @@ -1430,7 +1434,7 @@ static int soc_camera_async_bound(struct v4l2_async_notifier *notifier,
>  				  struct v4l2_async_subdev *asd)
>  {
>  	struct soc_camera_async_client *sasc = container_of(notifier,
> -					struct soc_camera_async_client, notifier);
> +				    struct soc_camera_async_client, notifier);
>  	struct soc_camera_device *icd = platform_get_drvdata(sasc->pdev);

I don't easily parse the original or modified lines.

If you are really concerned abut 80 columns and readability
instead of merely quieting checkpatch, these might be better
on multiple lines like

	struct soc_camera_async_client *sasc;
	struct soc_camera_device *icd;

	sasc = container_of(notifier, struct soc_camera_async_client, notifier);
	icd = platform_get_drvdata(sasc->pdev);


