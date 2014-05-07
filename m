Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751100AbaEGTnh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 15:43:37 -0400
Received: from smtprelay0083.hostedemail.com ([216.40.44.83]:49413 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750866AbaEGTng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 15:43:36 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:599:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3870:3871:4321:5007:7652:10004:10400:10848:11232:11657:11658:11914:12043:12517:12519:12740:13069:13255:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: rule05_7690d08047c15
X-Filterd-Recvd-Size: 1754
Message-ID: <1399491811.6345.3.camel@joe-AO725>
Subject: Re: [PATCH] Fixing Coding style Warnings in file
 drivers/staging/comedi/drivers/das08.h
From: Joe Perches <joe@perches.com>
To: Sheetal Tigadoli <sheetal.tigadoli@gmail.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Date: Wed, 07 May 2014 12:43:31 -0700
In-Reply-To: <1399368273-1632-1-git-send-email-sheetal.tigadoli@gmail.com>
References: <1399368273-1632-1-git-send-email-sheetal.tigadoli@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-05-06 at 14:54 +0530, Sheetal Tigadoli wrote:
>  This patch fixes coding style warnings such as 'lines exceeding 80 characters limit' & 
>  'lines begining with space character', in file drivers/staging/comedi/drivers/das08.h

This is poor patch subject style.
Please use "[PATCH] subsystem: description" style.

>  This patch is sent to complete one of Eudyptula Challenges

Please do not include any "Eudyptula Challenge" line
in the commit log.

> diff --git a/drivers/staging/comedi/drivers/das08.h b/drivers/staging/comedi/drivers/das08.h
[]
> @@ -50,7 +49,8 @@ struct das08_board_struct {
>  struct i8254_struct {
> -	int channels;		/*  available channels. Some could be used internally. */
> +	int channels;		/*  available channels. Some could be used
> +				    internally. */

Multiline comment style should use
	/*
	 * comment lines
	 * ...
	 */


