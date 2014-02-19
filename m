Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754018AbaBSPMp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 10:12:45 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:33241 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753771AbaBSPMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 10:12:43 -0500
X-AuditID: cbfec7f5-b7fc96d000004885-2b-5304c9e89e5d
Message-id: <5304C9E6.9060705@samsung.com>
Date: Wed, 19 Feb 2014 16:12:38 +0100
From: Tomasz Figa <t.figa@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.1.1
MIME-version: 1.0
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Mark Brown <broonie@kernel.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, devicetree@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH v3 15/15] mfd: max14577: Add device tree bindings document
References: <1392627950-26927-1-git-send-email-k.kozlowski@samsung.com>
 <1392627950-26927-16-git-send-email-k.kozlowski@samsung.com>
In-reply-to: <1392627950-26927-16-git-send-email-k.kozlowski@samsung.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgkeLIzCtJLcpLzFFi42I5/e/4Vd0XJ1mCDSa8NbfYOGM9q8XUh0/Y
	LK5/ec5qMenJe2aL+UfOsVpMXDmZ2eL1C0OLs01v2C3ufz3KaLHp8TVWi8u75rBZrD1yl91i
	6fWLTBa3G1ewWUyYvpbFonXvEXaL092sDoIea+atYfTYOesuu8fmFVoem1Z1snncubaHzWPe
	yUCPzUvqPfq2rGL0+LxJLoAzissmJTUnsyy1SN8ugSuj7/tP1oJXbBWLOxawNDA+Ze1i5OSQ
	EDCReH11PhuELSZx4d56IJuLQ0hgKaPEns0fWSCcz4wSM2c/YAGp4hXQklh15CdYN4uAqsTZ
	HxPZQWw2ATWJzw2PwCaJCkRI/J23nhGiXlDix+R7YINEBLYySWy5c4MJxGEW+M4kcX7te6AM
	B4ewgJ9Ew+9EkAYhgTZGicPb6kBsTgFPifamJrAFzALWEisnbWOEsOUlNq95yzyBUWAWkh2z
	kJTNQlK2gJF5FaNoamlyQXFSeq6RXnFibnFpXrpecn7uJkZIrH3dwbj0mNUhRgEORiUeXo8X
	zMFCrIllxZW5hxglOJiVRHhDl7EEC/GmJFZWpRblxxeV5qQWH2Jk4uCUamDkMxZzNdH5MbVd
	ImKLeXjo54CYIKG7ry0XTRJP3LJomeDy5Vf51h+O9e+Y9om3oHfZ8vtnCtNnLq5Wjz8tPkXf
	5N/Uh1PNo9+4itcrXw/WNLp5fgerRIfubkGf696LYm973u9gYEkp5VY0aju+ZLvQ87AKIRXz
	W2fK7j98teNbSHVK72ynOVxKLMUZiYZazEXFiQCgVaVzkwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 17.02.2014 10:05, Krzysztof Kozlowski wrote:
> Add document describing device tree bindings for MAX14577 MFD
> drivers: MFD core, extcon, regulator and charger.
>
> Both MAX14577 and MAX77836 chipsets are documented.
>
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> Cc: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: Tomasz Figa <t.figa@samsung.com>
> Cc: Marek Szyprowski <m.szyprowski@samsung.com>
> Cc: devicetree@vger.kernel.org
> Cc: Rob Herring <robh+dt@kernel.org>
> Cc: Pawel Moll <pawel.moll@arm.com>
> Cc: Mark Rutland <mark.rutland@arm.com>
> ---
>   Documentation/devicetree/bindings/mfd/max14577.txt |  149 ++++++++++++++++++++
>   1 file changed, 149 insertions(+)
>   create mode 100644 Documentation/devicetree/bindings/mfd/max14577.txt

Reviewed-by: Tomasz Figa <t.figa@samsung.com>

Best regards,
Tomasz
