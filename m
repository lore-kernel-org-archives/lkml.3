Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757078AbaGQKvj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 06:51:39 -0400
Received: from mail-lb0-f178.google.com ([209.85.217.178]:56281 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757026AbaGQKvf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 06:51:35 -0400
MIME-Version: 1.0
In-Reply-To: <CAMf-jSk5+c1QYfKfjqmstB60bM3adK5tgAYwmPKhOi6cSeM_WA@mail.gmail.com>
References: <1404834869-23049-1-git-send-email-svarbanov@mm-sol.com>
	<1404834869-23049-2-git-send-email-svarbanov@mm-sol.com>
	<CAMf-jSk5+c1QYfKfjqmstB60bM3adK5tgAYwmPKhOi6cSeM_WA@mail.gmail.com>
Date: Thu, 17 Jul 2014 16:21:33 +0530
Message-ID: <CAMf-jSkxEmCeKDfw+=+QwgLHz7wYdWJB9qk1bi1gzP7Qpw-6jQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] mfd: qpnp-spmi: add support for Qualcomm QPNP PMICs
From: pramod gurav <pramod.gurav.etc@gmail.com>
To: Stanimir Varbanov <svarbanov@mm-sol.com>
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, Kumar Gala <galak@codeaurora.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Grant Likely <grant.likely@linaro.org>,
        Courtney Cavin <courtney.cavin@sonymobile.com>,
        Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Josh Cartwright <joshc@codeaurora.org>,
        Mark Brown <broonie@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2014 at 4:18 PM, pramod gurav
<pramod.gurav.etc@gmail.com> wrote:
> +Mark Brown
> Hi Josh/Stanimir,
>
>
> On Tue, Jul 8, 2014 at 9:24 PM, Stanimir Varbanov <svarbanov@mm-sol.com> wrote:
>> From: Josh Cartwright <joshc@codeaurora.org>
>>
>> The Qualcomm QPNP PMIC chips are components used with the
>> Snapdragon 800 series SoC family.  This driver exists
> .
> [SNIP]
> .
>> +config MFD_QPNP_SPMI
>> +       tristate "Qualcomm QPNP SPMI PMIC"
>> +       depends on ARCH_QCOM || COMPILE_TEST
>> +       depends on OF
>> +       select MFD_CORE
>> +       select REGMAP_SPMI
> REGMAP_SPMI use SPMI functions.
>
> https://patchwork.kernel.org/patch/4566591/

Sorry for incomplete comment as I sent the mail by mistake.
In above patchwork discussion Mark Brown suggested "driver using
REGMAP_SPMI should depend on SPMI and select REGMAP_SPMI, assuming
SPMI is a user-selectable Kconfig symbol."

>> +       help
>> +         This enables support for the Qualcomm QPNP SPMI PMICs.
>> +         These PMICs are currently used with the Snapdragon 800 series of
>> +         SoCs.  Note, that this will only be useful paired with descriptions
> .
>
> --
> Thanks and Regards
> Pramod



-- 
Thanks and Regards
Pramod
