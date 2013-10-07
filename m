Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756068Ab3JGQRp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 12:17:45 -0400
Received: from smtprelay0069.hostedemail.com ([216.40.44.69]:46398 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755529Ab3JGQRk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 12:17:40 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:599:967:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2525:2560:2563:2682:2685:2828:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:3871:3872:3873:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4321:5007:7652:7903:7974:9025:9036:9040:10004:10400:10848:11232:11657:11658:11914:12043:12050:12517:12519:12555:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: death64_5f9c05482bc56
X-Filterd-Recvd-Size: 2197
Message-ID: <1381162656.2081.179.camel@joe-AO722>
Subject: Re: linux-next: manual merge of the wireless-next tree
From: Joe Perches <joe@perches.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Thierry Reding <thierry.reding@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Arend van Spriel <arend@broadcom.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Mon, 07 Oct 2013 09:17:36 -0700
In-Reply-To: <5252DC9C.8090803@lwfinger.net>
References: <1381159127-11067-1-git-send-email-treding@nvidia.com>
	 <1381159127-11067-5-git-send-email-treding@nvidia.com>
	 <5252D7E4.2050509@lwfinger.net> <1381161393.2081.177.camel@joe-AO722>
	 <5252DC9C.8090803@lwfinger.net>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-10-07 at 11:09 -0500, Larry Finger wrote:
> On 10/07/2013 10:56 AM, Joe Perches wrote:
> > On Mon, 2013-10-07 at 10:48 -0500, Larry Finger wrote:
> >> On 10/07/2013 10:18 AM, Thierry Reding wrote:
> >>> Today's linux-next merge of the wireless-next tree got conflicts in:
> >>>
> >>> 	drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h
> >>> 	drivers/net/wireless/rtlwifi/rtl8188ee/phy.h
> >>> 	drivers/net/wireless/rtlwifi/rtl8192ce/phy.h
> >>> 	drivers/net/wireless/rtlwifi/rtl8192de/phy.h
> >>> 	drivers/net/wireless/rtlwifi/rtl8723ae/phy.h
> > []
> >> Yes, the patches for rtlwifi problems are correct. All of these problems would
> >> have been avoided if changes to wireless drivers were sent to the wireless tree
> >> rather than direct submission to net-next!!!!
> >
> > They were and you acked it.
> > https://lkml.org/lkml/2013/9/25/589
> >
> > Who picks it up first and applies it is
> > not in my domain.
> 
> Fair enough. I should have asked DaveM to let John apply those changes.

Or maybe John could merge changes from net-next
into wireless-next a bit more often.


