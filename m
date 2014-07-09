Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755385AbaGIM45 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 08:56:57 -0400
Received: from smtprelay0216.hostedemail.com ([216.40.44.216]:38238 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751542AbaGIM44 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 08:56:56 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2693:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3871:3872:3874:4321:4605:4823:5007:7652:7903:8957:10004:10400:10848:11232:11658:11914:12043:12296:12438:12517:12519:12555:12740:13069:13071:13141:13161:13229:13230:13311:13357:21060:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: cream97_5949cabc3ce26
X-Filterd-Recvd-Size: 2409
Message-ID: <1404910612.932.95.camel@joe-AO725>
Subject: Re: [PATCH v3 4/4] staging: rtl8192u: Fixed too long lines
From: Joe Perches <joe@perches.com>
To: sanjeev sharma <sanjeevsharmaengg@gmail.com>
Cc: gregkh@linuxfoundation.org, rmfrfs@gmail.com, peter.senna@gmail.com,
        teobaluta@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        sanjeev sharma <sanjeev_sharma@mentor.com>
Date: Wed, 09 Jul 2014 05:56:52 -0700
In-Reply-To: <1404908382-7043-5-git-send-email-sanjeevsharmaengg@gmail.com>
References: <20140708100142.GR25934@mwanda>
	 <1404908382-7043-1-git-send-email-sanjeevsharmaengg@gmail.com>
	 <1404908382-7043-5-git-send-email-sanjeevsharmaengg@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-07-09 at 17:49 +0530, sanjeev sharma wrote:
> This patch will fix too long lines warning
> reported by checkpatch.pl.

Hi Sanjeev.

> diff --git a/drivers/staging/rtl8192u/r819xU_phy.c b/drivers/staging/rtl8192u/r819xU_phy.c
[]
> @@ -1786,7 +1788,9 @@ void InitialGainOperateWorkItemCallBack(struct work_struct *work)
>  		RT_TRACE(COMP_SCAN, "Scan BBInitialGainRestore 0xa0a is %x\n",
>  			 priv->initgain_backup.cca);
>  
> -		rtl8192_phy_setTxPower(dev, priv->ieee80211->current_network.channel);
> +		rtl8192_phy_setTxPower(dev,
> +					priv->ieee80211->current_network.channel
> +				       );

This one is a little off

+		rtl8192_phy_setTxPower(dev,
+					priv->ieee80211->current_network.channel
+				       );

Please align multiline statements to the appropriate
open parenthesis using a mix of initial leading tabs
followed by the minimal number of spaces required
to put the first non-whitespace char at the column
immediately after the preceding open paren.

Here it's 4 tabs, 7 spaces, not 5 tabs:

+		rtl8192_phy_setTxPower(dev,
+				       priv->ieee80211->current_network.channel);

And please don't use a line that's just a close
parenthesis and semicolon.

I think it's better to ignore the 80 column limit for
these and place them at the end of the preceding line.


