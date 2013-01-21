Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754363Ab3AUMdA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 07:33:00 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:36819 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752964Ab3AUMc5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 07:32:57 -0500
Message-ID: <50FD3561.7010104@ti.com>
Date: Mon, 21 Jan 2013 18:02:33 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: "Kumar, Anil" <anilkumar.v@ti.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <linux@arm.linux.org.uk>, <khilman@deeprootsystems.com>, <hs@denx.de>
Subject: Re: [PATCH V5 3/3] ARM: davinci: da850: add NAND driver DT entries
References: <1358327261-9679-1-git-send-email-anilkumar.v@ti.com> <1358327261-9679-4-git-send-email-anilkumar.v@ti.com>
In-Reply-To: <1358327261-9679-4-git-send-email-anilkumar.v@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Anil,

On 1/16/2013 2:37 PM, Kumar, Anil wrote:
> Add NAND driver DT node and related pinctrl DT data to export NAND
> functionality on da850 evm.
> 
> Signed-off-by: Kumar, Anil <anilkumar.v@ti.com>

I applied all three patches in this series.

> +	nand_cs3@62000000 {
> +		compatible = "ti,davinci-nand";
> +		reg = <0x62000000 0x807ff
> +			0x68000000 0x8000>;

While applying I changed the indentation of this line so the two
addresses are aligned.

Thanks,
Sekhar
