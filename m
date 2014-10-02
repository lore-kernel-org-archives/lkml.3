Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752623AbaJBV0Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 17:26:16 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:54419 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752247AbaJBV0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 17:26:15 -0400
Message-ID: <542DC2F5.7080508@codeaurora.org>
Date: Thu, 02 Oct 2014 14:26:13 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Kumar Gala <galak@codeaurora.org>
CC: Georgi Djakov <gdjakov@mm-sol.com>, mturquette@linaro.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH v1] clk: qcom: Add support for regmap clock dividers
References: <1412097655-10662-1-git-send-email-gdjakov@mm-sol.com> <542D953F.3030701@codeaurora.org> <40F825DC-F79B-43F6-9E9B-5E3879669155@codeaurora.org>
In-Reply-To: <40F825DC-F79B-43F6-9E9B-5E3879669155@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/02/14 12:51, Kumar Gala wrote:
> On Oct 2, 2014, at 1:11 PM, Stephen Boyd <sboyd@codeaurora.org> wrote:
>
>> On 09/30/14 10:20, Georgi Djakov wrote:
>>> This patch expands the regmap support to allow registration of clock
>>> dividers. It just prepares for the introduction of a clkdiv driver,
>>> that will be in a separate patch.
>>> Such dividers are found in the Qualcomm PMIC chips such as PM8941,
>>> PMA8084 and others.
>> We're going to need to rework the Makefile in clk/qcom so that we only
>> build certain pieces of the "library" when we need them. Right now the
>> directory is focused entirely on mmio clock controllers and if we put
>> the pmic clocks in there then we need to figure out a way to only build
>> the pmic pieces if only the pmic driver is selected and only build the
>> mmio pieces if the mmio drivers are selected.
> Would we ever not build the mmio drivers or do you mean something else?
>
>

Yes I mean we may not build the mmio drivers.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

