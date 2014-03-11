Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755120AbaCKRtR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 13:49:17 -0400
Received: from smtprelay0236.hostedemail.com ([216.40.44.236]:35893 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754099AbaCKRtQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 13:49:16 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:69:355:379:541:599:968:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:1801:2393:2551:2553:2559:2562:2828:2895:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:3873:3874:4321:4605:5007:7652:7875:7974:8957:9038:10004:10400:10848:11232:11657:11658:11914:12043:12050:12296:12438:12517:12519:12683:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: waves44_166fa2aa0d44d
X-Filterd-Recvd-Size: 2617
Message-ID: <1394560152.20021.3.camel@joe-AO722>
Subject: Re: [PATCH v2] Staging: comedi: addi-data: Fix long CamelCase
 function names
From: Joe Perches <joe@perches.com>
To: Hartley Sweeten <HartleyS@visionengravers.com>
Cc: Fred Akers <knivey@botops.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "abbotti@mev.co.uk" <abbotti@mev.co.uk>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 11 Mar 2014 10:49:12 -0700
In-Reply-To: <DC148C5AA1CEBA4E87973D432B1C2D8825DAD0AF@P3PWEX4MB008.ex4.secureserver.net>
References: <1394350009-23464-1-git-send-email-knivey@botops.net>
	 <1394559177-14616-1-git-send-email-knivey@botops.net>
	 <DC148C5AA1CEBA4E87973D432B1C2D8825DAD0AF@P3PWEX4MB008.ex4.secureserver.net>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-03-11 at 17:42 +0000, Hartley Sweeten wrote:
> On Tuesday, March 11, 2014 10:33 AM, Fred Akers wrote:
> > This patch fixes a few function names that are very long and are
> > not in the correct naming style
[]
> > diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci035.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci035.c
[]
> > @@ -111,7 +111,7 @@ static int i_Temp;
> >  static int i_Flag = 1;
> >  /*
> >  +----------------------------------------------------------------------------+
> > -| Function   Name   : int i_APCI035_ConfigTimerWatchdog                      |
> > +| Function   Name   : int apci035_timer_config                      |
> >  |			  (struct comedi_device *dev,struct comedi_subdevice *s,               |
> >  |                      struct comedi_insn *insn,unsigned int *data)                     |
> >  +----------------------------------------------------------------------------+
> 
> Nitpick... These obvious function comment blocks should be removed.
> That should be a separate patch. Maybe a patch 1/2 before this one so
> you don't have to update the comments.

Maybe convert them to kernel-doc style?

/**
 * foobar() - short function description of foobar
 * @arg1:	Describe the first argument to foobar.
 * @arg2:	Describe the second argument to foobar.
 *		One can provide multiple line descriptions
 *		for arguments.


