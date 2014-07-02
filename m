Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751660AbaGBIK6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 04:10:58 -0400
Received: from top.free-electrons.com ([176.31.233.9]:41263 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750895AbaGBIKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 04:10:55 -0400
Date: Wed, 2 Jul 2014 10:10:52 +0200
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/33] Documentation: dt: document all the atmel pmc
 compatibles
Message-ID: <20140702101052.3c9a452c@bbrezillon>
In-Reply-To: <1404223962-30471-2-git-send-email-alexandre.belloni@free-electrons.com>
References: <1404223962-30471-1-git-send-email-alexandre.belloni@free-electrons.com>
	<1404223962-30471-2-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  1 Jul 2014 16:12:10 +0200
Alexandre Belloni <alexandre.belloni@free-electrons.com> wrote:

> Documentation for atmel-pmc only list one compatible, add the
> remaining compatible strings.
> 
> Signed-off-by: Alexandre Belloni
> <alexandre.belloni@free-electrons.com> ---
>  Documentation/devicetree/bindings/arm/atmel-pmc.txt | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/devicetree/bindings/arm/atmel-pmc.txt
> b/Documentation/devicetree/bindings/arm/atmel-pmc.txt index
> 389bed5056e8..4ce09d1acdc9 100644 ---
> a/Documentation/devicetree/bindings/arm/atmel-pmc.txt +++
> b/Documentation/devicetree/bindings/arm/atmel-pmc.txt @@ -1,7 +1,10 @@
>  * Power Management Controller (PMC)
>  
>  Required properties:
> -- compatible: Should be "atmel,at91rm9200-pmc"
> +- compatible: Should be "atmel,<chip>-pmc".
> +	<chip> can be: at91rm9200, at91sam9260, at91sam9g45,
> at91sam9n12,
> +	at91sam9x5
> +

You missed sama5d3.

>  - reg: Should contain PMC registers location and length
>  
>  Examples:



-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
