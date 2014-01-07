Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752245AbaAGOKZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 09:10:25 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:31408 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751403AbaAGOKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 09:10:12 -0500
X-AuditID: cbfec7f4-b7f796d000005a13-0d-52cc0ac14472
From: Tomasz Figa <t.figa@samsung.com>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Anton Vorontsov <anton@enomsg.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>, Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH v7 3/3] mfd: max14577: Add device tree bindings document
Date: Tue, 07 Jan 2014 15:10:04 +0100
Message-id: <2536498.L12VSLryvi@amdc1227>
Organization: Samsung Poland R&D Center
User-Agent: KMail/4.12 (Linux/3.11.5-gentoo; KDE/4.12.0; x86_64; ; )
In-reply-to: <1386329534-14186-4-git-send-email-k.kozlowski@samsung.com>
References: <1386329534-14186-1-git-send-email-k.kozlowski@samsung.com>
 <1386329534-14186-4-git-send-email-k.kozlowski@samsung.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrDIsWRmVeSWpSXmKPExsVy+t/xK7oHuc4EGfy6I29xcKumxcYZ61kt
	pj58wmZx/ctzVov5R86xWkxcOZnZ4tyrlYwWr18YWpxtesNucf/rUUaLb1c6mCw2Pb7GarGw
	bQmLxeVdc9gs1h65y26x9PpFJosJ09eyWBxecYDJYt3L6SwWrw62sTiIeKyZt4bRY8HnK+we
	E/o/MXrsnHWX3WPl8i9sHptXaHlsWtXJ5vFq9UxWjzvX9gCFltR79G1ZxejxeZOcx8a5oQG8
	UVw2Kak5mWWpRfp2CVwZnX+mMhVckKrYtX05SwPjFtEuRk4OCQETibubvjFC2GISF+6tZ+ti
	5OIQEljKKHF34XMmCKeLSWLjhkksIFVsAmoSnxsesYHYIgKGEgd3b2cCsZkFbrFKPJgHViMs
	4COx6WwH0FQODhYBVYklR9NATF4BTYkPr2pBKvgF1CXebXsK1ikq4CJxrGURC0gJp4CHxOIj
	jBBbWxklWm5uAJvIKyAo8WPyPRaITfIS+/ZPZYWwtSTW7zzONIFRcBaSsllIymYhKVvAyLyK
	UTS1NLmgOCk911CvODG3uDQvXS85P3cTIySGv+xgXHzM6hCjAAejEg/vi72ngoRYE8uKK3MP
	MUpwMCuJ8DLfOB0kxJuSWFmVWpQfX1Sak1p8iJGJg1OqgVEg9L6G/aW+I2Fq3359uVnapv3u
	pqGsL6PRl0MGR/b/a9CcU8pyZpXVydSslVKrev5Grwndd3uFq82j01yhsZbBy/8tvz7/7uXd
	1WYC5/Ntt3ZGnszz1pXVvRf+fI6LBrew2KtVJ9jixIsUo7fyWJxcJ9/Tap6n0CjzR6nzetuf
	RLbJ8kzr4pVYijMSDbWYi4oTAWOT25a/AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Friday 06 of December 2013 12:32:14 Krzysztof Kozlowski wrote:
> Add document describing device tree bindings for MAX14577 MFD driver.
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  Documentation/devicetree/bindings/mfd/max14577.txt |   65 ++++++++++++++++++++
>  1 file changed, 65 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/mfd/max14577.txt
> 
> diff --git a/Documentation/devicetree/bindings/mfd/max14577.txt b/Documentation/devicetree/bindings/mfd/max14577.txt
> new file mode 100644
> index 000000000000..0b2449aaf8bf
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/mfd/max14577.txt
> @@ -0,0 +1,65 @@
> +Maxim MAX14577 Multi-Function Device
> +
> +MAX14577 is a Multi-Function Device with Micro-USB Interface Circuit, Li+
> +Battery Charger and SFOUT LDO output for powering USB devices. It is
> +interfaced to host controller using I2C.
> +
> +
> +Required properties:
> +- compatible : Must be "maxim,max14577".
> +- reg : I2C slave address for the max14577 chip.

If this chip has a predefined set of addresses it might be a good idea to
list them here.

> +- interrupts : IRQ line for the max14577 chip.
> +- interrupt-parent :  The parent interrupt controller.
> +
> +
> +Optional nodes:
> +- max14577-muic :
> +	Node used only by extcon consumers.

Do you need a dedicated node to do this? If you don't need any additional
data for MUIC cell, why couldn't the parent node be used to register the
extcon provider?

> +	Required properties:
> +		- compatible : "maxim,max14577-muic"
> +
> +- regulators :
> +	Required properties:
> +		- compatible : "maxim,max14577-regulator"
> +
> +	May contain a sub-node per regulator from the list below. Each

Is "May" the correct word? Wouldn't it be better to always have
configuration specified for all regulators of the cell?

> +	sub-node should contain the constraints and initialization information
> +	for that regulator. See regulator.txt for a description of standard
> +	properties for these sub-nodes.
> +
> +	List of valid regulator names: CHARGER, SAFEOUT.
> +
> +	The SAFEOUT is a fixed voltage regulator so there is no need to specify
> +	voltages for it.
> +
> +
> +Example:
> +
> +#include <dt-bindings/interrupt-controller/irq.h>
> +
> +max14577@25 {
> +	compatible = "maxim,max14577";
> +	reg = <0x25>;
> +	interrupt-parent = <&gpx1>;
> +	interrupts = <5 IRQ_TYPE_NONE>;
> +
> +	muic: max14577-muic {
> +		compatible = "maxim,max14577-muic";
> +	};
> +
> +	regulators {
> +		compatible = "maxim,max14577-regulator";
> +
> +		safeout_reg: regulator@1 {
> +			regulator-compatible = "SAFEOUT";
> +			regulator-name = "SAFEOUT";
> +		};
> +		charger_reg: regulator@0 {
> +			regulator-compatible = "CHARGER";
> +			regulator-name = "CHARGER";
> +			regulator-min-microamp = <90000>;
> +			regulator-max-microamp = <950000>;
> +			regulator-boot-on;
> +		};
> +	};
> +};
> 

Now this patch creates a question whether we should keep the existing
black-box MFD scheme, where the list of cells is determined by an array
hardcoded inside the driver or rather we should completely move to DT
based description where of_mfd_populate() could create all MFD cells
using description from DT.

Best regards,
Tomasz
