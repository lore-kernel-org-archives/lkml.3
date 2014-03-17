Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932883AbaCQLdk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 07:33:40 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:13391 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932514AbaCQLdj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 07:33:39 -0400
X-AuditID: cbfee690-b7f266d00000287c-8e-5326dd8fe70c
To: undisclosed-recipients:;
Message-id: <5326DD8F.2080903@samsung.com>
Date: Mon, 17 Mar 2014 20:33:35 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
Cc: dbaryshkov@gmail.com, dwmw2@infradead.org, myungjoo.ham@samsung.com,
        kyungmin.park@samsung.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] charger-manager: Fix checking of wrong return type
References: <1395055910-13593-1-git-send-email-y@samsung.com>
In-reply-to: <1395055910-13593-1-git-send-email-y@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrLIsWRmVeSWpSXmKPExsWyRsSkSLf/rlqwwYKt+haTnrxntpi4cjKz
	xdmmN+wWl3fNYbO43biCzYHVY+esu+wem1doefRtWcXo8XmTXABLFJdNSmpOZllqkb5dAlfG
	33PPmQtWclW8nv6VvYFxJ0cXIyeHhICJRPuxdewQtpjEhXvr2boYuTiEBJYyStxe/pwRpujl
	sdXMEIlFjBKrHswGS4gIyEjMnf2YFSLxilFi/c1XLCAJXgEtiR8TFwPZHBwsAqoSza9kQcJs
	QOH9L26wgdiiAmESK6dfgSoXlPgx+R4LyBxmgSZGiYP98xlBeoUF3CVunLQDqRESsJVoPzeN
	HSTMKWAnsXyfDEiYWUBHYn/rNDYIW15i85q3YHdKCOxil1i1ezLYZywCAhLfJh8CO0dCQFZi
	0wFmiL8kJQ6uuMEygVFsFpIrZiEZOwvJ2AWMzKsYRVMLkguKk9KLTPSKE3OLS/PS9ZLzczcx
	AqPq9L9nE3Yw3jtgfYgxGWjlRGYp0eR8YFTmlcQbGpsZWZiamBobmVuakSasJM6r9igpSEgg
	PbEkNTs1tSC1KL6oNCe1+BAjEwenVAPjvO8Br/X9ZrY8nV2cvXm+wRSXMp/e0sPP/0cI1Hqm
	dP7awbYr8dOOxwU/e6onHLPf3Puskj/on/WnhCnHdZ+vWO8cnqzHdXyJ5lqdh7+YvDYvz3A/
	UOIlK12lfzTnUMrBLW9qNedrtQn8uLObX3Gnyo+cthf/LriJ35z/5kZMRqbD14I983U8lFiK
	MxINtZiLihMBLjfgSMACAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupileLIzCtJLcpLzFFi42I5/e+xgG7/XbVgg4PTNSwmPXnPbDFx5WRm
	i7NNb9gtLu+aw2Zxu3EFmwOrx85Zd9k9Nq/Q8ujbsorR4/MmuQCWqAZGm4zUxJTUIoXUvOT8
	lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zBygvUoKZYk5pUChgMTiYiV9O0wT
	QkPcdC1gGiN0fUOC4HqMDNBAwhrGjL/nnjMXrOSqeD39K3sD406OLkZODgkBE4mXx1YzQ9hi
	EhfurWfrYuTiEBJYxCix6sFsRpCEiICMxNzZj1khEq8YJdbffMUCkuAV0JL4MXExkM3BwSKg
	KtH8ShYkzAYU3v/iBhuILSoQJrFy+hWockGJH5PvsYDMYRZoYpQ42D+fEaRXWMBd4sZJO5Aa
	IQFbifZz09hBwpwCdhLL98mAhJkFdCT2t05jg7DlJTavecs8gVFgFpKps5CUzUJStoCReRWj
	aGpBckFxUnquoV5xYm5xaV66XnJ+7iZGcMw+k9rBuLLB4hCjAAejEg/vBGW1YCHWxLLiytxD
	jBIczEoivGnXgEK8KYmVValF+fFFpTmpxYcYk4F+nsgsJZqcD0wneSXxhsYmZkaWRuaGFkbG
	5qQJK4nzHmi1DhQSSE8sSc1OTS1ILYLZwsTBKdXAGFxf+UF9flaGyNVybecrCqflbIucsmZP
	OKFwrmPmiizPLVPynqVz3XS9bbgs1lXGV/XGhE+xF4SO3o+b3T+9Tr8oUDFFIbfOP+bOI8XK
	s5UPTrrU3RTzV3zy5Mjdvq0/dnd7nzh8n5/x8M2fmeFSi5Ke3p8g6HL+s/Ol6Uzfqo52Xz/O
	eSm8UYmlOCPRUIu5qDgRAAlvL/cdAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear all,

Ignore this patch due to wrong e-mail address.
I'll resend patch.

Thanks,
Chanwoo Choi

On 03/17/2014 08:31 PM, y@samsung.com wrote:
> From: Chanwoo Choi <cw00.choi@samsung.com>
> 
> This patch fix minor issue about checking wrong return type.
> 
> The of_cm_parse_desc() return ERR_PTR(errnor number) when some error happen
> in this function. But, charger_manager_probe() has only checked whether
> desc is NULL or not. If of_cm_parse_desc() returns ERR_PTR(-ENOMEM), desc
> isn't NULL but desc is (void *)(-ENOMEM). Althouhg some error happen for parsing
> DT, charger_manager_probe() can't detect error of desc instance.
> 
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>
> ---
>  drivers/power/charger-manager.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/power/charger-manager.c b/drivers/power/charger-manager.c
> index 9e4dab4..a10fb57 100644
> --- a/drivers/power/charger-manager.c
> +++ b/drivers/power/charger-manager.c
> @@ -1677,7 +1677,7 @@ static int charger_manager_probe(struct platform_device *pdev)
>  		}
>  	}
>  
> -	if (!desc) {
> +	if (IS_ERR(desc)) {
>  		dev_err(&pdev->dev, "No platform data (desc) found\n");
>  		return -ENODEV;
>  	}
> 

