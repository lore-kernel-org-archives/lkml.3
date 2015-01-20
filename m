Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752045AbbATSTP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 13:19:15 -0500
Received: from smtprelay0107.hostedemail.com ([216.40.44.107]:54393 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751241AbbATSTO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 13:19:14 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3867:4321:5007:6261:10004:10400:10848:11026:11232:11473:11658:11914:12043:12296:12438:12517:12519:12740:13069:13311:13357:14096:14097:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: level83_8a79ed0e4774d
X-Filterd-Recvd-Size: 2279
Message-ID: <1421777950.2724.7.camel@perches.com>
Subject: Re: [PATCH] staging: dgnc: warning line over 80 characters
From: Joe Perches <joe@perches.com>
To: Mohamed Lotfy Hammad <mohamed.lotfy.hammad@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        lidza.louina@gmail.com, markh@compro.net, gregkh@linuxfoundation.org,
        driverdev-devel@linuxdriverproject.org
Date: Tue, 20 Jan 2015 10:19:10 -0800
In-Reply-To: <20150120140827.GA8352@lotfy1893-Ubuntu>
References: <20150120140827.GA8352@lotfy1893-Ubuntu>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2015-01-20 at 16:08 +0200, Mohamed Lotfy Hammad wrote:
> This patch fixes the following checkpatch.pl warning:
> fix line over 80 characters 
[]
> diff --git a/drivers/staging/dgnc/dgnc_driver.c b/drivers/staging/dgnc/dgnc_driver.c
[]
> @@ -54,14 +54,14 @@ MODULE_SUPPORTED_DEVICE("dgnc");
>   * protos for this file
>   *
>   */
> -static int		dgnc_start(void);
> -static int		dgnc_finalize_board_init(struct dgnc_board *brd);
> -static void		dgnc_init_globals(void);
> -static int		dgnc_found_board(struct pci_dev *pdev, int id);
> -static void		dgnc_cleanup_board(struct dgnc_board *brd);
> -static void		dgnc_poll_handler(ulong dummy);
> -static int		dgnc_init_one(struct pci_dev *pdev, const struct pci_device_id *ent);
> -static void		dgnc_do_remap(struct dgnc_board *brd);
> +static int dgnc_start(void);
> +static int dgnc_finalize_board_init(struct dgnc_board *brd);
> +static void dgnc_init_globals(void);
> +static int dgnc_found_board(struct pci_dev *pdev, int id);
> +static void dgnc_cleanup_board(struct dgnc_board *brd);
> +static void dgnc_poll_handler(ulong dummy);
> +static int dgnc_init_one(struct pci_dev *pdev, const struct pci_device_id *ent);
> +static void dgnc_do_remap(struct dgnc_board *brd);

Better still would be to eventually rearrange the code
to avoid the need for static forward declarations.


