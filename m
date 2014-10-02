Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752445AbaJBTv4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 15:51:56 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:49411 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945AbaJBTvy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 15:51:54 -0400
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: [PATCH v1] clk: qcom: Add support for regmap clock dividers
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <542D953F.3030701@codeaurora.org>
Date: Thu, 2 Oct 2014 14:51:50 -0500
Cc: Georgi Djakov <gdjakov@mm-sol.com>, mturquette@linaro.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Content-Transfer-Encoding: 7BIT
Message-Id: <40F825DC-F79B-43F6-9E9B-5E3879669155@codeaurora.org>
References: <1412097655-10662-1-git-send-email-gdjakov@mm-sol.com> <542D953F.3030701@codeaurora.org>
To: Stephen Boyd <sboyd@codeaurora.org>
X-Mailer: Apple Mail (2.1878.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 2, 2014, at 1:11 PM, Stephen Boyd <sboyd@codeaurora.org> wrote:

> On 09/30/14 10:20, Georgi Djakov wrote:
>> This patch expands the regmap support to allow registration of clock
>> dividers. It just prepares for the introduction of a clkdiv driver,
>> that will be in a separate patch.
>> Such dividers are found in the Qualcomm PMIC chips such as PM8941,
>> PMA8084 and others.
> 
> We're going to need to rework the Makefile in clk/qcom so that we only
> build certain pieces of the "library" when we need them. Right now the
> directory is focused entirely on mmio clock controllers and if we put
> the pmic clocks in there then we need to figure out a way to only build
> the pmic pieces if only the pmic driver is selected and only build the
> mmio pieces if the mmio drivers are selected.

Would we ever not build the mmio drivers or do you mean something else?

- k

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

