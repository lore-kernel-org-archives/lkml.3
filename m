Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753821Ab3FGTXE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 15:23:04 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:36498 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751708Ab3FGTXC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 15:23:02 -0400
Message-ID: <51B23312.8000402@wwwdotorg.org>
Date: Fri, 07 Jun 2013 13:22:58 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Benoit Cousson <b-cousson@ti.com>
CC: J Keerthy <j-keerthy@ti.com>, devicetree-discuss@lists.ozlabs.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        ldewangan@nvidia.com, grant.likely@secretlab.ca, swarren@nvidia.com,
        sameo@linux.intel.com, gg@slimlogic.co.uk, lee.jones@linaro.org
Subject: Re: [PATCH] ARM: dts: add dtsi for palmas
References: <1370604504-32310-1-git-send-email-j-keerthy@ti.com> <51B1D1A9.40702@ti.com>
In-Reply-To: <51B1D1A9.40702@ti.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/07/2013 06:27 AM, Benoit Cousson wrote:
> Hi Keerthy,
> 
> On 06/07/2013 01:28 PM, J Keerthy wrote:
>> Adds palmas mfd and palmas regulator nodes. This is
>> based on the patch series:
>>
>> http://www.mail-archive.com/linux-omap@vger.kernel.org/msg89957.html
>>
>> The device tree nodes are based on:
>> https://lkml.org/lkml/2013/6/6/25
...
>> diff --git a/arch/arm/boot/dts/palmas.dtsi b/arch/arm/boot/dts/palmas.dtsi
...
>> +&palmas {
>> +	compatible = "ti,palmas";
>> +	interrupt-controller;
>> +	#interrupt-cells = <2>;
> 
> The I2C address should be there as well. We used to put it in the board
> file, but this is really an I2C device specific information and not
> board specific in that case.

I thought the I2C address was variable depending on OTP settings, and
hence the I2C address is board-specific; depending on which variant of
the PMIC was stuffed onto the board?

