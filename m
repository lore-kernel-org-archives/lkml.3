Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752331AbaEZMt7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 08:49:59 -0400
Received: from cpsmtpb-ews07.kpnxchange.com ([213.75.39.10]:54906 "EHLO
	cpsmtpb-ews07.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751985AbaEZMt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 08:49:57 -0400
Message-ID: <1401108595.6068.5.camel@x220>
Subject: Re: [GIT PULL] qcom SoC changes for v3.16
From: Paul Bolle <pebolle@tiscali.nl>
To: Kumar Gala <galak@codeaurora.org>
Cc: arm@kernel.org, Kevin Hilman <khilman@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        linux-kernel@vger.kernel.org, Olof Johansson <olof@lixom.net>,
        David Brown <davidb@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org, agross@codeaurora.org,
        linus.walleij@linaro.org, iivanov@mm-sol.com,
        srinivas.kandagatla@linaro.org
Date: Mon, 26 May 2014 14:49:55 +0200
In-Reply-To: <alpine.DEB.2.00.1405231339340.15680@galak-ubuntu.qualcomm.com>
References: <alpine.DEB.2.00.1405231339340.15680@galak-ubuntu.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 May 2014 12:49:55.0044 (UTC) FILETIME=[FE3CD240:01CF78E0]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-05-23 at 13:42 -0500, Kumar Gala wrote:
> Ivan T. Ivanov (1):
>        ARM: debug: qcom: make UART address selection configuration option

This one just landed in linux-next (next-20140526).

It removed the Kconfig options DEBUG_MSM_UART1, DEBUG_MSM_UART3, and
DEBUG_MSM_UART3. It did not touch these references to their macros:
    arch/arm/mach-msm/io.c:60:#if defined(CONFIG_DEBUG_MSM_UART1) || defined(CONFIG_DEBUG_MSM_UART2) || \
    arch/arm/mach-msm/io.c:61:                defined(CONFIG_DEBUG_MSM_UART3)
    arch/arm/mach-msm/io.c:79:#if defined(CONFIG_DEBUG_MSM_UART1) || defined(CONFIG_DEBUG_MSM_UART2) || \
    arch/arm/mach-msm/io.c:80:                defined(CONFIG_DEBUG_MSM_UART3)

Is a patch to fix this queued somewhere?


Paul Bolle

