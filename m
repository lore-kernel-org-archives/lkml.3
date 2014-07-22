Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755185AbaGVLyV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 07:54:21 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:44167 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754463AbaGVLyD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 07:54:03 -0400
Message-ID: <53CE50D8.9070608@mm-sol.com>
Date: Tue, 22 Jul 2014 14:54:00 +0300
From: Stanimir Varbanov <svarbanov@mm-sol.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
CC: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Pawel Moll <pawel.moll@arm.com>, Rob Herring <robh+dt@kernel.org>,
        Kumar Gala <galak@codeaurora.org>, Mark Rutland <mark.rutland@arm.com>,
        Grant Likely <grant.likely@linaro.org>,
        Courtney Cavin <courtney.cavin@sonymobile.com>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Josh Cartwright <joshc@codeaurora.org>
Subject: Re: [PATCH v2 4/4] mfd: pm8921: rename pm8921-core driver
References: <1405613855-27572-1-git-send-email-svarbanov@mm-sol.com> <1405613855-27572-5-git-send-email-svarbanov@mm-sol.com> <20140722103252.GD8406@lee--X1>
In-Reply-To: <20140722103252.GD8406@lee--X1>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/22/2014 01:32 PM, Lee Jones wrote:
> On Thu, 17 Jul 2014, Stanimir Varbanov wrote:
> 
>> The pm8921-core driver presently supports pm8921 and pm8058
>> Qualcomm PMICs.  To avoid confusion with new generation PMICs
>> (like pm8941) rename the pm8921-core driver to more
>> appropriate name pm8xxx-ssbi, which reflects better that
>> those chips use SSBI interface.
>>
>> Signed-off-by: Stanimir Varbanov <svarbanov@mm-sol.com>
>> ---
>>  drivers/mfd/Kconfig                          |   14 +++++-----
>>  drivers/mfd/Makefile                         |    2 +-
>>  drivers/mfd/{pm8921-core.c => pm8xxx-ssbi.c} |   38 +++++++++++++-------------
>>  3 files changed, 27 insertions(+), 27 deletions(-)
>>  rename drivers/mfd/{pm8921-core.c => pm8xxx-ssbi.c} (92%)
> 
> Patch looks fine to me.
> 
>   Acked-by: Lee Jones <lee.jones@linaro.org>
> 
> I'm assuming we want to wait for the others in the set to be ready
> before applying?

yes, I think you will need an ack for the DT binding document?

-- 
regards,
Stan
