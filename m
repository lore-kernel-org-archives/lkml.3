Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754116Ab3IWViQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 17:38:16 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:33761 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752787Ab3IWViO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 17:38:14 -0400
Message-ID: <5240B4C2.2080600@wwwdotorg.org>
Date: Mon, 23 Sep 2013 15:38:10 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
CC: lee.jones@linaro.org, sameo@linux.intel.com, rob.herring@calxeda.com,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, rob@landley.net, broonie@kernel.org,
        patches@opensource.wolfsonmicro.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] mfd: arizona: Add device tree binding for max_channels_clocked
References: <1379961043-23762-1-git-send-email-ckeepax@opensource.wolfsonmicro.com> <1379961043-23762-2-git-send-email-ckeepax@opensource.wolfsonmicro.com>
In-Reply-To: <1379961043-23762-2-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/23/2013 12:30 PM, Charles Keepax wrote:
> Add device tree bindings for the pdata max_channels_clocked, that allows
> the user to limit the number of channels clocked on a single AIF.

> diff --git a/Documentation/devicetree/bindings/mfd/arizona.txt b/Documentation/devicetree/bindings/mfd/arizona.txt

> +  - wlf,max-channels-clocked : The maximum number of channels to be clocked on
> +    each AIF, useful for I2S systems with multiple data lines being mastered.
> +    If specified three cells must supplied one for each AIF, specify zero for
> +    AIFs that should be handled normally.

What determines the value of this property? Is it really a definition of
HW, or some kind of run-time configuration/limit? What goes into each of
the 3 cells?
