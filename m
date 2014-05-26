Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752572AbaEZNrV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 09:47:21 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:42998 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752228AbaEZNrT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 09:47:19 -0400
Message-ID: <538345F0.40605@mm-sol.com>
Date: Mon, 26 May 2014 16:47:28 +0300
From: Georgi Djakov <gdjakov@mm-sol.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>, Kumar Gala <galak@codeaurora.org>
CC: arm@kernel.org, Kevin Hilman <khilman@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        linux-kernel@vger.kernel.org, Olof Johansson <olof@lixom.net>,
        David Brown <davidb@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org, agross@codeaurora.org,
        linus.walleij@linaro.org, iivanov@mm-sol.com,
        srinivas.kandagatla@linaro.org
Subject: Re: [GIT PULL] qcom SoC changes for v3.16
References: <alpine.DEB.2.00.1405231339340.15680@galak-ubuntu.qualcomm.com> <1401108595.6068.5.camel@x220>
In-Reply-To: <1401108595.6068.5.camel@x220>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/26/2014 03:49 PM, Paul Bolle wrote:
> On Fri, 2014-05-23 at 13:42 -0500, Kumar Gala wrote:
>> Ivan T. Ivanov (1):
>>         ARM: debug: qcom: make UART address selection configuration option
>
> This one just landed in linux-next (next-20140526).
>
> It removed the Kconfig options DEBUG_MSM_UART1, DEBUG_MSM_UART3, and
> DEBUG_MSM_UART3. It did not touch these references to their macros:
>      arch/arm/mach-msm/io.c:60:#if defined(CONFIG_DEBUG_MSM_UART1) || defined(CONFIG_DEBUG_MSM_UART2) || \
>      arch/arm/mach-msm/io.c:61:                defined(CONFIG_DEBUG_MSM_UART3)
>      arch/arm/mach-msm/io.c:79:#if defined(CONFIG_DEBUG_MSM_UART1) || defined(CONFIG_DEBUG_MSM_UART2) || \
>      arch/arm/mach-msm/io.c:80:                defined(CONFIG_DEBUG_MSM_UART3)
>
> Is a patch to fix this queued somewhere?
>

Not yet, but I'll send one in a minute.

Thanks,
Georgi
