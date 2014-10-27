Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751400AbaJ0GXL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 02:23:11 -0400
Received: from smtprelay0105.hostedemail.com ([216.40.44.105]:59682 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750873AbaJ0GXJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 02:23:09 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2194:2199:2393:2559:2562:2828:3138:3139:3140:3141:3142:3353:3622:3865:3867:3868:3871:3872:3873:3874:4321:5007:6261:7875:8957:9040:10004:10400:10848:11026:11232:11473:11657:11658:11914:12043:12517:12519:12555:12740:13019:13069:13141:13230:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: horse60_8f78d47fcd537
X-Filterd-Recvd-Size: 2565
Message-ID: <1414390984.8884.0.camel@perches.com>
Subject: Re: [PATCH 2/2] staging: rtl8723au:core
From: Joe Perches <joe@perches.com>
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: Paul McQuade <paulmcquad@gmail.com>, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net
Date: Sun, 26 Oct 2014 23:23:04 -0700
In-Reply-To: <wrfj1tpuca0q.fsf@redhat.com>
References: <1414340332-4556-1-git-send-email-paulmcquad@gmail.com>
	 <1414350250.15751.22.camel@perches.com> <wrfjegtucbgo.fsf@redhat.com>
	 <1414389096.15751.34.camel@perches.com> <wrfj1tpuca0q.fsf@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-10-27 at 07:16 +0100, Jes Sorensen wrote:
> Joe Perches <joe@perches.com> writes:
> > On Mon, 2014-10-27 at 06:45 +0100, Jes Sorensen wrote:
> >> Joe Perches <joe@perches.com> writes:
> >> > On Sun, 2014-10-26 at 16:18 +0000, Paul McQuade wrote:
> >> >> ERROR: spaces required around that ':' (ctx:VxE)
> > []
> >> >> diff --git a/drivers/staging/rtl8723au/core/rtw_ieee80211.c
> >> >> b/drivers/staging/rtl8723au/core/rtw_ieee80211.c
> > []
> >> >> @@ -794,28 +794,28 @@ u16 rtw_mcs_rate23a(u8 rf_type, u8 bw_40MHz, u8 short_GI_20, u8 short_GI_40,
> >> >>  
> >> >>  	if (rf_type == RF_1T1R) {
> >> >>  		if (mcs->rx_mask[0] & BIT(7))
> >> >> -			max_rate = (bw_40MHz) ? ((short_GI_40)?1500:1350):
> >> >> +			max_rate = (bw_40MHz) ? ((short_GI_40)?1500:1350) :
> > []
> >> >
> >> > A macro could help intelligibility here - maybe something like:
> >> >
> >> > #define get_max_rate(r1, r2, r3, r4)					\
> >> > 	(bw_40MHz ? (short_GI_40 ? r1 : r2) : (short_GI_20 ? r3 : r4))
> >> > and:
> >> >  		if (mcs->rx_mask[0] & BIT(7))
> >> > 			max_rate = get_max_rate(1500, 1350, 722, 650);
> >> 
> >> Hiding a parameter to a macro like that is bad coding practice, so don't
> >> do that please!
> >
> > Yes and no.
> >
> > Adding the other 3 arguments to the macro doesn't help legibility.
> >
> > Keeping the macro definition local to the place that it's used
> > can help avoid typos.
> 
> It's wrong, so just don't do it here!

It's not "wrong", you just don't like it.



