Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758129AbaAJTrm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 14:47:42 -0500
Received: from mail-pb0-f49.google.com ([209.85.160.49]:54704 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753397AbaAJTrj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 14:47:39 -0500
From: Kevin Hilman <khilman@linaro.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: arm@kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: msm_defconfig: Update for multi-platform
References: <1389381128-28280-1-git-send-email-sboyd@codeaurora.org>
Date: Fri, 10 Jan 2014 11:47:33 -0800
In-Reply-To: <1389381128-28280-1-git-send-email-sboyd@codeaurora.org> (Stephen
	Boyd's message of "Fri, 10 Jan 2014 11:12:08 -0800")
Message-ID: <87d2jzaaay.fsf@linaro.org>
User-Agent: Gnus/5.130008 (Ma Gnus v0.8) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Boyd <sboyd@codeaurora.org> writes:

> ARCH_MSM is a hidden config option now so this defconfig needs to
> be updated to select ARCH_MSM_DT instead. While we're here,
> remove dead symbols (SSBI), drop selected symbols (ZRELADDR,
> PHYLIB, USB_PHY) and enable the MSM random driver (HW_RANDOM_MSM).
>
> Cc: Kevin Hilman <khilman@deeprootsystems.com>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>

Applied to next/soc, merged into for-next and pushed out.

Thanks for the quick fixup.

Kevin
