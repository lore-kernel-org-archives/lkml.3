Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752831AbaLEIoP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 03:44:15 -0500
Received: from smtprelay0196.hostedemail.com ([216.40.44.196]:36661 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751579AbaLEIoN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 03:44:13 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3867:3868:3870:3871:3872:3873:4321:5007:6119:6261:6742:6743:10004:10400:10848:11232:11657:11658:11914:12043:12050:12517:12519:12740:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: sock91_7215a5a8f909
X-Filterd-Recvd-Size: 2387
Message-ID: <1417769047.2721.49.camel@perches.com>
Subject: Re: [PATCH] staging: lustre: fix sparse warning on LPROC_SEQ_FOPS
 macros
From: Joe Perches <joe@perches.com>
To: Tristan Lelong <tristan@lelong.xyz>
Cc: oleg.drokin@intel.com, andreas.dilger@intel.com,
        gregkh@linuxfoundation.org, askb23@gmail.com, john.hammond@intel.com,
        gdonald@gmail.com, anhlq2110@gmail.com, fabio.falzoi84@gmail.com,
        oort10@gmail.com, agimenez@sysvalve.es, rupran@einserver.de,
        surya.seetharaman9@gmail.com, Julia.Lawall@lip6.fr,
        a.terekhov@gmail.com, liang.zhen@intel.com, vthakkar1994@gmail.com,
        amk@cray.com, srikrishanmalik@gmail.com, rd@radekdostal.com,
        bergwolf@gmail.com, dan.carpenter@oracle.com,
        paul.gortmaker@windriver.com, tapaswenipathak@gmail.com,
        email@christophjaeger.info, uja.ornl@gmail.com, brilliantov@inbox.ru,
        dmitry.eremin@intel.com, HPDD-discuss@ml01.01.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Date: Fri, 05 Dec 2014 00:44:07 -0800
In-Reply-To: <20141205083741.GA5570@dunderer>
References: <1417766627-5232-1-git-send-email-tristan@lelong.xyz>
	 <1417768091.2721.47.camel@perches.com> <20141205083741.GA5570@dunderer>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-12-05 at 00:37 -0800, Tristan Lelong wrote:
> On Fri, Dec 05, 2014 at 12:28:11AM -0800, Joe Perches wrote:
> > On Fri, 2014-12-05 at 00:03 -0800, Tristan Lelong wrote:
[]
> > > diff --git a/drivers/staging/lustre/lustre/fld/lproc_fld.c b/drivers/staging/lustre/lustre/fld/lproc_fld.c
[]
> > > +	char name[80];
[]
> > Why 80?  Is there no #define for this length?
> > 
> No, there is no define.
> 
> I thought about adding one, but several other files and structure
> members in the lustre sources are using this specific value, and it
> seemed like a modification to do in another patch.
> 
> Let me know if you feel I should do it in a patch serie.

No worries if it's not a new number.

It'd be nice if you would submit a new
patch with a #define and a conversion
to use the #define one day.


