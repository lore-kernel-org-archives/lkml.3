Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755293Ab3JYPFx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 11:05:53 -0400
Received: from smtprelay0191.hostedemail.com ([216.40.44.191]:49512 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753474Ab3JYPFw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 11:05:52 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:599:966:967:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2196:2199:2393:2525:2553:2560:2563:2682:2685:2828:2859:2911:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4321:4385:4425:5007:7652:8985:9025:10004:10400:10848:11026:11232:11658:11914:12043:12517:12519:12663:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: mist32_4fe4f70dd6f2b
X-Filterd-Recvd-Size: 2033
Message-ID: <1382713547.2501.12.camel@joe-AO722>
Subject: Re: [PATCH] skd: Replaced custom debug PRINTKs with pr_debug
From: Joe Perches <joe@perches.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Ramprasad Chinthekindi <Ramprasad.Chinthekindi@hgst.com>,
        Akhil Bhansali <Akhil.Bhansali@hgst.com>,
        "jmoyer@redhat.com" <jmoyer@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Amit Phansalkar <Amit.Phansalkar@hgst.com>
Date: Fri, 25 Oct 2013 08:05:47 -0700
In-Reply-To: <20131025112430.GE6285@kernel.dk>
References: <24CA9A5C93173F48A9E3313B866A7C280F344E@MYMBX3.stec-inc.ad>
	 <20131024115304.GW14598@kernel.dk> <1382627375.22433.58.camel@joe-AO722>
	 <20131025112430.GE6285@kernel.dk>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-10-25 at 12:24 +0100, Jens Axboe wrote:
> On Thu, Oct 24 2013, Joe Perches wrote:
> > On Thu, 2013-10-24 at 12:53 +0100, Jens Axboe wrote:
> > > On Thu, Oct 24 2013, Ramprasad Chinthekindi wrote:
> > > > Hi Jens,
> > > > 
> > > > I'm resending the patch to replace custom debug macros with
> > > > pr_debug(). Kindly please review and apply the patch.  Thanking you.
> > > 
> > > Thanks, that's a nice improvement. Applied.
> > 
> > Is it really much of an improvement?
> > 
> > It leaves possible different behavior with
> > skdev->dbg_level/skd_dbg_level set without
> > linkage to a few printks now.
> > 
> > It also doesn't make use of dynamic debug's
> > +f/+l capability to and always emits
> > __func__/__LINE__.
> 
> It's an improvement from a private FOOPRINTK() macro. Feel free to send
> in further improvements.

I already sent what I think appropriate.

https://lkml.org/lkml/2013/10/1/324

