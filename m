Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756132Ab3FGP0V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 11:26:21 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:53192 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753453Ab3FGP0U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 11:26:20 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>, Vinod Koul <vinod.koul@intel.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dmaengine: at_hdmac: remove unsuded atc_cleanup_descriptors()
Date: Fri, 07 Jun 2013 17:25:51 +0200
Message-ID: <2095463.aoYp4tpuOZ@wuerfel>
User-Agent: KMail/4.10.3 (Linux/3.9.0-2-generic; KDE/4.10.3; x86_64; ; )
In-Reply-To: <1370618129-18049-1-git-send-email-nicolas.ferre@atmel.com>
References: <1370618129-18049-1-git-send-email-nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:nj4H5b4ZP8bT46v/jmENHsW2EOwhXk61ujMafd9rTQJ
 ziV7HXOnSMryL2rehurQ+ukn2HjUSiYg9tsyJOMNK4p8lh3SAN
 Bk+L40al/NFzfaba6ENYaIQi9JHImpbIUvpRn4MD//ge6wBtC+
 8msSceAQQqBUv8pi53Nywe87WHpGpY5HgBRBYO0OhAz6x5JOhb
 gp/2RXRlLqjABrl+wQMz7kYpYuzTs2H27AbLEaqSQtasu2W7Oo
 2ou045+7t1/D3AsJt3PEQxVsydrIlgGNochiVjAd2jBqvXGcYs
 wyLqVGh8n993btFJbyZz2Xi+zN6li3LESfkl6uNPTYdh95dNgC
 2y4iIPbe5dCOl72l1X7o=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 07 June 2013 17:15:29 Nicolas Ferre wrote:
> Since patch 7c407d3e54dcc0c79119553c8d5ef176c1d5bc3a (DMA: AT91:
> Get residual bytes in dma buffer), the function
> atc_cleanup_descriptors() is not used anymore. We remove it to prevent
> warnings.
> 
> Reported-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>

Acked-by: Arnd Bergmann <arnd@arndb.de>
