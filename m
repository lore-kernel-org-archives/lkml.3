Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753834AbaF3BEJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2014 21:04:09 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:60313 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753814AbaF3BEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2014 21:04:05 -0400
X-AuditID: cbfee68f-b7fef6d000003970-c8-53b0b783b86d
From: Jingoo Han <jg1.han@samsung.com>
To: "'Colin King'" <colin.king@canonical.com>,
        "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, "'Mark Brown'" <broonie@linaro.org>,
        linux-usb@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>
References: <1404078173-11921-1-git-send-email-colin.king@canonical.com>
In-reply-to: <1404078173-11921-1-git-send-email-colin.king@canonical.com>
Subject: Re: [PATCH] usb: usb3503: return correct error return on failure
Date: Mon, 30 Jun 2014 10:04:03 +0900
Message-id: <00a401cf93ff$2f0b7fa0$8d227ee0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac+T4xqXGzmCh3VnQL2poZinOGfQ6wAG6eLQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNIsWRmVeSWpSXmKPExsVy+t8zI93m7RuCDS5dl7PYdP06q8Xv1b1s
	Fs2L17NZXF54idXi8q45bBaLlrUyO7B5zGroZfO4c20Pm8f+uWvYPfq2rGL0+LxJLoA1issm
	JTUnsyy1SN8ugSvj0ObXTAVPOCqeTWtkb2BsZe9i5OCQEDCRWHGyuouRE8gUk7hwbz1bFyMX
	h5DAMkaJ3zc3sUMkTCReds5ihUgsYpQ41L6IBSQhJPCbUWJ3QwKIzSagJvHly2GwBhGBBIm3
	8w8zgjQwC7QwSqx5tZkJosFD4tC/pWwgmzkFPCWef04GCQsDmRtP9jKC2CwCqhJT758Fm8Mr
	YCvRse48M4QtKPFj8j2wvcwCWhLrdx5ngrDlJTavecsM8Yy6xKO/uhAnGEk8mXCTFaJERGLf
	i3dg50gIPGKX+LzlLCvELgGJb5MPsUD0ykpsOsAM8a+kxMEVN1gmMErMQrJ5FpLNs5BsnoVk
	xQJGllWMoqkFyQXFSelFxnrFibnFpXnpesn5uZsYIRHbv4Px7gHrQ4zJQOsnMkuJJucDIz6v
	JN7Q2MzIwtTE1NjI3NKMNGElcd77D5OChATSE0tSs1NTC1KL4otKc1KLDzEycXBKNTA2X3j3
	Q5L3nr+ccN6c7SWL3qzPOrRAwm2uyhFm9+JVq8r/nPPyEfpf2pRYxfBZItrNQaowW88zV1G/
	+tfPaXdVP15x+fG/Pkfg45IPH8wrntxsinvY2mh96kTyx7Ui26av0850/LB3HX8K45M9Jfaz
	L055kOgjtn2xc57Ry7BlK6urzqRFT1BSYinOSDTUYi4qTgQAfUbI0e4CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmleLIzCtJLcpLzFFi42I5/e+xgG7z9g3BBk9nS1tsun6d1eL36l42
	i+bF69ksLi+8xGpxedccNotFy1qZHdg8ZjX0snncubaHzWP/3DXsHn1bVjF6fN4kF8Aa1cBo
	k5GamJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQN0gpJCWWJO
	KVAoILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsI4x49Dm10wFTzgqnk1rZG9gbGXvYuTk
	kBAwkXjZOYsVwhaTuHBvPVsXIxeHkMAiRolD7YtYQBJCAr8ZJXY3JIDYbAJqEl++HAZrFhFI
	kHg7/zAjSAOzQAujxJpXm5kgGjwkDv1bCjSJg4NTwFPi+edkkLAwkLnxZC8jiM0ioCox9f5Z
	sDm8ArYSHevOM0PYghI/Jt8D28ssoCWxfudxJghbXmLzmrfMICMlBNQlHv3VhTjBSOLJhJus
	ECUiEvtevGOcwCg0C8mkWUgmzUIyaRaSlgWMLKsYRVMLkguKk9JzDfWKE3OLS/PS9ZLzczcx
	ghPCM6kdjCsbLA4xCnAwKvHwaizbECzEmlhWXJl7iFGCg1lJhFeoDijEm5JYWZValB9fVJqT
	WnyI0RTo0YnMUqLJ+cBklVcSb2hsYmZkaWRmYWRibq4kznug1TpQSCA9sSQ1OzW1ILUIpo+J
	g1OqgfF0/3VnITn50vq4f59KvllruJ85salm3pEnvY/FE4SZ197nnzn7af13o/2KqUqem/9G
	7ZK6t/L/BUGZu+dvxD4T6FJb2Lh3i+Lmv4Z+y7rz2lb/KGWeZ7avtk5/AmvDj5Ljuw3YzDV1
	nu87ICpxLLWDtZv/Y+b3B19PsfO9VeL3Wh+VvWeb2XclluKMREMt5qLiRABA1WZMHgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, June 30, 2014 6:43 AM, Colin King wrote:
> 
> From: Colin Ian King <colin.king@canonical.com>
> 
> Fix warning: drivers/usb/misc/usb3503.c:195:11: warning: 'err'
>   may be used uninitialized in this function [-Wmaybe-uninitialized]
> 
> err is not initialized, the error return should be PTR_ERR(clk)
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

It looks good!

Reviewed-by: Jingoo Han <jg1.han@samsung.com>

Best regards,
Jingoo Han

> ---
>  drivers/usb/misc/usb3503.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/usb/misc/usb3503.c b/drivers/usb/misc/usb3503.c
> index f43c619..c0c898d 100644
> --- a/drivers/usb/misc/usb3503.c
> +++ b/drivers/usb/misc/usb3503.c
> @@ -192,7 +192,8 @@ static int usb3503_probe(struct usb3503 *hub)
> 
>  		clk = devm_clk_get(dev, "refclk");
>  		if (IS_ERR(clk) && PTR_ERR(clk) != -ENOENT) {
> -			dev_err(dev, "unable to request refclk (%d)\n", err);
> +			dev_err(dev, "unable to request refclk (%ld)\n",
> +				PTR_ERR(clk));
>  			return PTR_ERR(clk);
>  		}
> 
> --
> 2.0.0

