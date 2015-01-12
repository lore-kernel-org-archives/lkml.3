Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754254AbbALUCF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 15:02:05 -0500
Received: from down.free-electrons.com ([37.187.137.238]:57540 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750978AbbALUCD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 15:02:03 -0500
Date: Mon, 12 Jan 2015 21:01:49 +0100
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] AT91 DT for 3.20 #1
Message-ID: <20150112210149.581fe038@bbrezillon>
In-Reply-To: <1421089317-12607-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1421089317-12607-1-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Jan 2015 20:01:51 +0100
Alexandre Belloni <alexandre.belloni@free-electrons.com> wrote:

> This series enables RTC on the at91sam9n12 and at91rm9200.
> It also adds nodes for the SRAM availabe on at91 SoCs.
> 
> Finally it adds a dtsi for the at91sam9xe and uses it for the ethernut5 dts.

To the whole series:

Acked-by: Boris Brezillon <boris.brezillon@free-electrons.com>

> 
> Alexandre Belloni (6):
>   ARM: at91/dt: at91sam9n12: Add RTC node
>   ARM: at91/dt: rm9200: add RTC node
>   ARM: at91/dt: at91rm9200ek: enable RTC
>   ARM: at91/dt: add SRAM nodes
>   ARM: at91/dt: Add a dtsi for at91sam9xe
>   ARM: at91/dt: ethernut5: use at91sam9xe.dtsi
> 
>  .../devicetree/bindings/arm/atmel-at91.txt         |  1 +
>  arch/arm/boot/dts/at91rm9200.dtsi                  | 12 +++++
>  arch/arm/boot/dts/at91rm9200ek.dts                 |  4 ++
>  arch/arm/boot/dts/at91sam9260.dtsi                 |  5 ++
>  arch/arm/boot/dts/at91sam9261.dtsi                 |  5 ++
>  arch/arm/boot/dts/at91sam9263.dtsi                 | 10 ++++
>  arch/arm/boot/dts/at91sam9g20.dtsi                 |  9 ++++
>  arch/arm/boot/dts/at91sam9g45.dtsi                 |  7 ++-
>  arch/arm/boot/dts/at91sam9n12.dtsi                 | 12 +++++
>  arch/arm/boot/dts/at91sam9rl.dtsi                  |  5 ++
>  arch/arm/boot/dts/at91sam9x5.dtsi                  |  5 ++
>  arch/arm/boot/dts/at91sam9xe.dtsi                  | 60 ++++++++++++++++++++++
>  arch/arm/boot/dts/ethernut5.dts                    |  2 +-
>  arch/arm/boot/dts/sama5d3.dtsi                     |  5 ++
>  arch/arm/boot/dts/sama5d4.dtsi                     |  5 ++
>  15 files changed, 144 insertions(+), 3 deletions(-)
>  create mode 100644 arch/arm/boot/dts/at91sam9xe.dtsi
> 



-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
