Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751673AbaCFQsH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 11:48:07 -0500
Received: from smtprelay0186.hostedemail.com ([216.40.44.186]:58945 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750794AbaCFQsF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 11:48:05 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:541:599:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1568:1593:1594:1711:1714:1730:1747:1777:1792:2110:2198:2199:2393:2559:2562:2731:2828:3138:3139:3140:3141:3142:3622:3865:3867:3871:3872:3874:4250:4321:5007:7652:10004:10400:10450:10455:10848:11232:11658:11914:12517:12519:12740:13069:13311:13357:19904:19999:21063,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: gold34_460704c49dd33
X-Filterd-Recvd-Size: 1486
Message-ID: <1394124479.12070.62.camel@joe-AO722>
Subject: Re: [PATCH v2] [media] v4l: omap4iss: Add DEBUG compiler flag
From: Joe Perches <joe@perches.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Paul Bolle <pebolle@tiscali.nl>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Date: Thu, 06 Mar 2014 08:47:59 -0800
In-Reply-To: <2183657.tkSdBlXoCc@avalon>
References: <1391958577.25424.22.camel@x220> <18589524.VtEDRg43uX@avalon>
	 <1394076347.12070.41.camel@joe-AO722> <2183657.tkSdBlXoCc@avalon>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-03-06 at 11:55 +0100, Laurent Pinchart wrote:
> We thus need the #define DEBUG it appear before the first time device.h is 
> included, either directly or indirectly. Adding #define DEBUG to iss.h won't 
> work now as iss.h is included after all system includes (which is the usual 
> practice, #include <...> come before #include "...").

Ahh, right, good point.
I'd forgotten about that include order dependency.

cheers, Joe

