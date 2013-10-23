Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755217Ab3JWBst (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 21:48:49 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:32076 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755074Ab3JWBsr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 21:48:47 -0400
X-AuditID: cbfee691-b7f866d000001b8c-59-52672afd6889
From: Jingoo Han <jg1.han@samsung.com>
To: "'Johan Hovold'" <jhovold@gmail.com>
Cc: "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Nicolas Ferre'" <nicolas.ferre@atmel.com>,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <1382462819-28576-1-git-send-email-jhovold@gmail.com>
 <1382462819-28576-4-git-send-email-jhovold@gmail.com>
In-reply-to: <1382462819-28576-4-git-send-email-jhovold@gmail.com>
Subject: Re: [PATCH 3/9] backlight: atmel-pwm-bl: fix module autoload
Date: Wed, 23 Oct 2013 10:48:45 +0900
Message-id: <001b01cecf92$028357a0$078a06e0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7PS/Rj/aLk0YxaSdKjhZiQjtXH+wARfVaw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrAIsWRmVeSWpSXmKPExsVy+t8zY92/WulBBk13DS1eHtK0uLzwEqvF
	3lXSFif6PrBaXN41h83i2+Vmdovdu56yOrB7LPi1lcVj56y77B575v9g9ejbsorR4/MmuQDW
	KC6blNSczLLUIn27BK6MqYucCl4wVRx9v4C1gXEeUxcjJ4eEgInEo+nfWCFsMYkL99azdTFy
	cQgJLGOUWPP+ICtM0a31X5ggEtMZJb5v6mWFcH4xSiz4sp0NpIpNQE3iy5fD7CC2CJD9pPcI
	O0gRs8A2RokTy/cxgySEBCol7n2ZD9bAKeAk8ezxCUYQW1jAVeLMg36wZhYBVYnXZ56wgNi8
	ArYST7Y/Y4ewBSV+TL4HFmcW0JJYv/M4E4QtL7F5zVug+RxAp6pLPPqrC3GDkUTD1R+sECUi
	EvtevGMEuUdC4CW7xJ0lb1kgdglIfJt8iAWiV1Zi0wFmiI8lJQ6uuMEygVFiFpLNs5BsnoVk
	8ywkKxYwsqxiFE0tSC4oTkovMtUrTswtLs1L10vOz93ECIndiTsY7x+wPsSYDLR+IrOUaHI+
	MPbzSuINjc2MLExNTI2NzC3NSBNWEudNf5QUJCSQnliSmp2aWpBaFF9UmpNafIiRiYNTqoGx
	MuCA7eH6BHuerzkiSxxEzZRfnqoq/3XuTr/ahMJncYldy4/dL5110XHF1cdvKjYKazPuf7L1
	DQuLefeW9N4/nBuurGBn2J7AJ6E0af6Mmqq7XsFiEXsfLD0j+nzLiuvxykZGR3zL32U+VQ+d
	7VzTm31W88LWT/FXDI+2Kn/2O5kU3XP/jt0rJZbijERDLeai4kQA8PKw0fMCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLKsWRmVeSWpSXmKPExsVy+t9jQd2/WulBBmvPa1q8PKRpcXnhJVaL
	vaukLU70fWC1uLxrDpvFt8vN7Ba7dz1ldWD3WPBrK4vHzll32T32zP/B6tG3ZRWjx+dNcgGs
	UQ2MNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlAVygp
	lCXmlAKFAhKLi5X07TBNCA1x07WAaYzQ9Q0JgusxMkADCesYM6Yucip4wVRx9P0C1gbGeUxd
	jJwcEgImErfWf4GyxSQu3FvP1sXIxSEkMJ1R4vumXlYI5xejxIIv29lAqtgE1CS+fDnMDmKL
	ANlPeo+wgxQxC2xjlDixfB8zSEJIoFLi3pf5YA2cAk4Szx6fYASxhQVcJc486AdrZhFQlXh9
	5gkLiM0rYCvxZPszdghbUOLH5HtgcWYBLYn1O48zQdjyEpvXvAWazwF0qrrEo7+6EDcYSTRc
	/cEKUSIise/FO8YJjEKzkEyahWTSLCSTZiFpWcDIsopRNLUguaA4KT3XUK84Mbe4NC9dLzk/
	dxMjODE8k9rBuLLB4hCjAAejEg+vRXtakBBrYllxZe4hRgkOZiUR3mZfoBBvSmJlVWpRfnxR
	aU5q8SHGZKBHJzJLiSbnA5NWXkm8obGJmZGlkZmFkYm5OWnCSuK8B1qtA4UE0hNLUrNTUwtS
	i2C2MHFwSjUwtu355Nnu28fGLfr7v2RE/IqQaOnyiYl2zguqJi9SZZqpXTr36+PdMxZ0qT+b
	ePT9fPGVVzeVf5Vb++Hl02xOoxUXGa/X968OlLvVJfaH39Kx0/g16/uHd16emHvNWfn+v9mx
	yeoxtoFGP1vqfdf+2VF46MsmzfpC1SleFxfIWNV+lshQr25yUWIpzkg01GIuKk4EAF8XMu1Q	AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, October 23, 2013 2:27 AM, Johan Hovold wrote:
> 
> Add missing module alias which is needed for module autoloading.
> 
> Signed-off-by: Johan Hovold <jhovold@gmail.com>

Acked-by: Jingoo Han <jg1.han@samsung.com>

Best regards,
Jingoo Han

> ---
>  drivers/video/backlight/atmel-pwm-bl.c | 1 +
>  1 file changed, 1 insertion(+)


