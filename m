Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753419AbaCaPbC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 11:31:02 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:39155 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751768AbaCaPbA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 11:31:00 -0400
Date: Mon, 31 Mar 2014 16:30:41 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: "broonie@kernel.org" <broonie@kernel.org>,
        "lee.jones@linaro.org" <lee.jones@linaro.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "rob@landley.net" <rob@landley.net>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/6] mfd: arizona: Update DT binding to support LDO1
 init_data
Message-ID: <20140331153041.GB15064@e106331-lin.cambridge.arm.com>
References: <1396267187-30580-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
 <1396267187-30580-5-git-send-email-ckeepax@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1396267187-30580-5-git-send-email-ckeepax@opensource.wolfsonmicro.com>
Thread-Topic: [PATCH 4/6] mfd: arizona: Update DT binding to support LDO1
 init_data
Accept-Language: en-GB, en-US
Content-Language: en-US
acceptlanguage: en-GB, en-US
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 31, 2014 at 12:59:45PM +0100, Charles Keepax wrote:
> Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
> ---
>  Documentation/devicetree/bindings/mfd/arizona.txt |    7 +++++++
>  1 files changed, 7 insertions(+), 0 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/mfd/arizona.txt b/Documentation/devicetree/bindings/mfd/arizona.txt
> index 0e295c9..c019e73 100644
> --- a/Documentation/devicetree/bindings/mfd/arizona.txt
> +++ b/Documentation/devicetree/bindings/mfd/arizona.txt
> @@ -40,6 +40,13 @@ Optional properties:
>      the chip default will be used.  If present exactly five values must
>      be specified.
>  
> +  - ldo1 : Initial data for the LDO1 regulator, as covered in
> +    Documentation/devicetree/bindings/regulator/regulator.txt

This seems to be a node rather than a property, judging from the code.
Please describe properties separately from sub-nodes and their
properties. That also covers the micvdd addition in patch 6.

Thanks,
Mark.

> +
> +  - DCVDD-supply : Power supply, only needs to be specified if DCVDD is being
> +    externally supplied. As covered in
> +    Documentation/devicetree/bindings/regulator/regulator.txt
> +
>  Example:
>  
>  codec: wm5102@1a {
> -- 
> 1.7.2.5
> 
> 
