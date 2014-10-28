Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754139AbaJ1QIM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 12:08:12 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:47138 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754004AbaJ1QII (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 12:08:08 -0400
Message-ID: <544FBF4D.6000502@ti.com>
Date: Tue, 28 Oct 2014 12:07:41 -0400
From: Murali Karicheri <m-karicheri2@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Murali Karicheri <m-karicheri2@ti.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@gmail.com>
Subject: Re: [PATCH 0/4] Enable PCI controller for Keystone SoCs
References: <1414173095-32511-1-git-send-email-m-karicheri2@ti.com> <544FBF1C.80305@ti.com>
In-Reply-To: <544FBF1C.80305@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/28/2014 12:06 PM, Murali Karicheri wrote:
> On 10/24/2014 01:51 PM, Murali Karicheri wrote:
>> Now that Keystone PCI driver is merged to v3.18, this patch series
>> add build options and DTS bindings to enable the driver for Keystone
>> SoCs.
>>
>> CC : Santosh Shilimkar<santosh.shilimkar@gmail.com>
>> CC : Greg Kroah-Hartman<gregkh@linuxfoundation.org>
>> CC : Rob Herring<robh+dt@kernel.org>
>> CC : Pawel Moll<pawel.moll@arm.com>
>> CC : Mark Rutland<mark.rutland@arm.com>
>> CC : Ian Campbell<ijc+devicetree@hellion.org.uk>
>> CC : Kumar Gala<galak@codeaurora.org>
>> CC : Russell King<linux@arm.linux.org.uk>
>> CC : devicetree@vger.kernel.org
>>
>> Murali Karicheri (4):
>> ARM: keystone: add pcie related options
>> ARM: keystone: defconfig: add options to enable PCI controller
>> ARM: keystone: dts: add DT bindings for PCI controller for port 0
>> ARM: keystone: dts: add DT bindings for PCI controller for port 1
>>
>> arch/arm/boot/dts/k2e.dtsi | 45 +++++++++++++++++++++++++++++++++++
>> arch/arm/boot/dts/keystone.dtsi | 45 +++++++++++++++++++++++++++++++++++
>> arch/arm/configs/keystone_defconfig | 3 +++
>> arch/arm/mach-keystone/Kconfig | 2 ++
>> 4 files changed, 95 insertions(+)
>>
> Santosh,
>
> Could you review this and apply to your tree for merge by end of this
> week if this looks good and there are no comments?
>
Adding Santosh's personal email ID

-- 
Murali Karicheri
Linux Kernel, Texas Instruments
