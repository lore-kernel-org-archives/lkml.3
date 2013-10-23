Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755537Ab3JWBx1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 21:53:27 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:48161 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753859Ab3JWBx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 21:53:26 -0400
X-AuditID: cbfee691-b7f866d000001b8c-f5-52672c14c18d
From: Jingoo Han <jg1.han@samsung.com>
To: "'Johan Hovold'" <jhovold@gmail.com>
Cc: "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Nicolas Ferre'" <nicolas.ferre@atmel.com>,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <1382462819-28576-1-git-send-email-jhovold@gmail.com>
 <1382462819-28576-9-git-send-email-jhovold@gmail.com>
In-reply-to: <1382462819-28576-9-git-send-email-jhovold@gmail.com>
Subject: Re: [PATCH 8/9] backlight: atmel-pwm-bl: refactor gpio_on handling
Date: Wed, 23 Oct 2013 10:53:24 +0900
Message-id: <002001cecf92$a8c7e310$fa57a930$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7PS/de5XCwxdiXTP6IXzlZD8fkbQARp5cQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPIsWRmVeSWpSXmKPExsVy+t8zfV0RnfQgg9ZXhhYvD2laXF54idVi
	7yppixN9H1gtLu+aw2bx7XIzu8XuXU9ZHdg9FvzayuKxc9Zddo8983+wevRtWcXo8XmTXABr
	FJdNSmpOZllqkb5dAlfGoy2LWAuamCuOzVrP2sC4i6mLkZNDQsBE4nPDcjYIW0ziwr31YLaQ
	wDJGibUT6mFqbtyawNzFyAUUn84o8fH9UWaIol+MEleeu4LYbAJqEl++HGYHsUWA7Ce9R9hB
	GpgFtjFKnFi+D6qhUqJp9wWwDZwCThL/Lu4Ds4UFvCUezvjGCGKzCKhKNM+cARbnFbCV6Gp4
	zgRhC0r8mHyPBcRmFtCSWL/zOBOELS+xec1boPkcQJeqSzz6qwtxg5FE2/dbzBAlIhL7Xrxj
	BLlHQuAlu8TER71QuwQkvk0+xALRKyux6QAzxMOSEgdX3GCZwCgxC8nmWUg2z0KyeRaSFQsY
	WVYxiqYWJBcUJ6UXmeoVJ+YWl+al6yXn525ihETuxB2M9w9YH2JMBlo/kVlKNDkfGPl5JfGG
	xmZGFqYmpsZG5pZmpAkrifOmP0oKEhJITyxJzU5NLUgtii8qzUktPsTIxMEp1cDI2vhhm0jp
	mYLLqsqfqoP/MDLd9LMv535qxVrwWG1m7VqNjU77Pl6oWaa2+k2JDZvPWs+y+6+3Pz9w0NTr
	X7Ge0P2AGdW3VGvWr3X/239m4ofgqykbYhYvv8E1b87Nn1rrbor3OHP3TS1hN7RZdLM7dO6y
	1g3Pvx6v/j7xWwf/p+AtdZlJXlvnKLEUZyQaajEXFScCAEJBPWPyAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLKsWRmVeSWpSXmKPExsVy+t9jQV0RnfQgg90fdC1eHtK0uLzwEqvF
	3lXSFif6PrBaXN41h83i2+Vmdovdu56yOrB7LPi1lcVj56y77B575v9g9ejbsorR4/MmuQDW
	qAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zBygK5QU
	yhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCBhHWMGY+2LGItaGKuODZrPWsD4y6m
	LkZODgkBE4kbtyYwQ9hiEhfurWfrYuTiEBKYzijx8f1RsISQwC9GiSvPXUFsNgE1iS9fDrOD
	2CJA9pPeI+wgDcwC2xglTizfB9VQKdG0+wIbiM0p4CTx7+I+MFtYwFvi4YxvjCA2i4CqRPPM
	GWBxXgFbia6G50wQtqDEj8n3WEBsZgEtifU7jzNB2PISm9e8BZrPAXSpusSjv7oQNxhJtH2/
	xQxRIiKx78U7xgmMQrOQTJqFZNIsJJNmIWlZwMiyilE0tSC5oDgpPddQrzgxt7g0L10vOT93
	EyM4MTyT2sG4ssHiEKMAB6MSD69Fe1qQEGtiWXFl7iFGCQ5mJRHeZl+gEG9KYmVValF+fFFp
	TmrxIcZkoEcnMkuJJucDk1ZeSbyhsYmZkaWRmYWRibk5acJK4rwHWq0DhQTSE0tSs1NTC1KL
	YLYwcXBKNTBue917wWH6v2zD2vuLLtgrRhXs1PX7fPGD2EWXvreJWg9NzZ26b0Xp2PjOYJ8Y
	m+S/zfxm6CqdJTqRHjkd9+0OeJ56xTzXx9JS3ee3ND9rnfUcPe9ZJpeZd63ftnTRicBqh0NX
	Wgoy86Z+0Y14JDAtybctqbnFWSu3hkXu+7Ub6RfaQiPXJSqxFGckGmoxFxUnAgDELEZtUAMA	AA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, October 23, 2013 2:27 AM, Johan Hovold wrote:
> 
> Add helper function to control the gpio_on signal.
> 
> Signed-off-by: Johan Hovold <jhovold@gmail.com>

Acked-by: Jingoo Han <jg1.han@samsung.com>

Best regards,
Jingoo Han

> ---
>  drivers/video/backlight/atmel-pwm-bl.c | 23 +++++++++++------------
>  1 file changed, 11 insertions(+), 12 deletions(-)

