Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751932Ab3KDAiD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Nov 2013 19:38:03 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:20475 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805Ab3KDAiA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Nov 2013 19:38:00 -0500
X-AuditID: cbfee68e-b7f416d0000020d6-65-5276ec673845
MIME-version: 1.0
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 8BIT
Message-id: <5276EC68.1040505@samsung.com>
Date: Mon, 04 Nov 2013 09:38:00 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: myungjoo.ham@samsung.com, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] extcon: arizona: Fix race with microphone detection
 and removal
References: <1382890752-30970-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
 <1382890752-30970-2-git-send-email-ckeepax@opensource.wolfsonmicro.com>
In-reply-to: <1382890752-30970-2-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLIsWRmVeSWpSXmKPExsWyRsSkUDf9TVmQwaGTkhb/ptxgt7i8aw6b
	xe3GFWwWy9/+Z3Ng8Xg58TebR9+WVYwenzfJBTBHcdmkpOZklqUW6dslcGVc7PjKWtDMW7Hz
	4XOmBsbzXF2MnBwSAiYSG98fZoKwxSQu3FvP1sXIxSEksJRR4vD0CUwwRffW97JAJKYzSny9
	vI0dJMErICjxY/I9oAQHB7OAnsT9i1ogYWYBEYmd33rZIWxtiWULXzND9L5ilGiacJMVoldL
	omf2fzCbRUBV4vjdi2A2G1B8/4sbbCC2qECYxMrpV1hAbBEBC4kpS24xQwxNlJhz7gvYAmGB
	KIltLw6zQyyYzyjR2Lsc7GpOoOYpL86CvSMhsIpdYk33A0aIbQIS3yYfArtaQkBWYtMBZogv
	JSUOrrjBMoFRfBaS32Yh/DYLyW+zkPy2gJFlFaNoakFyQXFSepGRXnFibnFpXrpecn7uJkZg
	1J3+96xvB+PNA9aHGJOBtk9klhJNzgdGbV5JvKGxmZGFqYmpsZG5pRlpwkrivIseJgUJCaQn
	lqRmp6YWpBbFF5XmpBYfYmTi4JRqYGz14Ah5/6I3NDXZ0v72l4RyJc6GYya7xZonKN4IcY8q
	ntOz4sNO2RreYuntwabi2w4yTOXakHfhbVSJ0jTbKVMSDjh8qM7QZ2Rd4PdrQsc6z7b1uS5O
	SVez7K5zvXDc0cPROffh9RsTnM8I75o1OfvZ2rPmNiu1dy9cntTQ/7FVs+68KetPdiWW4oxE
	Qy3mouJEAO8zMbnQAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgleLIzCtJLcpLzFFi42I5/e+xoG76m7Igg2c7hSz+TbnBbnF51xw2
	i9uNK9gslr/9z+bA4vFy4m82j74tqxg9Pm+SC2COamC0yUhNTEktUkjNS85PycxLt1XyDo53
	jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAFap6RQlphTChQKSCwuVtK3wzQhNMRN1wKmMULX
	NyQIrsfIAA0krGHMmDx1ElPBR56KZe+fMjcw7uXqYuTkkBAwkbi3vpcFwhaTuHBvPVsXIxeH
	kMB0Romvl7exgyR4BQQlfky+B1TEwcEsIC9x5FI2hKkncf+iFkT5K0aJpgk3WSHKtSR6Zv8H
	s1kEVCWO370IZrMBxfe/uMEGYosKhEmsnH4FbK+IgIXElCW3mEFsZoFEiTnnvoCtFRaIktj2
	4jA7xIL5jBKNvcuZQBKcQM1TXpxlm8AoMAvJebMQzpuFcN4CRuZVjKKpBckFxUnpuYZ6xYm5
	xaV56XrJ+bmbGMHx+UxqB+PKBotDjAIcjEo8vBKXy4KEWBPLiitzDzFKcDArifA6nwMK8aYk
	VlalFuXHF5XmpBYfYkwGem4is5Rocj4wdeSVxBsam5gZWRqZG1oYGZuTJqwkznug1TpQSCA9
	sSQ1OzW1ILUIZgsTB6dUA+PFHO+3Ub8nxS0qNWvfFKSSaqRXMoc39k7BieSlWx0tmYNm1rr6
	PjnyU3ddSq14qgvbygeTE1dob/rj5mcZK9Fx8OuBlJTeh6de7Pv2J2rLVKUF73dGRpZzrJku
	09N2dvfXlV9fHHxxeu8qoe0h3I+K8o+XNF0puaZXyPJGRp+rsDWn4o228hQlluKMREMt5qLi
	RADPlwrJEwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/28/2013 01:19 AM, Charles Keepax wrote:
> The microphone detection code is run as delayed work to provide
> additional debounce, it is possible that the jack could have been
> removed by the time we process the microphone detection. Turn this case
> into a no op.
> 
> Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
> ---
> 
> As Lee Jones took the first patch (extcon: arizona: Add
> defines for microphone detection levels) of my series
> yesterday through his tree I have based this patch on the
> extcon tree without that change applied.
> 
> Thanks,
> Charles
> 
>  drivers/extcon/extcon-arizona.c |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/extcon/extcon-arizona.c b/drivers/extcon/extcon-arizona.c
> index dac8ba0..9c20850 100644
> --- a/drivers/extcon/extcon-arizona.c
> +++ b/drivers/extcon/extcon-arizona.c
> @@ -773,6 +773,12 @@ static void arizona_micd_detect(struct work_struct *work)
>  
>  	mutex_lock(&info->lock);
>  
> +	if (!info->cable) {
> +		dev_dbg(arizona->dev, "Ignoring MICDET for removed cable\n");
> +		mutex_unlock(&info->lock);
> +		return;
> +	}
> +
>  	for (i = 0; i < 10 && !(val & 0x7fc); i++) {
>  		ret = regmap_read(arizona->regmap, ARIZONA_MIC_DETECT_3, &val);
>  		if (ret != 0) {
> 

This patch has build break as below log:

drivers/extcon/extcon-arizona.c: In function ‘arizona_micd_detect’:
drivers/extcon/extcon-arizona.c:776:11: error: ‘struct arizona_extcon_info’ has no member named ‘cable’

The arizona_extcon_info structure hasn't included 'cable' field.

Cheers,
Chanwoo Choi
