Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751644AbaDNEc7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 00:32:59 -0400
Received: from smtprelay0096.hostedemail.com ([216.40.44.96]:48052 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750771AbaDNEc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 00:32:58 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:966:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1714:1730:1747:1777:1792:2196:2199:2393:2559:2562:2828:3138:3139:3140:3141:3142:3351:3622:3865:3866:3867:4321:4385:5007:7652:10004:10400:10848:11232:11658:11914:12517:12519:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: crow58_8e2a11aac1b33
X-Filterd-Recvd-Size: 1529
Message-ID: <1397449975.5243.9.camel@joe-AO722>
Subject: Re: [Patch v4 1/6] devres: introduce API "devm_kmemdup
From: Joe Perches <joe@perches.com>
To: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Cc: jic23@kernel.org, linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sun, 13 Apr 2014 21:32:55 -0700
In-Reply-To: <1397449647-31708-1-git-send-email-srinivas.pandruvada@linux.intel.com>
References: <1397449647-31708-1-git-send-email-srinivas.pandruvada@linux.intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-04-13 at 21:27 -0700, Srinivas Pandruvada wrote:
> Introduce devm_kmemdup, which uses resource managed kmalloc.
> There are several request from maintainers to add this instead
> of using kmemdup.
[]
> diff --git a/include/linux/device.h b/include/linux/device.h
[]
> @@ -629,6 +629,8 @@ static inline void *devm_kcalloc(struct device *dev,
>  }
>  extern void devm_kfree(struct device *dev, void *p);
>  extern char *devm_kstrdup(struct device *dev, const char *s, gfp_t gfp);
> +extern void *devm_kmemdup(struct device *dev, const void *src, size_t len,
> +				gfp_t gfp);

Please align the arguments to the open parenthesis.


