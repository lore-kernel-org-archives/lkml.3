Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756366AbaCEUWE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 15:22:04 -0500
Received: from ns.mm-sol.com ([37.157.136.199]:48105 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753398AbaCEUWB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 15:22:01 -0500
Message-ID: <53178767.9020908@mm-sol.com>
Date: Wed, 05 Mar 2014 22:21:59 +0200
From: Georgi Djakov <gdjakov@mm-sol.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Ulf Hansson <ulf.hansson@linaro.org>
CC: linux-mmc <linux-mmc@vger.kernel.org>, Chris Ball <cjb@laptop.org>,
        devicetree@vger.kernel.org, grant.likely@linaro.org,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        linux-doc@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH v10 1/3] mmc: sdhci-msm: Qualcomm SDHCI binding documentation
References: <1393961226-25618-1-git-send-email-gdjakov@mm-sol.com>	<1393961226-25618-2-git-send-email-gdjakov@mm-sol.com> <CAPDyKFp2whNGYj=bEM74DaNDjdqSkej=HsKD8AUNTo6hjZccHw@mail.gmail.com>
In-Reply-To: <CAPDyKFp2whNGYj=bEM74DaNDjdqSkej=HsKD8AUNTo6hjZccHw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/05/2014 06:25 AM, Ulf Hansson wrote:
> On 4 March 2014 20:27, Georgi Djakov <gdjakov@mm-sol.com> wrote:
[..]
>> +Required properties:
>> +- compatible: Should contain "qcom,sdhci-msm-v4".
>> +- reg: Base address and length of the register set listed in reg-names.
>> +- reg-names: Should contain the following:
>> +       "hc_mem"   - Host controller register map
>> +       "core_mem" - SD Core register map
>> +- interrupts: Should contain an interrupt-specifiers for the interrupts listed in interrupt-names.
>> +- interrupt-names: Should contain the following:
>> +       "hc_irq"     - Host controller interrupt
>> +       "pwr_irq"    - PMIC interrupt
>> +- vdd-supply: Phandle to the regulator for the vdd (core voltage) supply.
>> +- vdd-io-supply: Phandle to the regulator for the vdd-io (i/o voltage) supply.
>
> The common naming of the above regulators are "vmmc" and "vqmmc". Is
> there any specific reason to why you can't use these names?

Hi Ulf,
They are named this way on the schematics, i will change them to the 
common names. Thanks!

BR,
Georgi
