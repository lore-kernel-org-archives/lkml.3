Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751713Ab3LKKQw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 05:16:52 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:43660 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751664Ab3LKKQr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 05:16:47 -0500
X-AuditID: cbfec7f5-b7fd16d000007299-42-52a83b8d55ac
Message-id: <52A83B87.205@samsung.com>
Date: Wed, 11 Dec 2013 11:16:39 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.1.1
MIME-version: 1.0
To: Kishon Vijay Abraham I <kishon@ti.com>,
        Tomasz Stanislawski <t.stanislaws@samsung.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org
Cc: t.figa@samsung.com, kgene.kim@samsung.com, grant.likely@linaro.org,
        rob.herring@calxeda.com, sylvester.nawrocki@gmail.com,
        kyungmin.park@samsung.com
Subject: Re: [PATCH] phy: Add exynos-phy driver
References: <1385558788-10880-1-git-send-email-t.stanislaws@samsung.com>
 <52A8364B.5020204@ti.com>
In-reply-to: <52A8364B.5020204@ti.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrILMWRmVeSWpSXmKPExsVy+t/xq7q91iuCDDon81jMP3KO1eLAnx2M
	Fr0LrrJZXHjaw2ZxtukNu8Wmx9dYLS7vmsNmMeP8PiaLwysOMFnM+7yTyWL9jNcsFvPaX7I6
	8Hgs+HyF3WPnrLvsHneu7WHz2Lyk3qNvyypGj+M3tjN5fN4kF8AexWWTkpqTWZZapG+XwJUx
	ddp65oK9HBWdmz4xNzA+Yuti5OSQEDCRuLL5PBOELSZx4d56oDgXh5DAUkaJZfd3s4AkhAQ+
	MUqcWS4NYvMKqEnsaelhBLFZBFQlnu5qZwWx2QQMJXqP9oHFRQUiJP7OW88IUS8o8WPyPRaQ
	oSICjxklfm5cyQziMAvMYZT4sHot2BnCAvoSu1s2sUFsS5E4vnY+WDcn0Larz/uZQWxmAR2J
	/a3T2CBseYnNa94yT2AUmIVkySwkZbOQlC1gZF7FKJpamlxQnJSea6RXnJhbXJqXrpecn7uJ
	ERItX3cwLj1mdYhRgINRiYf3QNHyICHWxLLiytxDjBIczEoivCsYVgQJ8aYkVlalFuXHF5Xm
	pBYfYmTi4JRqYNzQFNkV8PDYmuMlPypNOGcdS3NtV7TcNEXwQUnBuVkb5KorXt0NfOjeKKHy
	OeGmqomA9I+VX7na5ZyE14Z3bJwudpPxyaFDS98bn81dOE9jQcG31K5XAs0Kl5n70uKjjp4+
	V1WYuo13yg+tS5VP5S6nskXWix1bdKU5TFM0Pfbnuqt2E/nzLiixFGckGmoxFxUnAgDvSTe9
	dAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/12/13 10:54, Kishon Vijay Abraham I wrote:
> On Wednesday 27 November 2013 06:56 PM, Tomasz Stanislawski wrote:
>> > Hello everyone,
>> > The Samsung SoCs from Exynos family are enhanced with a bunch of switches
>> > dedicated for IP blocks. Those switches are called PHYs in Exynos
>> > specification. They are usually controlled by a single bit in a single
>> > one-word-long register.
>
> So only enabling this switch is enough for the controller or some other actual
> PHY IP is needed along with this switch?
> 
> However I'm not sure if the switch should be modelled as PHY as it is not a PHY
> in the real sense.

These are ordinary PHY devices embedded in an SoC. I wouldn't really call
them "switches", as they indeed provide the physical layer functionality 
for various interfaces, like USB, HDMI, MIPI CSI/DSI, etc. Their control 
interface is often very simple - usually only an enable and a reset 
control bit. But that can't change the fact they are real PHY devices,
so let's not call them switches, that's just untrue.

Regards,
Sylwester
