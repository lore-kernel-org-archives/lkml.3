Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753284AbaHEMAV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 08:00:21 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:57173 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751996AbaHEMAT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 08:00:19 -0400
Message-ID: <53E0C74A.2040108@mm-sol.com>
Date: Tue, 05 Aug 2014 15:00:10 +0300
From: Stanimir Varbanov <svarbanov@mm-sol.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Pramod Gurav <pramod.gurav@smartplayin.com>
CC: Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Pawel Moll <pawel.moll@arm.com>, Rob Herring <robh+dt@kernel.org>,
        Kumar Gala <galak@codeaurora.org>, Mark Rutland <mark.rutland@arm.com>,
        Grant Likely <grant.likely@linaro.org>,
        Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Courtney Cavin <courtney.cavin@sonymobile.com>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Josh Cartwright <joshc@codeaurora.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        David Collins <collinsd@codeaurora.org>
Subject: Re: [PATCH v4 0/3] Support for Qualcomm QPNP PMIC's
References: <1406903450-27283-1-git-send-email-svarbanov@mm-sol.com> <53E085C9.4090302@smartplayin.com>
In-Reply-To: <53E085C9.4090302@smartplayin.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pramod,

On 08/05/2014 10:20 AM, Pramod Gurav wrote:
> Hi Stanimir.
> On Friday 01 August 2014 08:00 PM, Stanimir Varbanov wrote:
>> Hello all,
>>
>> Changes since v3:
>>  - rename the driver to qcom-spmi-pmic - suggested by David Collins
>>  - spmi regmap config now initialize .fast_io to true
>>  - added generalized comptatible string in DT binding document and driver
>>  - I dropped the pm8921 rename patch for now, it will be subject of another
>>    patchset later on.
>>
>> regards,
>> Stan
>>
>> --------------------------------------------------------------------------------
>>
>> Changes since v2:
>>  - 1/4 - added new line, signed-off-by / acked-by and module_authors.
>>  - 3/4 - the subject has been changed.
>>
>> The previous v2 can be found at [1].
>>
>> I'm still waiting Acks for:
>>  - 4/4 from Qualcomm folks.
> 
> If I am not missing something obvious, this patch needs to be resent as
> it does not apply on top of patches in this series. I tried applying and
> it fails in Kconfig.

I dropped 4/4 from v4. See above what has been changed since v3.

-- 
regards,
Stan
