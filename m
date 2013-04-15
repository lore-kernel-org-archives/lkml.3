Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754282Ab3DOBrV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Apr 2013 21:47:21 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:28704 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752753Ab3DOBrT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Apr 2013 21:47:19 -0400
X-AuditID: cbfee68f-b7f4a6d000001436-d9-516b5c25248f
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Bresticker'" <abrestic@chromium.org>,
        "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-fbdev@vger.kernel.org, "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Florian Tobias Schandinat'" <FlorianSchandinat@gmx.de>,
        linux-kernel@vger.kernel.org,
        "'Doug Anderson'" <dianders@chromium.org>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <1365705391-23181-1-git-send-email-abrestic@chromium.org>
 <1365711890-15168-1-git-send-email-abrestic@chromium.org>
In-reply-to: <1365711890-15168-1-git-send-email-abrestic@chromium.org>
Subject: Re: [PATCH v2] backlight: platform_lcd: introduce probe callback
Date: Mon, 15 Apr 2013 10:47:17 +0900
Message-id: <000001ce397b$292da160$7b88e420$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac428qna/S3mmMu1QWSE0qSS74FgdAChZ33g
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNIsWRmVeSWpSXmKPExsVy+t8zA121mOxAg2VNjBYr3/9ltJizfg2b
	xdllB9ksOmdeY7S4vPASq8WJvg+sFpd3zWGz2L3rKasDh8fshossHh8+xnmcmPGbxWPP/B+s
	Hn1bVjF6fN4kF8AWxWWTkpqTWZZapG+XwJWxtUWooJuv4uHKPUwNjOu4uxg5OSQETCRebL7A
	BGGLSVy4t56ti5GLQ0hgGaNEf/s3VpiilQs+skAkpjNKrJ12ihXC+cUo8XdpDzNIFZuAmsSX
	L4fZQWwRgTiJiW0djCBFzALvGCV+7rgJ1d7IKLG3ZylYFaeAm8TSz3/BbGEBT4n5bxeDHcIi
	oCqxcXkrG4jNK2ArMe98AyOELSjxY/I9FhCbWUBLYv3O40wQtrzE5jVvga7gALpVXeLRX10Q
	U0TASOLT6lqIChGJfS/egd0jIfCTXeLs3PnMEKsEJL5NPsQC0SorsekAM8THkhIHV9xgmcAo
	MQvJ4llIFs9CsngWkhULGFlWMYqmFiQXFCelFxnrFSfmFpfmpesl5+duYoREdP8OxrsHrA8x
	JgOtn8gsJZqcD0wIeSXxhsZmRhamJqbGRuaWZqQJK4nzqrVYBwoJpCeWpGanphakFsUXleak
	Fh9iZOLglGpgXCWRLu7XcSH5U15+4BzDMxXv3xo5uTx/sP+79tqVNevTT/Kv33Tvf3O4wcmr
	t37Ys+1PO3rxe7F6+xdR/9UWdi8v3vw4q8nqsYD01we2cvuelb6cfy/dSyIx9ljep9RI+dOz
	GXw8amfo1QqLOBwOsJMWUC+x/vnTzlrLetNMX8Zqnwirmic/lFiKMxINtZiLihMB8ZwJV/4C	AAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrBKsWRmVeSWpSXmKPExsVy+t9jQV3VmOxAg+WvLS1Wvv/LaDFn/Ro2
	i7PLDrJZdM68xmhxeeElVosTfR9YLS7vmsNmsXvXU1YHDo/ZDRdZPD58jPM4MeM3i8ee+T9Y
	Pfq2rGL0+LxJLoAtqoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VW
	ycUnQNctMwfoICWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYR1jxtYWoYJu
	voqHK/cwNTCu4+5i5OSQEDCRWLngIwuELSZx4d56ti5GLg4hgemMEmunnWKFcH4xSvxd2sMM
	UsUmoCbx5cthdhBbRCBOYmJbByNIEbPAO0aJnztuskB0NDJK7O1ZClbFKeAmsfTzXzBbWMBT
	Yv7bxUwgNouAqsTG5a1sIDavgK3EvPMNjBC2oMSPyffAbmIW0JJYv/M4E4QtL7F5zVugKziA
	blWXePRXF8QUETCS+LS6FqJCRGLfi3eMExiFZiEZNAvJoFlIBs1C0rKAkWUVo2hqQXJBcVJ6
	rqFecWJucWleul5yfu4mRnC6eCa1g3Flg8UhRgEORiUe3gna2YFCrIllxZW5hxglOJiVRHj/
	RwCFeFMSK6tSi/Lji0pzUosPMSYD/TmRWUo0OR+YyvJK4g2NTcyMLI3MLIxMzM1JE1YS5z3Q
	ah0oJJCeWJKanZpakFoEs4WJg1OqgVFWbGqds1FtpZaoxqtdR3f+UVVYffyg2t/MWdkJGcqO
	HgfqT2mV851ujdeTC45J/ahq03Xln/s5lbJ3ZSnbvtlMi+HSVl333KZ291Xh486ePDlluWIm
	7887rTFedOuJ98yEN1sV1Z3iy8Q15k5aojXHNSGob88Z73YuCdvV3+OclX+nJXqHKLEUZyQa
	ajEXFScCADYNXM1bAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, April 12, 2013 5:25 AM, Andrew Bresticker wrote:
> 
> Platform LCD devices may need to do some device-specific
> initialization before they can be used (regulator or GPIO setup,
> for example), but currently the driver does not support any way of
> doing this.  This patch adds a probe() callback to plat_lcd_data
> which platform LCD devices can set to indicate that device-specific
> initialization is needed.
> 
> Signed-off-by: Andrew Bresticker <abrestic@chromium.org>

CC'ed Andrew Morton,

It looks good.
Acked-by: Jingoo Han <jg1.han@samsung.com>

Best regards,
Jingoo Han


> ---
>  drivers/video/backlight/platform_lcd.c | 6 ++++++
>  include/video/platform_lcd.h           | 1 +
>  2 files changed, 7 insertions(+)
> 
> diff --git a/drivers/video/backlight/platform_lcd.c b/drivers/video/backlight/platform_lcd.c
> index 17a6b83..f46180e 100644
> --- a/drivers/video/backlight/platform_lcd.c
> +++ b/drivers/video/backlight/platform_lcd.c
> @@ -86,6 +86,12 @@ static int platform_lcd_probe(struct platform_device *pdev)
>  		return -EINVAL;
>  	}
> 
> +	if (pdata->probe) {
> +		err = pdata->probe(pdata);
> +		if (err)
> +			return err;
> +	}
> +
>  	plcd = devm_kzalloc(&pdev->dev, sizeof(struct platform_lcd),
>  			    GFP_KERNEL);
>  	if (!plcd) {
> diff --git a/include/video/platform_lcd.h b/include/video/platform_lcd.h
> index ad3bdfe..23864b2 100644
> --- a/include/video/platform_lcd.h
> +++ b/include/video/platform_lcd.h
> @@ -15,6 +15,7 @@ struct plat_lcd_data;
>  struct fb_info;
> 
>  struct plat_lcd_data {
> +	int	(*probe)(struct plat_lcd_data *);
>  	void	(*set_power)(struct plat_lcd_data *, unsigned int power);
>  	int	(*match_fb)(struct plat_lcd_data *, struct fb_info *);
>  };
> --
> 1.8.1.3
> 


