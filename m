Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751331AbaEVQpk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 12:45:40 -0400
Received: from smtprelay0041.hostedemail.com ([216.40.44.41]:44961 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751151AbaEVQpj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 12:45:39 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:599:967:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1537:1560:1593:1594:1711:1714:1730:1747:1777:1792:2393:2525:2560:2563:2682:2685:2828:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3622:3770:3865:3867:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4321:5007:7652:9025:9388:10004:10400:10848:11232:11658:11914:12043:12292:12517:12519:12555:12682:12740:12855:13069:13161:13229:13255:13311:13357:13845:14089:14090:14091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: rat24_140060a17f45a
X-Filterd-Recvd-Size: 1222
Message-ID: <1400777136.21099.6.camel@joe-AO725>
Subject: Re: [PATCH] mfd: axp20x: Remove unnecessary const qualifier from
 axp20x_supplies[]
From: Joe Perches <joe@perches.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Thu, 22 May 2014 09:45:36 -0700
In-Reply-To: <20140522160856.GJ19747@lee--X1>
References: <1400750311-15323-1-git-send-email-lee.jones@linaro.org>
	 <1400750311-15323-2-git-send-email-lee.jones@linaro.org>
	 <1400774373.21099.1.camel@joe-AO725> <20140522160856.GJ19747@lee--X1>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-05-22 at 17:08 +0100, Lee Jones wrote:
> To be frank, I've never known what the double const means.  Care to
> enlighten?

There's a nice table here:

http://stackoverflow.com/questions/14562845/why-does-passing-char-as-const-char-generate-a-warning


