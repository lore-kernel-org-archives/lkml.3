Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753762AbaFBROU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 13:14:20 -0400
Received: from smtprelay0217.hostedemail.com ([216.40.44.217]:52616 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752960AbaFBROR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 13:14:17 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:1801:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3871:3872:4321:4605:5007:7652:7903:9040:10004:10400:10848:11232:11658:11914:12043:12296:12517:12519:12663:12740:13019:13069:13071:13163:13229:13255:13311:13357:21060,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: wish08_24e6f974c975a
X-Filterd-Recvd-Size: 1818
Message-ID: <1401729252.5770.13.camel@joe-AO725>
Subject: Re: [PATCH] fix some coding style problem in
 drivers/staging/iio/frequency/ad9832.c
From: Joe Perches <joe@perches.com>
To: Federico Di Pierro <nierro92@gmail.com>
Cc: jic23@kernel.org, gregkh@linuxfoundation.org, jg1.han@samsung.com,
        sachin.kamat@linaro.org, linux-iio@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Date: Mon, 02 Jun 2014 10:14:12 -0700
In-Reply-To: <538CAEBD.5040501@gmail.com>
References: <538CAEBD.5040501@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-06-02 at 19:05 +0200, Federico Di Pierro wrote:
> Hi!

Hello Federico.

> This is my latest task of the eudyptula challenge.

Your patch subject should be something like:

[PATCH] staging: iio: kernel style neatening

> Just a very small patch! It fixes 3 little coding style problems.
> I'm using linux-next.

linux/drivers/staging/iio/frequency/ad9832.c
[]
@@ -73,7 +73,7 @@ static int ad9832_write_phase(struct ad9
 }
 
 static ssize_t ad9832_write(struct device *dev,
-               struct device_attribute *attr,
+                           struct device_attribute *attr,
                const char *buf,
                size_t len)


checkpatch is a brainless little tool.

Please make sure your own brain is engaged when
acting on or verifying any warnings it emits.

Please expand the indented line range to include
all the arguments of the function.



