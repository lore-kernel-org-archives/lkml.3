Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753564Ab3KNMie (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 07:38:34 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:14550 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752901Ab3KNMia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 07:38:30 -0500
X-AuditID: cbfee68d-b7fa16d0000029b0-3d-5284c4452e95
Message-id: <5284C446.6060605@samsung.com>
Date: Thu, 14 Nov 2013 21:38:30 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: myungjoo.ham@samsung.com, sameo@linux.intel.com, lee.jones@linaro.org,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/7] extcon: arizona: Add defines for microphone detection
 levels
References: <1384365877-12355-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
In-reply-to: <1384365877-12355-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrOIsWRmVeSWpSXmKPExsWyRsSkQNf1SEuQwdKFXBb/ptxgt7j/9Sij
	xeVdc9gsbjeuYLNY/vY/m8XpblYHNo871/awecw7GejxcuJvNo++LasYPT5vkgtgjeKySUnN
	ySxLLdK3S+DKaJn9naXgtnLF7tPf2RsYf0t1MXJwSAiYSDw/4tbFyAlkiklcuLeerYuRi0NI
	YCmjxON9W1khEiYSnT39jCC2kMB0RolL9ywhil4xSmw4tRwswSugJXF1bys7iM0ioCoxZUsP
	mM0GFN//4gYbiC0qECaxcvoVFoh6QYkfk++B2SICFhJTltxiBhnKLNDHKPGoZSbYZmGBcIlb
	S5+yQWwOldh7+jYTiM0JNGh+O8QyZgEdif2t09ggbHmJzWvegg2SEDjELrFyymJGiIsEJL5N
	PsQC8bKsxKYDzBCfSUocXHGDZQKj2CwkN81CMnYWkrELGJlXMYqmFiQXFCelFxnqFSfmFpfm
	pesl5+duYgRG2ul/z3p3MN4+YH2IMRlo5URmKdHkfGCk5pXEGxqbGVmYmpgaG5lbmpEmrCTO
	m/QwKUhIID2xJDU7NbUgtSi+qDQntfgQIxMHp1QDY7i5X2/ohIRyB4mQZfaTuFUeNqyWTz3g
	/SMnvyaow+HlMvfe1K9cxptYZ+xU8Pu7+3v8UtfqDz8/9+dqW3rc3cH74/bh+vi4YqsTsrO/
	rGM6du2k1zbtNPFta1VMnf4Y53H3RbNkum1i0roQm7LO5rm54D727Gt28o03jdM2ve0q8/r6
	qXyLEktxRqKhFnNRcSIAfD2I7coCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprKKsWRmVeSWpSXmKPExsVy+t9jQV3XIy1BBr8mMVn8m3KD3eL+16OM
	Fpd3zWGzuN24gs1i+dv/bBanu1kd2DzuXNvD5jHvZKDHy4m/2Tz6tqxi9Pi8SS6ANaqB0SYj
	NTEltUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMH6AAlhbLEnFKg
	UEBicbGSvh2mCaEhbroWMI0Rur4hQXA9RgZoIGENY0bL7O8sBbeVK3af/s7ewPhbqouRk0NC
	wESis6efEcIWk7hwbz0biC0kMJ1R4tI9yy5GLiD7FaPEhlPLwYp4BbQkru5tZQexWQRUJaZs
	6QGz2YDi+1/cAGsWFQiTWDn9CgtEvaDEj8n3wGwRAQuJKUtuMYMMZRboY5R41DKTFSQhLBAu
	cWvpU6jNoRJ7T99mArE5gQbNb4dYxiygI7G/dRobhC0vsXnNW+YJjAKzkOyYhaRsFpKyBYzM
	qxhFUwuSC4qT0nON9IoTc4tL89L1kvNzNzGCI/mZ9A7GVQ0WhxgFOBiVeHgltjcHCbEmlhVX
	5h5ilOBgVhLhbV3bEiTEm5JYWZValB9fVJqTWnyIMRkYBBOZpUST84FJJq8k3tDYxMzI0sjc
	0MLI2Jw0YSVx3oOt1oFCAumJJanZqakFqUUwW5g4OKUaGAM0yrorT06csqD/lr1lpkyO23O5
	7SqcW9ImHFDs17wu65fjpbXi3E4/w2lfzy6Jl/nnPfdDx8PdyotjDjz8bnEt7bllSlSYtI/o
	mRWFD5gvC+lH9/3RC3+X4b8v5vf6Wb5c72rLV+2ea2H/ftk69kjhrOJf0VMsJqzqcPpq+X7F
	kxuZUc1P1iixFGckGmoxFxUnAgApD54oKAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Charles,

