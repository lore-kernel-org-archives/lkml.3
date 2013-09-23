Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753419Ab3IWIKm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 04:10:42 -0400
Received: from smtprelay0012.hostedemail.com ([216.40.44.12]:44819 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752558Ab3IWIKk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 04:10:40 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1537:1567:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3622:3865:3867:3870:3874:4250:4321:5007:6121:7652:10004:10400:10848:11232:11658:11914:12517:12519:12740:13069:13149:13230:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: dock28_79fcebdd15619
X-Filterd-Recvd-Size: 1248
Message-ID: <1379923836.3575.19.camel@joe-AO722>
Subject: Re: [PATCH] iio: add Bosch BMG160 gyroscope sensor driver
From: Joe Perches <joe@perches.com>
To: jianlong <jianlong.gao@cn.bosch.com>
Cc: jic23@kernel.org, linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        ji.chen@cn.bosch.com, yunfei.ma2@cn.bosch.com
Date: Mon, 23 Sep 2013 01:10:36 -0700
In-Reply-To: <1379914517-2491-1-git-send-email-jianlong.gao@cn.bosch.com>
References: <1379914517-2491-1-git-send-email-jianlong.gao@cn.bosch.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-09-23 at 13:35 +0800, jianlong wrote:
> This patch adds IIO driver for Bosch BMG160 triaxial gyroscope sensor.

This code could be made a lot more readable
without the somewhat obfuscating 16 bit
compiler support.

Are there similar devices that this source
needs to support in the future or should this
code be converted to a more linux style?


