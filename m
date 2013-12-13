Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752658Ab3LMLX1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 06:23:27 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:51041 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752215Ab3LMLXZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 06:23:25 -0500
Message-ID: <52AAEE0D.7010203@ti.com>
Date: Fri, 13 Dec 2013 16:52:53 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Tomasz Stanislawski <t.stanislaws@samsung.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-samsung-soc@vger.kernel.org>, <devicetree@vger.kernel.org>
CC: <t.figa@samsung.com>, <kgene.kim@samsung.com>, <grant.likely@linaro.org>,
        <rob.herring@calxeda.com>, <sylvester.nawrocki@gmail.com>,
        <kyungmin.park@samsung.com>
Subject: Re: [PATCH] phy: Add exynos-phy driver
References: <1385558788-10880-1-git-send-email-t.stanislaws@samsung.com> <52A8364B.5020204@ti.com> <52A83B87.205@samsung.com>
In-Reply-To: <52A83B87.205@samsung.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wednesday 11 December 2013 03:46 PM, Sylwester Nawrocki wrote:
> On 11/12/13 10:54, Kishon Vijay Abraham I wrote:
>> On Wednesday 27 November 2013 06:56 PM, Tomasz Stanislawski wrote:
>>>> Hello everyone,
>>>> The Samsung SoCs from Exynos family are enhanced with a bunch of switches
>>>> dedicated for IP blocks. Those switches are called PHYs in Exynos
>>>> specification. They are usually controlled by a single bit in a single
>>>> one-word-long register.
>>
>> So only enabling this switch is enough for the controller or some other actual
>> PHY IP is needed along with this switch?
>>
>> However I'm not sure if the switch should be modelled as PHY as it is not a PHY
>> in the real sense.
> 
> These are ordinary PHY devices embedded in an SoC. I wouldn't really call
> them "switches", as they indeed provide the physical layer functionality 
> for various interfaces, like USB, HDMI, MIPI CSI/DSI, etc. Their control 

Are they used along with the phy IPs for which Kamil and others have sent
patches or this is used in different SoCs from what Kamil uses?

Thanks
Kishon

> interface is often very simple - usually only an enable and a reset 
> control bit. But that can't change the fact they are real PHY devices,
> so let's not call them switches, that's just untrue.
> 
> Regards,
> Sylwester
> 

