Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752737Ab3IRPdM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 11:33:12 -0400
Received: from smtprelay0120.hostedemail.com ([216.40.44.120]:43420 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751712Ab3IRPdL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 11:33:11 -0400
X-Greylist: delayed 465 seconds by postgrey-1.27 at vger.kernel.org; Wed, 18 Sep 2013 11:33:11 EDT
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1568:1593:1594:1711:1714:1730:1747:1777:1792:1981:2194:2199:2393:2559:2562:2828:2895:3138:3139:3140:3141:3142:3622:3865:4321:5007:6119:7652:8957:10004:10400:10848:11232:11473:11657:11658:11914:12043:12438:12517:12519:12740:13069:13255:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: week12_3881ea55d5d03
X-Filterd-Recvd-Size: 1686
Message-ID: <1379518385.1787.28.camel@joe-AO722>
Subject: Re: [PATCH 003/007] WAN Drivers: Update farsync driver and
 introduce fsflex driver
From: Joe Perches <joe@perches.com>
To: Kevin Curtis <Kevin.Curtis@farsite.com>
Cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        Dermot Smith <dermot.smith@farsite.com>
Date: Wed, 18 Sep 2013 08:33:05 -0700
In-Reply-To: <E603DC592C92B54A89CEF6B0919A0B1CAAAA787DA2@SOLO.hq.farsitecommunications.com>
References: <E603DC592C92B54A89CEF6B0919A0B1CAAAA787DA2@SOLO.hq.farsitecommunications.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-09-18 at 11:12 +0100, Kevin Curtis wrote:
> Farsite Communications FarSync driver update

> diff -uprN -X linux-3.10.1/Documentation/dontdiff linux-3.10.1/drivers/net/wan/fscmn.h linux-3.10.1_new/drivers/net/wan/fscmn.h
[]
> +#ifdef UINT32
> +#define u32 UINT32
> +#define u16 UINT16
> +#define u8  UCHAR
> +#endif
> +
> +#ifdef USSTYPES_H
> +#define u32 U32
> +#define u16 U16
> +#define u8  U8
> +#endif

Unpretty.

Why aren't the typedefs from
include/asm-generic good enough?

> +typedef struct _FSCMN_TXRX_PREAMBLE {
[]
> +} FSCMN_TXRX_PREAMBLE, *PFSCMN_TXRX_PREAMBLE;

More typedefs


