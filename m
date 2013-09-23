Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753701Ab3IWVld (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 17:41:33 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:50972 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752341Ab3IWVlc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 17:41:32 -0400
Message-ID: <5240B586.20609@wwwdotorg.org>
Date: Mon, 23 Sep 2013 15:41:26 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
CC: lee.jones@linaro.org, sameo@linux.intel.com, rob.herring@calxeda.com,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, rob@landley.net, broonie@kernel.org,
        patches@opensource.wolfsonmicro.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] mfd: arizona: Add micdet ranges and polarity device
 tree bindings
References: <1379961043-23762-1-git-send-email-ckeepax@opensource.wolfsonmicro.com> <1379961043-23762-4-git-send-email-ckeepax@opensource.wolfsonmicro.com>
In-Reply-To: <1379961043-23762-4-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/23/2013 12:30 PM, Charles Keepax wrote:
> Add device tree bindings for the pdata that configures the microphone
> button detection and microphone detection polarity configurations.

> diff --git a/Documentation/devicetree/bindings/mfd/arizona.txt b/Documentation/devicetree/bindings/mfd/arizona.txt

> +  - wlf,micd-ranges : Microphone detection level and key configuration, this
> +    field can be of variable length but should always be a multiple of 2 cells
> +    long, each two cell group represents one button configuration
> +    The first cell is the maximum impedance for this button in ohms
> +    The second cell the key that should be reported to the input layer

Is there a limit on how many ranges can be specified? Are the impedance
values arbitrary, or limited to some pre-determined set of values
supported by HW?

> +  - wlf,micd-configs : Headset polarity configurations, the field can be of
> +    variable length but should always be a multiple of 3 cells long, each two

s/two/three/

