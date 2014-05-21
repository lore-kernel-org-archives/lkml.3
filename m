Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753215AbaEUTOh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 15:14:37 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:35900 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753069AbaEUTOf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 15:14:35 -0400
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 7.2 \(1874\))
Subject: Re: [PATCH v1 4/4] ARM: debug: qcom: Add APQ8084 DEBUG_LL UART support
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <1400686086.856.15.camel@iivanov-dev>
Date: Wed, 21 May 2014 14:14:29 -0500
Cc: Arnd Bergmann <arnd@arndb.de>, Georgi Djakov <gdjakov@mm-sol.com>,
        linux@arm.linux.org.uk, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        sboyd@codeaurora.org, rvaswani@codeaurora.org, davidb@codeaurora.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <A9A4B705-E550-407D-BDAD-91083417B356@codeaurora.org>
References: <1400684225-21381-1-git-send-email-gdjakov@mm-sol.com> <1400684225-21381-5-git-send-email-gdjakov@mm-sol.com> <4365639.JcFl1cP048@wuerfel> <1400686086.856.15.camel@iivanov-dev>
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
X-Mailer: Apple Mail (2.1874)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On May 21, 2014, at 10:28 AM, Ivan T. Ivanov <iivanov@mm-sol.com> wrote:

> Hi, 
> 
> On Wed, 2014-05-21 at 17:18 +0200, Arnd Bergmann wrote:
>> On Wednesday 21 May 2014 17:57:05 Georgi Djakov wrote:
> 
>>> 
>>> +#ifdef CONFIG_DEBUG_APQ8084_UART
>>> +#define MSM_DEBUG_UART_BASE    0xFA75E000
>>> +#define MSM_DEBUG_UART_PHYS    0xF995E000
>>> +#endif
>>> +
> 
>> Maybe we should move debug/msm.S over to use
>> CONFIG_DEBUG_UART_PHYS/CONFIG_DEBUG_UART_VIRT now?
>> 
> 
> There is patch which do this [1]. It was reviewed 
> by Stephen Boyd [2].
> 
> Regards,
> Ivan
> 
> 
> [1] https://lkml.org/lkml/2014/4/14/312
> [2] https://lkml.org/lkml/2014/4/14/542

I’ll grab Ivan’s patch and send via my qcom tree to arm-soc.

- k

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

