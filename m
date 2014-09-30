Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752218AbaI3TqY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 15:46:24 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:58780 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751165AbaI3TqV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 15:46:21 -0400
Message-ID: <542B088A.1050601@codeaurora.org>
Date: Tue, 30 Sep 2014 12:46:18 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Kiran Padwal <kiran.padwal@smartplayin.com>
CC: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <edubezval@gmail.com>, linux-pm@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, David Collins <collinsd@codeaurora.org>
Subject: Re: [PATCH v2] thermal: Add QPNP PMIC temperature alarm driver
References: <1411651825-14240-1-git-send-email-iivanov@mm-sol.com>	  <54254C4E.3070807@smartplayin.com> <1411998865.5395.5.camel@iivanov-dev>	 <542A31DF.7020402@smartplayin.com> <1412062606.5395.10.camel@iivanov-dev>
In-Reply-To: <1412062606.5395.10.camel@iivanov-dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/30/14 00:36, Ivan T. Ivanov wrote:
> On Tue, 2014-09-30 at 10:00 +0530, Kiran Padwal wrote:
>>
>> I have Linaro cross tool chain with version-4.8.3 and I am simply doing "make zImage" without any option.
> Hm, no warnings with arm-unknown-linux-gnueabi-gcc (GCC) 4.6.3 and
> arm-linux-gnueabihf-gcc (crosstool-NG linaro-1.13.1-4.9-2014.09, but
> indeed arm-linux-gnueabihf-gcc (crosstool-NG linaro-1.13.1-4.8-2014.03.
>
> I will say that this is false positive :-). Please update your tool-chain.

Hopefully you're joking. Once this merges someone will find the warning
and complain. Telling them to upgrade their compiler isn't going to work.

I wonder if checking for rc != 0 instead of rc < 0 would silence the
warning? Or get rid of the entire wrapper function and just use regmap
functions directly.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

