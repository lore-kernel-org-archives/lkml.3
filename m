Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755062AbaGJC0V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 22:26:21 -0400
Received: from nasmtp01.atmel.com ([192.199.1.246]:23307 "EHLO
	DVREDG02.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751472AbaGJC0U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 22:26:20 -0400
Message-ID: <53BDF946.7060404@atmel.com>
Date: Thu, 10 Jul 2014 10:24:06 +0800
From: Bo Shen <voice.shen@atmel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Boris BREZILLON <boris.brezillon@free-electrons.com>
CC: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>
Subject: Re: [PATCH v2 0/2] ARM: at91: remove phy fixup for sama5d3xek boards
References: <1403777615-25685-1-git-send-email-boris.brezillon@free-electrons.com> <20140709183442.14b8aef8@bbrezillon>
In-Reply-To: <20140709183442.14b8aef8@bbrezillon>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.168.5.13]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Boris,

On 07/10/2014 12:34 AM, Boris BREZILLON wrote:
> Hello Bo,
>
> I know you're quite busy, but if you have some time could you test this
> series on both CPU Modules (Embest and Ronetix): I only own the Embest
> one.
>
> Best Regards,
>
> Boris
>
> On Thu, 26 Jun 2014 12:13:33 +0200
> Boris BREZILLON <boris.brezillon@free-electrons.com> wrote:
>
>> Hello,
>>
>> This patch removes a board specific hook for sama5d3xek boards from the
>> sama5d3 generic DT board file.
>>
>> This hook (which register a phy fixup configuring board specific delays
>> in the ksz9021 ethernet phy) is now replaced by the appropriate DT
>> properties definitions in the sama5d3xcm.dtsi file.
>>
>> Best Regards,
>>
>> Boris
>>
>> Changes since v1:
>>   - fix txc-skew-ps and rxc-skew-ps delays
>>   - remove phy address info to handle Ronetix and Embest HW designs
>>
>> Boris BREZILLON (2):
>>    ARM: at91/dt: describe rgmii ethernet phy connected to sama5d3xek
>>      boards
>>    ARM: at91: remove phy fixup for sama5d3xek boards
>>
>>   arch/arm/boot/dts/sama5d3xcm.dtsi   | 15 +++++++++++++++
>>   arch/arm/mach-at91/board-dt-sama5.c | 22 ----------------------
>>   2 files changed, 15 insertions(+), 22 deletions(-)
>>

For this series, test OK on sama5d33ek (Ronetix) and sama5d34ek (Embest).

Tested-by: Bo Shen <voice.shen@atmel.com>

Best Regards,
Bo Shen

