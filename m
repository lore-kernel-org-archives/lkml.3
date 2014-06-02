Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754005AbaFBUlh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 16:41:37 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:59567 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752423AbaFBUlf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 16:41:35 -0400
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.2\))
Subject: Re: [PATCH v2 3/4] ARM: dts: qcom: Add APQ8084 Global Clock Controller DT node
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <1401551134-28485-4-git-send-email-gdjakov@mm-sol.com>
Date: Mon, 2 Jun 2014 15:41:24 -0500
Cc: Mike Turquette <mturquette@linaro.org>, linux@arm.linux.org.uk,
        robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, sboyd@codeaurora.org,
        rdunlap@infradead.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <DDE79254-2F56-47AC-A689-5A0E8E131126@codeaurora.org>
References: <1401551134-28485-1-git-send-email-gdjakov@mm-sol.com> <1401551134-28485-4-git-send-email-gdjakov@mm-sol.com>
To: Georgi Djakov <gdjakov@mm-sol.com>
X-Mailer: Apple Mail (2.1878.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On May 31, 2014, at 10:45 AM, Georgi Djakov <gdjakov@mm-sol.com> wrote:

> This patch adds the necessary node to probe the global clock
> controller on APQ8084 platforms.
> 
> Signed-off-by: Georgi Djakov <gdjakov@mm-sol.com>
> ---
> arch/arm/boot/dts/qcom-apq8084.dtsi |   10 ++++++++++
> 1 file changed, 10 insertions(+)

Can you split the 2 DT patches into their own patchset since they will go via the qcom/arm-soc tree and not Mike’s clk tree.

thanks

- k

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