I tried to apply this patch[1-4]. But happen fail of 'git am'.
Did you develop this patchset based on extcon-next tree?

Also, you should add version information of patch subject as following:
- [PATCHv2 1/7] extcon: arizona: Add defines for microphone detection levels

Thanks,
Chanwoo Choi

On 11/14/2013 03:04 AM, Charles Keepax wrote:
> Improve readability by creating a define for each microphone detection
> level.
> 
> Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
> ---
>  drivers/extcon/extcon-arizona.c       |   19 ++++++++++++++-----
>  include/linux/mfd/arizona/registers.h |    9 +++++++++
>  2 files changed, 23 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/extcon/extcon-arizona.c b/drivers/extcon/extcon-arizona.c
> index 3c55ec8..8810da1 100644
> --- a/drivers/extcon/extcon-arizona.c
> +++ b/drivers/extcon/extcon-arizona.c
> @@ -44,6 +44,15 @@
>  #define HPDET_DEBOUNCE 500
>  #define DEFAULT_MICD_TIMEOUT 2000
>  
> +#define MICD_LVL_1_TO_7 (ARIZONA_MICD_LVL_1 | ARIZONA_MICD_LVL_2 | \
> +			 ARIZONA_MICD_LVL_3 | ARIZONA_MICD_LVL_4 | \
> +			 ARIZONA_MICD_LVL_5 | ARIZONA_MICD_LVL_6 | \
> +			 ARIZONA_MICD_LVL_7)
> +
> +#define MICD_LVL_0_TO_7 (ARIZONA_MICD_LVL_0 | MICD_LVL_1_TO_7)
> +
> +#define MICD_LVL_0_TO_8 (MICD_LVL_0_TO_7 | ARIZONA_MICD_LVL_8)
> +
>  struct arizona_extcon_info {
>  	struct device *dev;
>  	struct arizona *arizona;
> @@ -765,7 +774,7 @@ static void arizona_micd_detect(struct work_struct *work)
>  
>  	mutex_lock(&info->lock);
>  
> -	for (i = 0; i < 10 && !(val & 0x7fc); i++) {
> +	for (i = 0; i < 10 && !(val & MICD_LVL_0_TO_8); i++) {
>  		ret = regmap_read(arizona->regmap, ARIZONA_MIC_DETECT_3, &val);
>  		if (ret != 0) {
>  			dev_err(arizona->dev,
> @@ -784,7 +793,7 @@ static void arizona_micd_detect(struct work_struct *work)
>  		}
>  	}
>  
> -	if (i == 10 && !(val & 0x7fc)) {
> +	if (i == 10 && !(val & MICD_LVL_0_TO_8)) {
>  		dev_err(arizona->dev, "Failed to get valid MICDET value\n");
>  		mutex_unlock(&info->lock);
>  		return;
> @@ -798,7 +807,7 @@ static void arizona_micd_detect(struct work_struct *work)
>  	}
>  
>  	/* If we got a high impedence we should have a headset, report it. */
> -	if (info->detecting && (val & 0x400)) {
> +	if (info->detecting && (val & ARIZONA_MICD_LVL_8)) {
>  		arizona_identify_headphone(info);
>  
>  		ret = extcon_update_state(&info->edev,
> @@ -827,7 +836,7 @@ static void arizona_micd_detect(struct work_struct *work)
>  	 * plain headphones.  If both polarities report a low
>  	 * impedence then give up and report headphones.
>  	 */
> -	if (info->detecting && (val & 0x3f8)) {
> +	if (info->detecting && (val & MICD_LVL_1_TO_7)) {
>  		if (info->jack_flips >= info->micd_num_modes * 10) {
>  			dev_dbg(arizona->dev, "Detected HP/line\n");
>  			arizona_identify_headphone(info);
> @@ -851,7 +860,7 @@ static void arizona_micd_detect(struct work_struct *work)
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

