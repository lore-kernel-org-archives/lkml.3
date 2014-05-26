Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752528AbaEZNtY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 09:49:24 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:43197 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752318AbaEZNtX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 09:49:23 -0400
Message-ID: <1401112119.856.37.camel@iivanov-dev>
Subject: Re: [GIT PULL] qcom SoC changes for v3.16
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Kumar Gala <galak@codeaurora.org>,
        arm@kernel.org, Kevin Hilman <khilman@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        linux-kernel@vger.kernel.org, Olof Johansson <olof@lixom.net>,
        David Brown <davidb@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org, agross@codeaurora.org,
        linus.walleij@linaro.org, srinivas.kandagatla@linaro.org
Date: Mon, 26 May 2014 16:48:39 +0300
In-Reply-To: <1401108595.6068.5.camel@x220>
References: <alpine.DEB.2.00.1405231339340.15680@galak-ubuntu.qualcomm.com>
	 <1401108595.6068.5.camel@x220>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.1-2ubuntu2~saucy1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-05-26 at 14:49 +0200, Paul Bolle wrote:
> On Fri, 2014-05-23 at 13:42 -0500, Kumar Gala wrote:
> > Ivan T. Ivanov (1):
> >        ARM: debug: qcom: make UART address selection configuration option
> 
> This one just landed in linux-next (next-20140526).
> 
> It removed the Kconfig options DEBUG_MSM_UART1, DEBUG_MSM_UART3, and
> DEBUG_MSM_UART3. It did not touch these references to their macros:
>     arch/arm/mach-msm/io.c:60:#if defined(CONFIG_DEBUG_MSM_UART1) || defined(CONFIG_DEBUG_MSM_UART2) || \
>     arch/arm/mach-msm/io.c:61:                defined(CONFIG_DEBUG_MSM_UART3)
>     arch/arm/mach-msm/io.c:79:#if defined(CONFIG_DEBUG_MSM_UART1) || defined(CONFIG_DEBUG_MSM_UART2) || \
>     arch/arm/mach-msm/io.c:80:                defined(CONFIG_DEBUG_MSM_UART3)
> 
> Is a patch to fix this queued somewhere?
> 

Hm, there was some conflicts, which where resolved by Stephen
Rothwell [1], but maybe there is still something wrong. Have to check.

Regards,
Ivan

[1] https://lkml.org/lkml/2014/5/25/147


> 
> Paul Bolle
> 


