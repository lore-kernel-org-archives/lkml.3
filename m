Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752064AbaEVQjE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 12:39:04 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:39766 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750872AbaEVQjB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 12:39:01 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 7.2 \(1874\))
Subject: Re: [PATCH v1 3/5] clk: gcc: Add APQ8084 Global Clock Controller support
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <1400775885-10296-4-git-send-email-gdjakov@mm-sol.com>
Date: Thu, 22 May 2014 11:38:55 -0500
Cc: mturquette@linaro.org, linux@arm.linux.org.uk, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, sboyd@codeaurora.org,
        rdunlap@infradead.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <DB9EC1F3-CA2B-47C5-A677-CC1222F05614@codeaurora.org>
References: <1400775885-10296-1-git-send-email-gdjakov@mm-sol.com> <1400775885-10296-4-git-send-email-gdjakov@mm-sol.com>
To: Georgi Djakov <gdjakov@mm-sol.com>
X-Mailer: Apple Mail (2.1874)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On May 22, 2014, at 11:24 AM, Georgi Djakov <gdjakov@mm-sol.com> wrote:

> This patch adds support for the global clock controller found on
> the APQ8084 based devices.
> 
> The APQ8084 and MSM8974 share a lot of clock data, so instead of
> duplicating all the data, we add support to the MSM8974 code.
> 
> Signed-off-by: Georgi Djakov <gdjakov@mm-sol.com>
> ---
> drivers/clk/qcom/Kconfig                     |    4 +-
> drivers/clk/qcom/gcc-msm8974.c               |  151 +++++++++++++++++++++++++-
> include/dt-bindings/clock/qcom,gcc-msm8974.h |    4 +
> 3 files changed, 154 insertions(+), 5 deletions(-)

What about differences in reset?

- k

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

