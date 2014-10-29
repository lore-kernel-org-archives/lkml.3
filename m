Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756708AbaJ2Tbu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 15:31:50 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:33063 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755214AbaJ2Tbs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 15:31:48 -0400
Message-ID: <5451407A.8060408@ti.com>
Date: Wed, 29 Oct 2014 15:31:06 -0400
From: Murali Karicheri <m-karicheri2@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Santosh Shilimkar <santosh.shilimkar@gmail.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Santosh Shilimkar <ssantosh@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, <devicetree@vger.kernel.org>
Subject: Re: [PATCH v1 0/4] Enable PCI controller for Keystone SoCs
References: <1414601134-31825-1-git-send-email-m-karicheri2@ti.com> <54513AE2.6000304@gmail.com>
In-Reply-To: <54513AE2.6000304@gmail.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/29/2014 03:07 PM, Santosh Shilimkar wrote:
> Murali,
>
> On 10/29/2014 09:45 AM, Murali Karicheri wrote:
>> Now that Keystone PCI driver is merged to v3.18, this patch series
>> add build options and DTS bindings to enable the driver for Keystone
>> SoCs.
>>
>> v1: resend with some minor fix up of the commit description and fixing
>> the email ID for Santosh.
>>
>> CC: Santosh Shilimkar <ssantosh@kernel.org>
>> CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> CC: Rob Herring <robh+dt@kernel.org>
>> CC: Pawel Moll <pawel.moll@arm.com>
>> CC: Mark Rutland <mark.rutland@arm.com>
>> CC: Ian Campbell <ijc+devicetree@hellion.org.uk>
>> CC: Kumar Gala <galak@codeaurora.org>
>> CC: Russell King <linux@arm.linux.org.uk>
>> CC: devicetree@vger.kernel.org
>>
>> Murali Karicheri (4):
>> ARM: keystone: add pcie related options
>> ARM: keystone: defconfig: add options to enable PCI controller
>> ARM: dts: keystone: add DT bindings for PCI controller for port 0
>> ARM: dts: keystone-k2e: add DT bindings for PCI controller for port 1
>>
> Couple of minor comments o.w series looks fine by me. Once you
> address the comment, please post updated version and I shall
> queue that up for the next merge window.
>
> Regards,
> Santosh
Thanks. Will repost with comments addressed.

-- 
Murali Karicheri
Linux Kernel, Texas Instruments
