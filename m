Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753422AbaHECCY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 22:02:24 -0400
Received: from smtprelay0220.hostedemail.com ([216.40.44.220]:41150 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753160AbaHECCX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 22:02:23 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:599:960:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2194:2199:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3867:3868:3871:3872:3874:4225:4321:4605:5007:7652:10004:10400:10471:10848:11232:11657:11658:11914:12043:12296:12517:12519:12740:13069:13255:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: humor85_1488d0de1e323
X-Filterd-Recvd-Size: 1853
Message-ID: <1407204139.16152.106.camel@joe-AO725>
Subject: Re: [PATCH v2 8/8] staging: iio: accel: sca3000_core.c: Add blank
 line between declarations and code
From: Joe Perches <joe@perches.com>
To: Murilo Opsfelder Araujo <mopsfelder@gmail.com>
Cc: linux-iio@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        jic23@kernel.org
Date: Mon, 04 Aug 2014 19:02:19 -0700
In-Reply-To: <1407203223-9700-9-git-send-email-mopsfelder@gmail.com>
References: <1407203223-9700-1-git-send-email-mopsfelder@gmail.com>
	 <1407203223-9700-9-git-send-email-mopsfelder@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-08-04 at 22:47 -0300, Murilo Opsfelder Araujo wrote:
> This patch adds missing blank line between declarations and code, and
> adjust code to fit 80-chars limit.
[]
> diff --git a/drivers/staging/iio/accel/sca3000_core.c b/drivers/staging/iio/accel/sca3000_core.c
[]
> @@ -506,7 +506,8 @@ static int sca3000_read_raw(struct iio_dev *indio_dev,
>  				mutex_unlock(&st->lock);
>  				return ret;
>  			}
> -			*val = ((st->rx[0] & 0x3F) << 3) | ((st->rx[1] & 0xE0) >> 5);
> +			*val = ((st->rx[0] & 0x3F) << 3)
> +				| ((st->rx[1] & 0xE0) >> 5);

Please don't strain to fit 80 columns.

If this is done, please strive to make it
quickly intelligible for humans.

I think this would be better as:

+			*val = ((st->rx[0] & 0x3F) << 3) |
+			       ((st->rx[1] & 0xE0) >> 5);

so that the mask and shift are aligned.


