Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757917AbaGYHmj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 03:42:39 -0400
Received: from smtp-out-064.synserver.de ([212.40.185.64]:1048 "EHLO
	smtp-out-064.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751961AbaGYHmh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 03:42:37 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 11350
Message-ID: <53D20A61.1050506@metafoo.de>
Date: Fri, 25 Jul 2014 09:42:25 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.6.0
MIME-Version: 1.0
To: =?UTF-8?B?QW5kcmVhcyBGw6RyYmVy?= <afaerber@suse.de>,
        Michal Simek <michal.simek@xilinx.com>
CC: Andreas Olofsson <andreas@adapteva.com>,
        Matteo Vit <matteo.vit@starwaredesign.com>,
        Sean Rickerd <srickerd@suse.com>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Subject: Re: [PATCH v2 09/11] Documentation: devicetree: Fix ADI AXI SPDIF
 specification
References: <1406242820-20140-1-git-send-email-afaerber@suse.de> <1406242820-20140-10-git-send-email-afaerber@suse.de>
In-Reply-To: <1406242820-20140-10-git-send-email-afaerber@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/25/2014 01:00 AM, Andreas Färber wrote:
> The specification requires compatible = "adi,axi-spdif-1.00.a" but
> driver and example and file name indicate "adi,axi-spdif-tx-1.00.a".
> Change the specification to match the implementation.
>
> Signed-off-by: Andreas Färber <afaerber@suse.de>

Acked-by: Lars-Peter Clausen <lars@metafoo.de>

Thanks.

> ---
>   v2: New
>
>   Documentation/devicetree/bindings/sound/adi,axi-spdif-tx.txt | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/Documentation/devicetree/bindings/sound/adi,axi-spdif-tx.txt b/Documentation/devicetree/bindings/sound/adi,axi-spdif-tx.txt
> index 46f3449..4eb7997 100644
> --- a/Documentation/devicetree/bindings/sound/adi,axi-spdif-tx.txt
> +++ b/Documentation/devicetree/bindings/sound/adi,axi-spdif-tx.txt
> @@ -1,7 +1,7 @@
>   ADI AXI-SPDIF controller
>
>   Required properties:
> - - compatible : Must be "adi,axi-spdif-1.00.a"
> + - compatible : Must be "adi,axi-spdif-tx-1.00.a"
>    - reg : Must contain SPDIF core's registers location and length
>    - clocks : Pairs of phandle and specifier referencing the controller's clocks.
>      The controller expects two clocks, the clock used for the AXI interface and
>

