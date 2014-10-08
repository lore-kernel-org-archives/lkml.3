Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754639AbaJHH5x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 03:57:53 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:63803 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751334AbaJHH5v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 03:57:51 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Scott Branden <sbranden@broadcom.com>, Christian Daudt <bcm@fixthebug.org>,
        Matt Porter <mporter@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        bcm-kernel-feedback-list@broadcom.com,
        Mike Turquette <mturquette@linaro.org>, Alex Elder <elder@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joe Perches <joe@perches.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Antti Palosaari <crope@iki.fi>, devicetree@vger.kernel.org,
        Ray Jui <rjui@broadcom.com>, linux-kernel@vger.kernel.org,
        Jonathan Richardson <jonathar@broadcom.com>,
        JD Zheng <jdzheng@broadcom.com>
Subject: Re: [PATCH 3/6] dt-bindings: Document Broadcom Cygnus SoC and clock driver
Date: Wed, 08 Oct 2014 09:57:03 +0200
Message-ID: <2480056.Cs3dr8EM2e@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1412746025-11998-4-git-send-email-sbranden@broadcom.com>
References: <1412746025-11998-4-git-send-email-sbranden@broadcom.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:pH7o3fD69sQK2eiGz0uOGPAHMu6fVrAbUpKlqaJbW1d
 Ar1q7qmoOEgZy86SIdQYshjUlX7Hki6QBaBk0aCP3SP9m5a81r
 rNVIKp0jDQI/cxluzYpFV/oguWFobOHQbpI5wMAeoyYYdw79U9
 QshTfjQHFcyDwsXJ46eFXe0ftoSPWHl7eBwf/Nq8AdwnDaY6k0
 qL+7ot6niIY98FYu5y+R0C5PZeuOz5DuVklcWaQ+2Hl/QrW7YY
 SUuZFoprQEhxoAvslkiOSqphljLDUogNaFQonGx66fxAhiLS1F
 wiMqR5Prddm/dXOApXSZ1WXm1hiEQq1WZ4le2SQWrXwGhIboUU
 CEZI3sw2GuMeRjuoo030=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 07 October 2014 22:27:02 Scott Branden wrote:
> diff --git a/Documentation/devicetree/bindings/arm/cygnus.txt b/Documentation/devicetree/bindings/arm/cygnus.txt
> new file mode 100644
> index 0000000..a210377
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/arm/cygnus.txt
> @@ -0,0 +1,12 @@
> +Broadcom Cygnus device tree bindings
> +------------------------------------
> +
> +All Cygnus boards shall have the following properties:
> +
> +Required root node property:
> +       - compatible = "brcm,cygnus";

Can you add a more specific model number for the soc as well?
I assume that cygnus refers to more than one model, so you
should probably list both the family and the individual
SoC type here.

> +Boards variants shall have the following additional properties:
> +
> +Required root node property for the BCM911360_ENTPHN board:
> +       - compatible = "brcm,bcm911360_entphn";
> 

We normally don't list specific boards here, since it's hard to
keep up.

	Arnd
