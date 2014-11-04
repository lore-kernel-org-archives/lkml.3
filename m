Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753316AbaKDLKx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 06:10:53 -0500
Received: from bhuna.collabora.co.uk ([93.93.135.160]:40066 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752846AbaKDLKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 06:10:49 -0500
Message-ID: <5458B433.50706@collabora.co.uk>
Date: Tue, 04 Nov 2014 12:10:43 +0100
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
CC: Mark Brown <broonie@kernel.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>, Olof Johansson <olof@lixom.net>,
        Chris Zhong <zyw@rock-chips.com>,
        Abhilash Kesavan <kesavan.abhilash@gmail.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v4 11/14] regulator: max77802: Document binding for regulator
 operating modes
References: <1415025649-8119-1-git-send-email-javier.martinez@collabora.co.uk> <1415025649-8119-12-git-send-email-javier.martinez@collabora.co.uk> <1415098229.7941.12.camel@AMDC1943>
In-Reply-To: <1415098229.7941.12.camel@AMDC1943>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Krzysztof,

On 11/04/2014 11:50 AM, Krzysztof Kozlowski wrote:
>> +
>> +The possible values for "regulator-initial-mode" and "regulator-mode" are:
>> +	1: Normal regulator voltage output mode.
>> +	3: Low Power which reduces the quiescent current down to only 1uA
>> +
>> +The list of valid modes are defined in the dt-bindings/regulator/regulator.h
>> +header and can be included by device tree source files.
> 
> The more he looked inside, the more regulator.h wasn't there.
> 

Right, that's a typo from when the documentation was updated since previous
versions used the standard modes instead of hardware specific modes.

Should say that are defined in include/dt-bindings/regulator/maxim,max77802.h
instead, sorry about that.

Best regards,
Javier

