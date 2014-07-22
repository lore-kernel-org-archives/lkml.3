Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756018AbaGVNeH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 09:34:07 -0400
Received: from smtprelay0006.hostedemail.com ([216.40.44.6]:34662 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755999AbaGVNeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 09:34:04 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3870:3871:3872:4250:4321:4605:5007:6119:7652:10004:10400:10562:10848:11026:11232:11658:11914:12217:12517:12519:12740:13069:13161:13229:13255:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: wall71_5da92bd73b51
X-Filterd-Recvd-Size: 1576
Message-ID: <1406036038.30871.19.camel@joe-AO725>
Subject: Re: [PATCH 09/19] mfd: ezx-pcap: Repair coding style errors picked
 up with checkpatch
From: Joe Perches <joe@perches.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        sameo@linux.intel.com
Date: Tue, 22 Jul 2014 06:33:58 -0700
In-Reply-To: <1406027485-15657-10-git-send-email-lee.jones@linaro.org>
References: <1406027485-15657-1-git-send-email-lee.jones@linaro.org>
	 <1406027485-15657-10-git-send-email-lee.jones@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-07-22 at 12:11 +0100, Lee Jones wrote:
> This is part of an effort to clean-up the MFD subsystem.
> 
> WARNING: Missing a blank line after declarations
> +       u32 flags;
> +       void (*callback)(void *, u16[]);

False positive from an old version of checkpatch.

The one in -next doesn't emit this as it's
simply a function pointer declaration.

> diff --git a/drivers/mfd/ezx-pcap.c b/drivers/mfd/ezx-pcap.c
[]
> @@ -25,8 +25,9 @@ struct pcap_adc_request {
>  	u8 bank;
>  	u8 ch[2];
>  	u32 flags;
> -	void (*callback)(void *, u16[]);
>  	void *data;
> +
> +	void (*callback)(void *, u16[]);
>  };


