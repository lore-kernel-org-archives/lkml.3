Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755654Ab3LVTq2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Dec 2013 14:46:28 -0500
Received: from mail-pd0-f182.google.com ([209.85.192.182]:35984 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753143Ab3LVTq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Dec 2013 14:46:26 -0500
Date: Sun, 22 Dec 2013 11:44:18 -0800
From: Olof Johansson <olof@lixom.net>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Arnd Bergmann <arnd@arndb.de>, arm@kernel.org,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Ludovic Desroches <ludovic.desroches@atmel.com>
Subject: Re: [GIT PULL] at91: drivers for 3.14 #1
Message-ID: <20131222194418.GC9144@quad.lixom.net>
References: <1386925545-10495-1-git-send-email-nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386925545-10495-1-git-send-email-nicolas.ferre@atmel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Dec 13, 2013 at 10:05:45AM +0100, Nicolas Ferre wrote:
> Arnd, Olof, Kevin,
> 
> This is a "drivers" series that adds Device Tree support to 
> Atmel crypto drivers (AES/[T]DES/SHA). As the DT part of this
> addition is in at91-3.14-dt I thought it would be simpler to take
> this series through arm-soc. I asked and got Herbert's blessing.
> 
> The Device Tree entries documented in these patches are very simple
> and only declare the reg/irq values and the link to DMA.
> 
> Thanks, best regards,
> 
> The following changes since commit b46e837d8ef1f3c777bbf9513e2cdb5d87d6c374:
> 
>   ARM: at91/dt: remove old clk material (2013-12-02 15:31:29 +0100)
> 
> are available in the git repository at:
> 
>   git://github.com/at91linux/linux-at91.git tags/at91-drivers
> 
> for you to fetch changes up to 1ca5b7d95315c42cf0b78d33cd316e404a9f137c:
> 
>   crypto: atmel-sha - add sha information to the log (2013-12-12 18:39:36 +0100)
> 
> ----------------------------------------------------------------
> AT91 crypto drivers DT support:
> - add DT to sha/des/aes existing drivers
> - add DMA DT
> - all documentation added to crypto/atmel-crypto.txt file
> 
> ----------------------------------------------------------------
> Nicolas Ferre (4):
>       crypto: atmel-aes - add support for Device Tree
>       crypto: atmel-tdes - add support for Device Tree
>       crypto: atmel-sha - add support for Device Tree
>       crypto: atmel-sha - add sha information to the log

Pulled. In the future make sure to cc binding changes to
devicetree@vger.kernel.org for review. These bindings all seemed to be
trivial though so I merged anyway.


-Olof
