Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755756AbaAIIcG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 03:32:06 -0500
Received: from 6.mo3.mail-out.ovh.net ([188.165.43.173]:34049 "EHLO
	mo3.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755398AbaAIIb4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 03:31:56 -0500
Message-ID: <52CE5E5A.6050209@overkiz.com>
Date: Thu, 09 Jan 2014 09:31:22 +0100
From: boris brezillon <b.brezillon@overkiz.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org
CC: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        David Woodhouse <dwmw2@infradead.org>,
        Grant Likely <grant.likely@linaro.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, dev@linux-sunxi.org,
        linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org
Subject: Re: [RFC PATCH 6/9] mtd: nand: add sunxi NFC dt bindings doc
References: <1389190924-26226-1-git-send-email-b.brezillon@overkiz.com> <1389190924-26226-7-git-send-email-b.brezillon@overkiz.com> <201401082228.55807.arnd@arndb.de>
In-Reply-To: <201401082228.55807.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 6808316737053554692
X-Ovh-Remote: 80.245.18.66 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejtddrfedtucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejtddrfedtucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01/2014 22:28, Arnd Bergmann wrote:
> On Wednesday 08 January 2014, Boris BREZILLON wrote:
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/mtd/sunxi-nand.txt
>> @@ -0,0 +1,71 @@
>> +Allwinner NAND Flash Controller (NFC)
>> +
>> +Required properties:
>> +- compatible : "allwinner,sun4i-nfc".
>> +- reg : shall contain registers location and length for data and reg.
>> +- interrupts : shall define the NFC interrupt.
>> +- #address-cells: shall be set to 1. Encode the nand CS.
>> +- #size-cells : shall be set to 0.
>> +- clocks : shall reference NFC clocks.
>> +- clock-names : NFC internal clock names. Shall contain :
>> +    * "ahb_clk" : AHB gating clock
>> +    * "sclk" : NFC clock
>> +
> One small request: Can we try to avoid the "NFC" name here? I think it's
> too overloaded and people may confuse it with near-field communication,
> which I'm sure will be supported in sunxi based devices at some point.
>
> It doesn't hurt to also mention that the function block is called
> nfc, but I think references to it are better named "nand", which is
> less confusing.

Sure, I'll remove references to the NFC acronym:
  - change compatible string to "allwinner,sun4i-nand"
  - avoid NFC references in the doc
  - rename the driver into sunxi-nand.c (formerly sunxi_nfc.c)

Do you see any other references to this acronym ?


Best Regards,

Boris
> 	Arnd

