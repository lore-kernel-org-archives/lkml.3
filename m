Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933343AbaFUCem (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 22:34:42 -0400
Received: from smtprelay0077.hostedemail.com ([216.40.44.77]:37632 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755934AbaFUCel (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 22:34:41 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1537:1561:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2693:2828:3138:3139:3140:3141:3142:3622:3865:3870:3871:3872:4321:5007:7652:10004:10400:10848:11232:11658:11914:12517:12519:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: hole62_b3dfe0ff5e0d
X-Filterd-Recvd-Size: 1463
Message-ID: <1403318075.4076.31.camel@joe-AO725>
Subject: Re: [PATCH] staging:rtl8821ae: rewrite legacy wifi check in
 halbcoutsrc
From: Joe Perches <joe@perches.com>
To: Nick Krause <xerofoify@gmail.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Greg KH <gregkh@linuxfoundation.org>, devel@driverdev.osuosl.org,
        pebolle@tiscali.nl, Himangi Saraogi <himangi774@gmail.com>,
        Konrad Zapalowicz <bergo.torino@gmail.com>,
        linux-kernel@vger.kernel.org
Date: Fri, 20 Jun 2014 19:34:35 -0700
In-Reply-To: <CAPDOMVi2humH7sL8DDkY=WJ3gWnehdeX8QEnNf6d8oTWftHXKA@mail.gmail.com>
References: <1403283410-7022-1-git-send-email-xerofoify@gmail.com>
	 <20140620195926.GY5500@mwanda> <1403294880.4076.7.camel@joe-AO725>
	 <CAPDOMVi2humH7sL8DDkY=WJ3gWnehdeX8QEnNf6d8oTWftHXKA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-06-20 at 22:26 -0400, Nick Krause wrote:
> Thanks for the feedback I will resend the patch fixed.

Please do not.

> Otherwise please use Larry's idea.

It's not Larry's idea.  Larry is the primary
contributor for Realtek drivers in staging.


