Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757277AbaFZAJ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 20:09:28 -0400
Received: from smtprelay0022.hostedemail.com ([216.40.44.22]:41397 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753302AbaFZAJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 20:09:27 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:541:599:967:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1714:1730:1747:1777:1792:2194:2199:2393:2525:2560:2563:2682:2685:2828:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3350:3622:3770:3865:3868:3870:3873:3874:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4321:5007:7652:7903:8599:9025:10004:10400:10848:11232:11658:11914:12043:12292:12296:12517:12519:12555:12682:12740:13069:13255:13311:13357:13845:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:n
X-HE-Tag: clock63_34e8a7e82120b
X-Filterd-Recvd-Size: 1759
Message-ID: <1403741362.28663.12.camel@joe-AO725>
Subject: Re: [PATCH 2/2] staging: wlan-ng/hfa384x_usb.c: remove return
 statements for void function
From: Joe Perches <joe@perches.com>
To: Cheng-Wei Lee <lee.rhapsody@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sherif Shehab Aldin <shehabaldin.sherif@gmail.com>,
        Avinash Kumar <avi.kp.137@gmail.com>,
        Peter Senna Tschudin <peter.senna@gmail.com>,
        devel <devel@driverdev.osuosl.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Wed, 25 Jun 2014 17:09:22 -0700
In-Reply-To: <CAJKoSVRLvPe+5tae=buV3j12L612tdaYAWMT303GO71NF-w27g@mail.gmail.com>
References: <CAJKoSVRLvPe+5tae=buV3j12L612tdaYAWMT303GO71NF-w27g@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-06-25 at 23:35 +0800, Cheng-Wei Lee wrote:
> This patch fixes the following checkpatch.pl issues in hfa384x_usb.c:
> WARNING: Missing a blank line after declarations

Still has a mismatch between subject and code

> diff --git a/drivers/staging/wlan-ng/hfa384x_usb.c
[]
> @@ -3533,7 +3533,7 @@ static void hfa384x_usbin_rx(wlandevice_t
> *wlandev, struct sk_buff *skb)
>  	}
> 
>  done:
> -	return;
> +	pr_debug("hfa384x_usbin_rx: done\n");

I suggest you just leave the return,

Any checkpatch suggestion this was needed was a false
positive that should be resolved by this patch:

http://article.gmane.org/gmane.linux.kernel/1728891


