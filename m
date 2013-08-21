Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751627Ab3HULqJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 07:46:09 -0400
Received: from 4.mo4.mail-out.ovh.net ([178.32.98.131]:60366 "EHLO
	mo4.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751522Ab3HULqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 07:46:07 -0400
Date: Wed, 21 Aug 2013 13:28:21 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Ludovic Desroches <ludovic.desroches@atmel.com>,
        Wenyou Yang <wenyou.yang@atmel.com>, Bo Shen <voice.shen@atmel.com>,
        Josh Wu <josh.wu@atmel.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
X-Ovh-Mailout: 178.32.228.4 (mo4.mail-out.ovh.net)
Subject: Re: [PATCH 0/3] ARM: at91/DT: enable SPI for more SoCs
Message-ID: <20130821112821.GC18627@ns203013.ovh.net>
References: <cover.1372069834.git.nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1372069834.git.nicolas.ferre@atmel.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Ovh-Tracer-Id: 11828985897226840940
X-Ovh-Remote: 91.121.171.124 (ns203013.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeikedrgedtucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeikedrgedtucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12:35 Mon 24 Jun     , Nicolas Ferre wrote:
> This little series is for enabling the support of SPI on at91sam9n12 and
> sama5d3 families.

on all
Acked-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>

Best Regards,
J.
> 
> Nicolas Ferre (3):
>   ARM: at91/DT: fix SPI compatibility string
>   ARM: at91/DT: sama5d3: add SPI DMA client infos
>   ARM: at91/DT: at91sam9n12: add SPI DMA client infos
> 
>  arch/arm/boot/dts/at91sam9n12.dtsi |  6 ++++++
>  arch/arm/boot/dts/sama5d3.dtsi     | 10 ++++++++--
>  2 files changed, 14 insertions(+), 2 deletions(-)
> 
> -- 
> 1.8.2.2
> 
