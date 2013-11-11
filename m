Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753019Ab3KKKAY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 05:00:24 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:27006 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730Ab3KKKAR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 05:00:17 -0500
X-AuditID: cbfee690-b7f3d6d000001c4a-63-5280aaaf5491
Message-id: <5280AAAF.8040005@samsung.com>
Date: Mon, 11 Nov 2013 19:00:15 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: myungjoo.ham@samsung.com, sameo@linux.intel.com, lee.jones@linaro.org,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] extcon: arizona: Add defines for microphone detection
 levels
References: <1383916783-17921-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
In-reply-to: <1383916783-17921-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrOIsWRmVeSWpSXmKPExsWyRsSkQHf9qoYggwuHtC3+TbnBbnH/61FG
	i8u75rBZ3G5cwWax/O1/NovT3awObB53ru1h85h3MtDj5cTfbB59W1YxenzeJBfAGsVlk5Ka
	k1mWWqRvl8CV0fN4O2PBBOWK/j9v2RoYd0l1MXJySAiYSPxovswGYYtJXLi3Hsjm4hASWMoo
	cf3Ua3a4otnroBLTGSX+fP4K5bxilOie/44VpIpXQEvibWcTWAeLgKrEywMLweJsQPH9L26A
	rRAVCJNYOf0KC0S9oMSPyffAbBEBC4kpS24xgwxlFuhjlHjUMhOsWVggXOLimV6wIiGBUIkL
	zUeBFnBwcAINav8JtotZQEdif+s0NghbXmLzmrfMEFcfYpdYdbkK4h4BiW+TD7GAtEoIyEps
	OgBVIilxcMUNlgmMYrOQXDQLydRZSKYuYGRexSiaWpBcUJyUXmSiV5yYW1yal66XnJ+7iREY
	aaf/PZuwg/HeAetDjMlAKycyS4km5wMjNa8k3tDYzMjC1MTU2Mjc0ow0YSVxXrVHSUFCAumJ
	JanZqakFqUXxRaU5qcWHGJk4OKUaGDm7974JZ3t/gKEqV1JzbzHf94+KXyMMzUK9lNXLRTq2
	hR9qu/rj4VuD7OhWRTWGWcdqYo20wnScz3PPn2e8Xz65wUj6Ylb7qYR+sdbjT4+K2ZzfnOQf
	4Pjxy8P5f97Um+5xPesuqOoy991aidcei/Mk1j3nY616PIv7qNqt94zefTNPmby7rcRSnJFo
	qMVcVJwIAEhc1o7KAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprKKsWRmVeSWpSXmKPExsVy+t9jQd31qxqCDHZ1ylv8m3KD3eL+16OM
	Fpd3zWGzuN24gs1i+dv/bBanu1kd2DzuXNvD5jHvZKDHy4m/2Tz6tqxi9Pi8SS6ANaqB0SYj
	NTEltUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMH6AAlhbLEnFKg
	UEBicbGSvh2mCaEhbroWMI0Rur4hQXA9RgZoIGENY0bP4+2MBROUK/r/vGVrYNwl1cXIySEh
	YCLxY/Y6NghbTOLCvfVANheHkMB0Rok/n79COa8YJbrnv2MFqeIV0JJ429nEDmKzCKhKvDyw
	ECzOBhTf/+IG2CRRgTCJldOvsEDUC0r8mHwPzBYRsJCYsuQWM8hQZoE+RolHLTPBmoUFwiUu
	nukFKxISCJW40HwUaAEHByfQoPafYLuYBXQk9rdOY4Ow5SU2r3nLPIFRYBaSFbOQlM1CUraA
	kXkVo2hqQXJBcVJ6rqFecWJucWleul5yfu4mRnAkP5PawbiyweIQowAHoxIPb4RCQ5AQa2JZ
	cWXuIUYJDmYlEd57S4BCvCmJlVWpRfnxRaU5qcWHGJOBITCRWUo0OR+YZPJK4g2NTcyMLI3M
	DS2MjM1JE1YS5z3Qah0oJJCeWJKanZpakFoEs4WJg1OqgTFyHecnqRctTG1LeD8dPGMm8nTf
	h/zQiKvbHrrunPZRW9WPY9uihd1qKet5zb+XXfRdZZV8KElYLODTyzkGmt+mWzu+VLUt0o3t
	u/XY91XH15SZX3nFn4QKLjny/+3i5jUnT/96pjThgZDY7c2O+05yNjxfe7wo4WxO7zfDeQ8M
	OGSz5k/LeFurxFKckWioxVxUnAgAdD8wAygDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Charles,

