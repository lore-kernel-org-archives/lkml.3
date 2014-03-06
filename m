Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754719AbaCFDZx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 22:25:53 -0500
Received: from smtprelay0196.hostedemail.com ([216.40.44.196]:51735 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752886AbaCFDZv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 22:25:51 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3867:3868:3870:3872:3874:4250:4321:5007:6119:7652:7903:10004:10400:10848:11232:11658:11914:12517:12519:12740:13069:13071:13311:13357:21060,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: spade56_32c2aab403018
X-Filterd-Recvd-Size: 1680
Message-ID: <1394076347.12070.41.camel@joe-AO722>
Subject: Re: [PATCH v2] [media] v4l: omap4iss: Add DEBUG compiler flag
From: Joe Perches <joe@perches.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Paul Bolle <pebolle@tiscali.nl>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Date: Wed, 05 Mar 2014 19:25:47 -0800
In-Reply-To: <18589524.VtEDRg43uX@avalon>
References: <1391958577.25424.22.camel@x220> <3032500.9J1uSX3lel@avalon>
	 <1394069742.12070.39.camel@joe-AO722> <18589524.VtEDRg43uX@avalon>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-03-06 at 02:52 +0100, Laurent Pinchart wrote:

Hi again Laurent

> I've thought about that, but it would require iss.h to be included before all 
> other headers. I've also thought about creating an iss-debug.h header to be 
> included first just to #define DEBUG, but decided to go for handling the OMAP4 
> ISS debug option in the Makefile instead. If that's ugly and discouraged as 
> reported by Mauro I can try to come up with something else.

Unless debugging logging statements are in system level static inlines,
adding #define DEBUG to iss.h should otherwise produce the same output
as -DDEBUG in a Makefile.

