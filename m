Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753031AbaB1Qvc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 11:51:32 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:41745 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752868AbaB1Qv1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 11:51:27 -0500
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 7.2 \(1874\))
Subject: Re: [PATCH v9 3/3] mmc: sdhci-msm: Add platform_execute_tunning implementation
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <1393586675-14628-4-git-send-email-gdjakov@mm-sol.com>
Date: Fri, 28 Feb 2014 10:51:19 -0600
Cc: linux-mmc@vger.kernel.org, cjb@laptop.org, ulf.hansson@linaro.org,
        devicetree@vger.kernel.org, grant.likely@linaro.org,
        robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        swarren@wwwdotorg.org, ijc+devicetree@hellion.org.uk, rob@landley.net,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <F9D8CFEF-1A3C-4B25-B593-419C56E3A168@codeaurora.org>
References: <1393586675-14628-1-git-send-email-gdjakov@mm-sol.com> <1393586675-14628-4-git-send-email-gdjakov@mm-sol.com>
To: Georgi Djakov <gdjakov@mm-sol.com>
X-Mailer: Apple Mail (2.1874)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 28, 2014, at 5:24 AM, Georgi Djakov <gdjakov@mm-sol.com> wrote:

> This patch adds implementation for platform specific tuning in order to support
> HS200 bus speed mode on Qualcomm SDHCI controller.
> 
> Signed-off-by: Asutosh Das <asutoshd@codeaurora.org>
> Signed-off-by: Venkat Gopalakrishnan <venkatg@codeaurora.org>
> Signed-off-by: Georgi Djakov <gdjakov@mm-sol.com>
> ---
> drivers/mmc/host/sdhci-msm.c |  424 +++++++++++++++++++++++++++++++++++++++++-
> 1 file changed, 418 insertions(+), 6 deletions(-)

minor nit, in subject (platform_execute_tuning, with one ’n’).

- k

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

