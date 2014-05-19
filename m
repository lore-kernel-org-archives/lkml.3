Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964962AbaESTQ0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 15:16:26 -0400
Received: from smtprelay0242.hostedemail.com ([216.40.44.242]:37969 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932431AbaESTQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 15:16:24 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1537:1560:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3622:3865:3874:4250:4321:4384:5007:7652:7903:10004:10400:10848:11232:11658:11914:12517:12519:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: bat39_8ec42503e6418
X-Filterd-Recvd-Size: 1236
Message-ID: <1400526979.14238.16.camel@joe-AO725>
Subject: Re: [PATCH 5/5] usb: gadget: net2280: Use pr_* function
From: Joe Perches <joe@perches.com>
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Cc: balbi@ti.com, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, auttamchandani@logicube.com,
        stern@rowland.harvard.edu
Date: Mon, 19 May 2014 12:16:19 -0700
In-Reply-To: <1400526693-29776-6-git-send-email-ricardo.ribalda@gmail.com>
References: <1400526693-29776-1-git-send-email-ricardo.ribalda@gmail.com>
	 <1400526693-29776-6-git-send-email-ricardo.ribalda@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-05-19 at 21:11 +0200, Ricardo Ribalda Delgado wrote:
> VDEBUG has also been replaced by DEBUG because the same	functionality
> (or even better) can be achieved with dynamic printk.

dev_vdbg exists for that purpose.


