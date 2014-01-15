Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751994AbaAOMNl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 07:13:41 -0500
Received: from 4.mo6.mail-out.ovh.net ([87.98.184.159]:37605 "EHLO
	mo6.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751324AbaAOMNj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 07:13:39 -0500
Date: Wed, 15 Jan 2014 12:54:17 +0100
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Bo Shen <voice.shen@atmel.com>
Cc: broonie@kernel.org, nicolas.ferre@atmel.com, linux-sound@vger.kernel.org,
        alsa-devel@alsa-project.org, linux-arm-kernel@lists.infradead.org,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Mark Brown <broonie@linaro.org>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] Binding: atmel-wm8904: add option to choose clock
Message-ID: <20140115115417.GA9558@ns203013.ovh.net>
References: <1389669956-2304-1-git-send-email-voice.shen@atmel.com>
 <1389669956-2304-4-git-send-email-voice.shen@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389669956-2304-4-git-send-email-voice.shen@atmel.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Ovh-Tracer-Id: 8653948159572618035
X-Ovh-Remote: 91.121.171.124 (ns203013.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejtddrfeekucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejtddrfeekucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11:25 Tue 14 Jan     , Bo Shen wrote:
> Add the option to choose clock output on which pin connect to SSC.
> Default is on TK pin to SSC, add clk_from_rk_pin option, the clock
> is on RK pin to SSC.
> 
> Signed-off-by: Bo Shen <voice.shen@atmel.com>
> ---
> 
>  Documentation/devicetree/bindings/sound/atmel-wm8904.txt | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/sound/atmel-wm8904.txt b/Documentation/devicetree/bindings/sound/atmel-wm8904.txt
> index 8bbe50c..68a5c1a 100644
> --- a/Documentation/devicetree/bindings/sound/atmel-wm8904.txt
> +++ b/Documentation/devicetree/bindings/sound/atmel-wm8904.txt
> @@ -33,6 +33,8 @@ Required properties:
>  
>  Optional properties:
>    - pinctrl-names, pinctrl-0: Please refer to pinctrl-bindings.txt
> +  - clk_from_rk_pin: according to hardware design, clk privide on rk pin
							  provide

	?? no example?
> +    to ssc device
>  
>  Example:
>  sound {
> -- 
> 1.8.5.2
> 
