Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758645AbaCTNgV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 09:36:21 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:58943 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758534AbaCTNgQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 09:36:16 -0400
Message-ID: <532AEE73.4090904@ti.com>
Date: Thu, 20 Mar 2014 15:34:43 +0200
From: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: <santosh.shilimkar@ti.com>
CC: <robh+dt@kernel.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <linux@arm.linux.org.uk>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <grygorii.strashko@ti.com>
Subject: Re: [PATCH 0/2] Disable subpage write for k2hk-evm
References: <1395267345-27795-1-git-send-email-ivan.khoronzhuk@ti.com>
In-Reply-To: <1395267345-27795-1-git-send-email-ivan.khoronzhuk@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please ignore this series

On 03/20/2014 12:15 AM, Ivan Khoronzhuk wrote:
> These patches disable subpage write for k2hk-evm.
>
> Based on linux-next
> tag: next-20140319
>
> Ivan Khoronzhuk (2):
>    mtd: davinci-nand: add dts property for NAND_NO_SUBPAGE_WRITE option
>    ARM: dts: keystone: disable subpage write for davinci nand device
>
>   Documentation/devicetree/bindings/mtd/davinci-nand.txt | 2 ++
>   arch/arm/boot/dts/k2hk-evm.dts                         | 1 +
>   drivers/mtd/nand/davinci_nand.c                        | 3 +++
>   3 files changed, 6 insertions(+)
>

-- 
Regards,
Ivan Khoronzhuk

