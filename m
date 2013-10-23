Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755379Ab3JWBuT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 21:50:19 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:61706 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754256Ab3JWBuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 21:50:16 -0400
X-AuditID: cbfee68d-b7fa16d0000029b0-2a-52672b5724eb
From: Jingoo Han <jg1.han@samsung.com>
To: "'Johan Hovold'" <jhovold@gmail.com>
Cc: "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Nicolas Ferre'" <nicolas.ferre@atmel.com>,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <1382462819-28576-1-git-send-email-jhovold@gmail.com>
 <1382462819-28576-5-git-send-email-jhovold@gmail.com>
In-reply-to: <1382462819-28576-5-git-send-email-jhovold@gmail.com>
Subject: Re: [PATCH 4/9] backlight: atmel-pwm-bl: clean up probe error handling
Date: Wed, 23 Oct 2013 10:50:14 +0900
Message-id: <001c01cecf92$37eb85c0$a7c29140$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7PS/T8Kp166tehRPC4J0DCD7MjYAARidGg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPIsWRmVeSWpSXmKPExsVy+t8zfd1w7fQggy9nxS1eHtK0uLzwEqvF
	3lXSFif6PrBaXN41h83i2+Vmdovdu56yOrB7LPi1lcVj56y77B575v9g9ejbsorR4/MmuQDW
	KC6blNSczLLUIn27BK6MxeczC1pZKh7samBsYFzB3MXIySEhYCJx5/wZNghbTOLCvfVgtpDA
	MkaJt98SYWq277kNFOcCik9nlGh6e5MJwvnFKDHl7w+wSWwCahJfvhxmB7FFgOwnvUfYQYqY
	BbYxSpxYvo8ZYmylxPuzZ8CKOAWcJJ6+u8AEYgsL+Esc3v2fFcRmEVCVOPjqIlg9r4CtxJnv
	fxkhbEGJH5PvsYDYzAJaEut3HmeCsOUlNq95C1TPAXSqusSjv7oQNxhJ3Hg8ixmiRERi34t3
	jCD3SAi8ZJeYv7YLapeAxLfJh1ggemUlNh2AhoqkxMEVN1gmMErMQrJ5FpLNs5BsnoVkxQJG
	llWMoqkFyQXFSelFhnrFibnFpXnpesn5uZsYIZHbu4Px9gHrQ4zJQOsnMkuJJucDIz+vJN7Q
	2MzIwtTE1NjI3NKMNGElcd6kh0lBQgLpiSWp2ampBalF8UWlOanFhxiZODilGhi1r3c6LvJ+
	d5JRfzebKYvH588+IpmPO9IEQm6ZTWtblS2QbRguukhyWpy0/rc9cRedHa5LTls0VWAd6967
	LepP/tolqat0zy1ccWXZ663nVp+d+GDz9Jcrp8ydqaTvrCrVlp+9YPYlqWdVL+/qqqXyiy6+
	e011hfeko4/+P9T52nWZd+I1ZVMVJZbijERDLeai4kQAUv6HXPICAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLKsWRmVeSWpSXmKPExsVy+t9jQd1w7fQgg3v/hCxeHtK0uLzwEqvF
	3lXSFif6PrBaXN41h83i2+Vmdovdu56yOrB7LPi1lcVj56y77B575v9g9ejbsorR4/MmuQDW
	qAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zBygK5QU
	yhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCBhHWMGYvPZxa0slQ82NXA2MC4grmL
	kZNDQsBEYvue22wQtpjEhXvrgWwuDiGB6YwSTW9vMkE4vxglpvz9AdbBJqAm8eXLYXYQWwTI
	ftJ7hB2kiFlgG6PEieX7wIqEBCol3p89A1bEKeAk8fTdBSYQW1jAX+Lw7v+sIDaLgKrEwVcX
	wep5BWwlznz/ywhhC0r8mHyPBcRmFtCSWL/zOBOELS+xec1boHoOoFPVJR791YW4wUjixuNZ
	zBAlIhL7XrxjnMAoNAvJpFlIJs1CMmkWkpYFjCyrGEVTC5ILipPSc430ihNzi0vz0vWS83M3
	MYITwzPpHYyrGiwOMQpwMCrx8Fq2pwUJsSaWFVfmHmKU4GBWEuFt9gUK8aYkVlalFuXHF5Xm
	pBYfYkwGenQis5Rocj4waeWVxBsam5gZWRqZWRiZmJuTJqwkznuw1TpQSCA9sSQ1OzW1ILUI
	ZgsTB6dUA+M0u12bn7MIpmWd4275cE+2xmRhj8lH9aBLsmvu3t4zdbPaHTPRS9Z1zy7Mrjve
	I3x36eSbNytP1yT0ae14srsptG7qN/eOqUebb2x0LrkWN3lDRuM8iZtV7cVcyt2GFrbray8p
	G0U9Efye93X9atPb943qE4Kk5R88Ud8g8EJYZGuGwxPJVelKLMUZiYZazEXFiQCtxmu8UAMA	AA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, October 23, 2013 2:27 AM, Johan Hovold wrote:
> 
> Clean up probe error handling by checking parameters before any
> allocations and removing an obsolete error label. Also remove
> unnecessary reset of private gpio number.
> 
> Signed-off-by: Johan Hovold <jhovold@gmail.com>

Acked-by: Jingoo Han <jg1.han@samsung.com>

Best regards,
Jingoo Han

> ---
>  drivers/video/backlight/atmel-pwm-bl.c | 31 ++++++++++++-------------------
>  1 file changed, 12 insertions(+), 19 deletions(-)

