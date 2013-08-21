Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752306Ab3HURlB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 13:41:01 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:38768 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751810Ab3HURk7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 13:40:59 -0400
Message-ID: <5214FBA8.5000603@wwwdotorg.org>
Date: Wed, 21 Aug 2013 11:40:56 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Lars Poeschel <poeschel@lemonage.de>
CC: rob.herring@calxeda.com, Pawel Moll <Pawel.Moll@arm.com>,
        mark.rutland@arm.com, ian.campbell@citrix.com, rob@landley.net,
        Grant Likely <grant.likely@linaro.org>, arnd@arndb.de,
        Linus Walleij <linus.walleij@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-doc@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] of: add vendor prefix for Microchip Technology Inc
References: <201308211719.57748.poeschel@lemonage.de>
In-Reply-To: <201308211719.57748.poeschel@lemonage.de>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/21/2013 09:19 AM, Lars Poeschel wrote:
> Trivial patch to add Microchip Technology Inc. to the list
> of devicetree vendor prefixes, as it is already used in
> Documentation/devicetree/bindings/gpio/gpio-mcp23s08.txt

Oh dear. Perhaps it can be legacy-ified...

> diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt 

> +mcp	Microchip Technology Inc.

If I saw "mcp," in a *.dts file, I wouldn't immediately think "Microchip".

Their stock ticker appears to be MCHP, so I'd suggest either "mchp" or
"microchip" instead; that latter being my personal preference.
