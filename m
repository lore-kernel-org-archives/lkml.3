Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753263AbaE0Sgh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 14:36:37 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:54866 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752075AbaE0Sgf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 14:36:35 -0400
From: Bing Zhao <bzhao@marvell.com>
To: =?utf-8?B?TWFudWVsIFNjaMO2bGxpbmc=?= <manuel.schoelling@gmx.de>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Date: Tue, 27 May 2014 11:36:26 -0700
Subject: RE: [PATCH] mwifiex: use time_after()
Thread-Topic: [PATCH] mwifiex: use time_after()
Thread-Index: Ac94QyKBVsar/mpDSL+p8HbweVBY+ABlyuPw
Message-ID: <477F20668A386D41ADCC57781B1F70430F70F5E285@SC-VEXCH1.marvell.com>
References: <1401040776-13711-1-git-send-email-manuel.schoelling@gmx.de>
In-Reply-To: <1401040776-13711-1-git-send-email-manuel.schoelling@gmx.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.96,1.0.14,0.0.0000
 definitions=2014-05-27_05:2014-05-26,2014-05-27,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1402240000 definitions=main-1405270253
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s4RIaeIQ025041

Hi Manuel,

Thanks for the patch.

> To be future-proof and for better readability the time comparisons are
> modified to use time_after() instead of plain, error-prone math.
> 
> Signed-off-by: Manuel SchÃ¶lling <manuel.schoelling@gmx.de>

Acked-by: Bing Zhao <bzhao@marvell.com>

Regards,
Bing

> ---
>  drivers/net/wireless/mwifiex/main.h |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
> index d53e1e8..3191066 100644
> --- a/drivers/net/wireless/mwifiex/main.h
> +++ b/drivers/net/wireless/mwifiex/main.h
> @@ -1101,7 +1101,7 @@ mwifiex_11h_get_csa_closed_channel(struct mwifiex_private *priv)
>  		return 0;
> 
>  	/* Clear csa channel, if DFS channel move time has passed */
> -	if (jiffies > priv->csa_expire_time) {
> +	if (time_after(jiffies, priv->csa_expire_time)) {
>  		priv->csa_chan = 0;
>  		priv->csa_expire_time = 0;
>  	}
> --
> 1.7.10.4

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