On 11/08/2013 10:19 PM, Charles Keepax wrote:
> Improve readability by creating a define for each microphone detection
> level.
> 
> Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
> ---
>  drivers/extcon/extcon-arizona.c       |   21 ++++++++++++++++-----
>  include/linux/mfd/arizona/registers.h |    9 +++++++++
>  2 files changed, 25 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/extcon/extcon-arizona.c b/drivers/extcon/extcon-arizona.c
> index 3c55ec8..6d914ba 100644
> --- a/drivers/extcon/extcon-arizona.c
> +++ b/drivers/extcon/extcon-arizona.c
> @@ -44,6 +44,17 @@
>  #define HPDET_DEBOUNCE 500
>  #define DEFAULT_MICD_TIMEOUT 2000
>  
> +enum {
> +	MICD_LVL_1_TO_7 = ARIZONA_MICD_LVL_1 | ARIZONA_MICD_LVL_2 |
> +			  ARIZONA_MICD_LVL_3 | ARIZONA_MICD_LVL_4 |
> +			  ARIZONA_MICD_LVL_5 | ARIZONA_MICD_LVL_6 |
> +			  ARIZONA_MICD_LVL_7,
> +
> +	MICD_LVL_0_TO_7 = ARIZONA_MICD_LVL_0 | MICD_LVL_1_TO_7,
> +
> +	MICD_LVL_0_TO_8 = MICD_LVL_0_TO_7 | ARIZONA_MICD_LVL_8,
> +};

MICD_LVL_1_TO_7 / MICD_LVL_0_TO_7 /MICD_LVL_0_TO_8 haven't the sequential value.
I prefer '#define' keyword to define MICD_LVL_1_TO_7 / MICD_LVL_0_TO_7 /MICD_LVL_0_TO_8
instead of enum keyword.

> +
>  struct arizona_extcon_info {
>  	struct device *dev;
>  	struct arizona *arizona;
> @@ -765,7 +776,7 @@ static void arizona_micd_detect(struct work_struct *work)
>  
>  	mutex_lock(&info->lock);
>  
> -	for (i = 0; i < 10 && !(val & 0x7fc); i++) {
> +	for (i = 0; i < 10 && !(val & MICD_LVL_0_TO_8); i++) {
>  		ret = regmap_read(arizona->regmap, ARIZONA_MIC_DETECT_3, &val);
>  		if (ret != 0) {
>  			dev_err(arizona->dev,
> @@ -784,7 +795,7 @@ static void arizona_micd_detect(struct work_struct *work)
>  		}
>  	}
>  
> -	if (i == 10 && !(val & 0x7fc)) {
> +	if (i == 10 && !(val & MICD_LVL_0_TO_8)) {
>  		dev_err(arizona->dev, "Failed to get valid MICDET value\n");
>  		mutex_unlock(&info->lock);
>  		return;
> @@ -798,7 +809,7 @@ static void arizona_micd_detect(struct work_struct *work)
>  	}
>  
>  	/* If we got a high impedence we should have a headset, report it. */
> -	if (info->detecting && (val & 0x400)) {
> +	if (info->detecting && (val & ARIZONA_MICD_LVL_8)) {
>  		arizona_identify_headphone(info);
>  
>  		ret = extcon_update_state(&info->edev,
> @@ -827,7 +838,7 @@ static void arizona_micd_detect(struct work_struct *work)
>  	 * plain headphones.  If both polarities report a low
>  	 * impedence then give up and report headphones.
>  	 */
> -	if (info->detecting && (val & 0x3f8)) {
> +	if (info->detecting && (val & MICD_LVL_1_TO_7)) {
>  		if (info->jack_flips >= info->micd_num_modes * 10) {
>  			dev_dbg(arizona->dev, "Detected HP/line\n");
>  			arizona_identify_headphone(info);
> @@ -851,7 +862,7 @@ static void arizona_micd_detect(struct work_struct *work)
>  	 * If we're still detecting and we detect a short then we've
>  	 * got a headphone.  Otherwise it's a button press.
>  	 */
> -	if (val & 0x3fc) {
> +	if (val & MICD_LVL_0_TO_7) {
>  		if (info->mic) {
>  			dev_dbg(arizona->dev, "Mic button detected\n");
>  
> diff --git a/include/linux/mfd/arizona/registers.h b/include/linux/mfd/arizona/registers.h
> index 4706d3d..10d9e70 100644
> --- a/include/linux/mfd/arizona/registers.h
> +++ b/include/linux/mfd/arizona/registers.h
> @@ -2196,6 +2196,15 @@
>  /*
>   * R677 (0x2A5) - Mic Detect 3
>   */
> +#define ARIZONA_MICD_LVL_0                       0x0004  /* MICD_LVL - [2] */
> +#define ARIZONA_MICD_LVL_1                       0x0008  /* MICD_LVL - [3] */
> +#define ARIZONA_MICD_LVL_2                       0x0010  /* MICD_LVL - [4] */
> +#define ARIZONA_MICD_LVL_3                       0x0020  /* MICD_LVL - [5] */
> +#define ARIZONA_MICD_LVL_4                       0x0040  /* MICD_LVL - [6] */
> +#define ARIZONA_MICD_LVL_5                       0x0080  /* MICD_LVL - [7] */
> +#define ARIZONA_MICD_LVL_6                       0x0100  /* MICD_LVL - [8] */
> +#define ARIZONA_MICD_LVL_7                       0x0200  /* MICD_LVL - [9] */
> +#define ARIZONA_MICD_LVL_8                       0x0400  /* MICD_LVL - [10] */

>  #define ARIZONA_MICD_LVL_MASK                    0x07FC  /* MICD_LVL - [10:2] */
>  #define ARIZONA_MICD_LVL_SHIFT                        2  /* MICD_LVL - [10:2] */
>  #define ARIZONA_MICD_LVL_WIDTH                        9  /* MICD_LVL - [10:2] */
> 

Thanks,
Chanwoo Choi

