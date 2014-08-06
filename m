Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755132AbaHFCbT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 22:31:19 -0400
Received: from smtprelay0177.hostedemail.com ([216.40.44.177]:59941 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750922AbaHFCbS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 22:31:18 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3868:3870:3871:3874:4321:4605:5007:7514:7652:7875:9010:10004:10400:10848:11026:11232:11658:11914:12043:12296:12517:12519:12555:12740:13019:13069:13161:13229:13311:13357:14096:14097:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: spark20_283e95bae444e
X-Filterd-Recvd-Size: 2657
Message-ID: <1407292275.16152.115.camel@joe-AO725>
Subject: Re: [PATCH] Staging: comedi: comedidev.h: fix checkpatch code style
 issue
From: Joe Perches <joe@perches.com>
To: Dzonatans Melgalvis <dz.melgalvis@gmail.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Date: Tue, 05 Aug 2014 19:31:15 -0700
In-Reply-To: <1407281385-12576-1-git-send-email-dz.melgalvis@gmail.com>
References: <1407281385-12576-1-git-send-email-dz.melgalvis@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-08-06 at 02:29 +0300, Dzonatans Melgalvis wrote:
> Fixing checkpatch warning - blank line missing after declaration.

These are false positives from a previous version
of checkpatch.  Please use the version in -next
instead.  No errors are reported with that version.

> Signed-off-by: Dzonatans Melgalvis <dz.melgalvis@gmail.com>
> ---
>  drivers/staging/comedi/comedidev.h | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/staging/comedi/comedidev.h b/drivers/staging/comedi/comedidev.h
> index 58e58a3..c9b7978 100644
> --- a/drivers/staging/comedi/comedidev.h
> +++ b/drivers/staging/comedi/comedidev.h
> @@ -57,6 +57,7 @@ struct comedi_subdevice {
>  	const unsigned int *maxdata_list;	/* list is channel specific */
>  
>  	const struct comedi_lrange *range_table;
> +
>  	const struct comedi_lrange *const *range_table_list;
>  
>  	unsigned int *chanlist;	/* driver-owned chanlist (not used) */
> @@ -207,8 +208,10 @@ struct comedi_async {
>  	struct comedi_cmd cmd;
>  	wait_queue_head_t wait_head;
>  	unsigned int cb_mask;
> +
>  	int (*inttrig)(struct comedi_device *dev, struct comedi_subdevice *s,
>  		       unsigned int x);
> +
>  };
>  
>  struct comedi_driver {
> @@ -216,13 +219,16 @@ struct comedi_driver {
>  
>  	const char *driver_name;
>  	struct module *module;
> +
>  	int (*attach)(struct comedi_device *, struct comedi_devconfig *);
>  	void (*detach)(struct comedi_device *);
>  	int (*auto_attach)(struct comedi_device *, unsigned long);
>  
>  	/* number of elements in board_name and board_id arrays */
>  	unsigned int num_names;
> +
>  	const char *const *board_name;
> +
>  	/* offset in bytes from one board name pointer to the next */
>  	int offset;
>  };



