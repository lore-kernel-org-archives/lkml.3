Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756140AbaIEHW4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 03:22:56 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:39123 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751688AbaIEHWz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 03:22:55 -0400
Message-ID: <540964DD.7070203@mm-sol.com>
Date: Fri, 05 Sep 2014 10:23:09 +0300
From: Georgi Djakov <gdjakov@mm-sol.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>
CC: galak@codeaurora.org, iivanov@mm-sol.com, arm@kernel.org,
        khilman@linaro.org, arnd@arndb.de, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, olof@lixom.net, davidb@codeaurora.org,
        linux-arm-kernel@lists.infradead.org, agross@codeaurora.org,
        linus.walleij@linaro.org, srinivas.kandagatla@linaro.org
Subject: Re: [PATCH v2] ARM: msm: Update the references to DEBUG_MSM_UARTx
References: <1401116287.6068.15.camel@x220>	 <1401122260-12002-1-git-send-email-gdjakov@mm-sol.com>	 <1403165772.23136.17.camel@x220> <1409870314.5546.128.camel@x220>
In-Reply-To: <1409870314.5546.128.camel@x220>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/05/2014 01:38 AM, Paul Bolle wrote:
> On Thu, 2014-06-19 at 10:16 +0200, Paul Bolle wrote:
>> On Mon, 2014-05-26 at 19:37 +0300, Georgi Djakov wrote:
>>> The Kconfig options DEBUG_MSM_UART1, DEBUG_MSM_UART2, DEBUG_MSM_UART3,
>>> MSM_DEBUG_UART1, MSM_DEBUG_UART2 and MSM_DEBUG_UART3 are removed, but 
>>> they are still referenced in the following files:
>>> 	arch/arm/mach-msm/io.c,
>>> 	arch/arm/mach-msm/board-trout.c
>>> 	arch/arm/mach-msm/board-trout-gpio.c
>>>
>>> Fix this by updating the reference to the new Kconfig option.
>>>
>>> Reported-by: Paul Bolle <pebolle@tiscali.nl>
>>> Signed-off-by: Georgi Djakov <gdjakov@mm-sol.com>
>>> ---
>>
>> This patch is included neither in v3.16-rc1 nor in next-20140619.
> 
> Still true for v3.17-rc3 and next-20140904.
> 

Hi Paul,
It was pulled yesterday into the msm/cleanup branch of the arm-soc tree.

Thanks,
Georgi
