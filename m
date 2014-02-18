Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755614AbaBROP3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 09:15:29 -0500
Received: from smtprelay0166.hostedemail.com ([216.40.44.166]:54344 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755341AbaBROP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 09:15:27 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1537:1560:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3622:3865:3867:4321:5007:7652:7856:8603:10004:10400:10471:10848:11232:11658:11914:12114:12517:12519:12679:12740:13069:13071:13161:13229:13255:13311:13357:21060,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: pan48_86a62c4070e19
X-Filterd-Recvd-Size: 1283
Message-ID: <1392732925.22752.26.camel@joe-AO722>
Subject: Re: [PATCH] drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c:
 deinline brcmf_sdio_chip_cr4_enterdl, save 440 bytes
From: Joe Perches <joe@perches.com>
To: Denys Vlasenko <dvlasenk@redhat.com>
Cc: Franky Lin <frankyl@broadcom.com>, Arend van Spriel <arend@broadcom.com>,
        Hante Meuleman <meuleman@broadcom.com>, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org
Date: Tue, 18 Feb 2014 06:15:25 -0800
In-Reply-To: <1392732320-18973-1-git-send-email-dvlasenk@redhat.com>
References: <1392732320-18973-1-git-send-email-dvlasenk@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-02-18 at 15:05 +0100, Denys Vlasenko wrote:
> Signed-off-by: Denys Vlasenko <dvlasenk@redhat.com>

Hi Denys

Perhaps these patch subjects would be better without
the file path, but shortened to something like:

brcmfmac: sdio_chip: deinline function to reduce object size


