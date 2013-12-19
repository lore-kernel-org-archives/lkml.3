Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754409Ab3LSQrs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 11:47:48 -0500
Received: from eusmtp01.atmel.com ([212.144.249.242]:38174 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753476Ab3LSQrr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 11:47:47 -0500
Message-ID: <52B3232C.3000400@atmel.com>
Date: Thu, 19 Dec 2013 17:47:40 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Boris BREZILLON <b.brezillon@overkiz.com>,
        "Jean-Christophe Plagniol-Villard" <plagnioj@jcrosoft.com>
CC: Russell King <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] ARM: at91/dt: add clock properties to sama5d3 crypto
 devs
References: <1387465875-4548-1-git-send-email-b.brezillon@overkiz.com>
In-Reply-To: <1387465875-4548-1-git-send-email-b.brezillon@overkiz.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19/12/2013 16:11, Boris BREZILLON :
> Hello,
> 
> This series adds missing clock properties in sama5d3 crypto devices nodes.

Fine, thanks Boris. On the whole series:

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

and integrated in the at91-3.14-dt2 branch.

Bye,

> Best Regards,
> 
> Boris
> 
> Boris BREZILLON (3):
>   ARM: at91/dt: add clk properties to sama5d3 SHA device node
>   ARM: at91/dt: add clk properties to sama5d3 AES device node
>   ARM: at91/dt: add clk properties to sama5d3 TDES device node
> 
>  arch/arm/boot/dts/sama5d3.dtsi |    6 ++++++
>  1 file changed, 6 insertions(+)
> 


-- 
Nicolas Ferre
