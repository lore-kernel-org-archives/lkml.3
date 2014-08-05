Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754304AbaHEEHh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 00:07:37 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:47842 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753769AbaHEEHe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 00:07:34 -0400
From: Lina Iyer <lina.iyer@linaro.org>
X-Google-Original-From: Lina Iyer <Lina@linaro.org>
Date: Mon, 4 Aug 2014 22:07:31 -0600 (MDT)
X-X-Sender: Lina@ilina-mac
To: Stephen Boyd <sboyd@codeaurora.org>
cc: David Brown <davidb@codeaurora.org>, Kumar Gala <galak@codeaurora.org>,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Lina Iyer <lina.iyer@linaro.org>
Subject: Re: [PATCH 8/8] msm: scm: Move the scm driver to drivers/soc/qcom
In-Reply-To: <1407202310-3359-9-git-send-email-sboyd@codeaurora.org>
Message-ID: <alpine.OSX.2.03.1408042203100.87047@linaro.org>
References: <1407202310-3359-1-git-send-email-sboyd@codeaurora.org> <1407202310-3359-9-git-send-email-sboyd@codeaurora.org>
User-Agent: Alpine 2.03 (OSX 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Aug 2014, Stephen Boyd wrote:

> Architectural changes in the ARM Linux kernel tree mandate
> the eventual removal of the mach-* directories. Move the
> scm driver to drivers/soc/qcom and the scm header to
> include/soc/qcom to support that removal.
> 
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---
>  arch/arm/mach-qcom/Kconfig                     | 3 ---
>  arch/arm/mach-qcom/Makefile                    | 4 +---
>  arch/arm/mach-qcom/scm-boot.c                  | 2 +-

 diff --git a/arch/arm/mach-qcom/scm.h b/include/soc/qcom/scm.h
> similarity index 100%
> rename from arch/arm/mach-qcom/scm.h
> rename to include/soc/qcom/scm.h

Could we move scm-boot.c as well to drivers/soc/qcom and scm-boot.h to include/soc/qcom ?
