Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752293Ab3GAABq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jun 2013 20:01:46 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:57441 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868Ab3GAABp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jun 2013 20:01:45 -0400
X-AuditID: cbfee690-b7f6f6d00000740c-b6-51d0c6e2d439
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Message-id: <51D0C6DF.1000805@samsung.com>
Date: Mon, 01 Jul 2013 09:01:35 +0900
From: jonghwa3.lee@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120411
 Thunderbird/11.0.1
To: Axel Lin <axel.lin@ingics.com>
Cc: Mark Brown <broonie@kernel.org>, Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: max77693: Remove NULL test for
 rmatch[i].init_data
References: <1372523632.5891.5.camel@phoenix>
In-reply-to: <1372523632.5891.5.camel@phoenix>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrIIsWRmVeSWpSXmKPExsWyRsSkSPfRsQuBBusfK1kcmfOV2WLqwyds
	Fp1nnzBbfLvSwWRxedccNovbjSvYHNg8ds66y+7R9rPMY9OqTjaPvi2rGD0+b5ILYI3isklJ
	zcksSy3St0vgyjj7tJup4DlXxYTvbcwNjM84uhg5OSQETCRet61ihLDFJC7cW8/WxcjFISSw
	lFHi9et9LDBFy1vnQyUWMUq0nNvMDJLgFRCU+DH5HlgRs4C6xKR5i5ghbBGJ50fWMEHY2hLL
	Fr4GiwsJvGSUuH47G6JXS+LKvqXsIDaLgKrEzeutbCA2m4CcxNumb2AXiQqESVydcBxsvoiA
	ksSq+5dZQI5gFtjNKNH94DHYAmGBEInu5musEAt0JT4e2g3WwCmgJ/FsxnNmkAYJgXPsEjNn
	vWeF2CYg8W3yIaAiDqCErMSmA8wQX0pKHFxxg2UCo/gsJL/NQvLbLCS/zULy2wJGllWMoqkF
	yQXFSelFJnrFibnFpXnpesn5uZsYgdF5+t+zCTsY7x2wPsSYDLR+IrOUaHI+MLrzSuINjc2M
	LExNTI2NzC3NSBNWEudVb7EOFBJITyxJzU5NLUgtii8qzUktPsTIxMEp1cAYyGfH9eNjUD3D
	NL6kd/7HHv84ofuq8d2OhSItpx6lvJmpfL9jsX7O/b+CvV+yfHes5jidf1jG0oyB85vRbrOp
	p3otL05+vm/WH8EXXE+Fqy7E5pz/Z3aNf1LGWkHZ/Ym8QWIstcY6/7xyktjFv93/fWPFDuFj
	K4KiF55QUuES7AjTjDi9PEdBiaU4I9FQi7moOBEAXz9E3eQCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprCKsWRmVeSWpSXmKPExsVy+t9jAd1Hxy4EGjy7IWVxZM5XZoupD5+w
	WXSefcJs8e1KB5PF5V1z2CxuN65gc2Dz2DnrLrtH288yj02rOtk8+rasYvT4vEkugDWqgdEm
	IzUxJbVIITUvOT8lMy/dVsk7ON453tTMwFDX0NLCXEkhLzE31VbJxSdA1y0zB+gCJYWyxJxS
	oFBAYnGxkr4dpgmhIW66FjCNEbq+IUFwPUYGaCBhDWPG01X3WAuOclUsaX3O3MB4hKOLkZND
	QsBEYnnrfDYIW0ziwr31QDYXh5DAIkaJlnObmUESvAKCEj8m32PpYuTgYBaQlzhyKRskzCyg
	LjFp3iKwEiGBl4wS129nQ5RrSVzZt5QdxGYRUJW4eb0VbD6bgJzE26ZvjCC2qECYxNUJx1lA
	bBEBJYlV9y+zgOxlFtjNKNH94DETSEJYIESiu/kaK8QCXYmPh3aDNXAK6Ek8m/GceQKjwCwk
	581COG8WkvMWMDKvYhRNLUguKE5KzzXSK07MLS7NS9dLzs/dxAiO42fSOxhXNVgcYhTgYFTi
	4V0w/UKgEGtiWXFl7iFGCQ5mJRHe7Z/PBwrxpiRWVqUW5ccXleakFh9iTAb6biKzlGhyPjDF
	5JXEGxqbmBlZGpkbWhgZm5MmrCTOe7DVOlBIID2xJDU7NbUgtQhmCxMHp1QDY85U6cmbtxyf
	mep/0N5K52hqtdwOBxuV5sxrXk0C73cZ3or63t40rXJP55TfhyWkvng8VwncJ6h58NiUQJnG
	jmVdc+fvVZ4ZsK/uxf3Eb5bRJ8/eOaK+Rveq89F7ZS/rmI3q3/ML7TP4t0kuvSyZPyDwR5uk
	xqps5mcHLn1ct9xkj7dr/mGXfUosxRmJhlrMRcWJAB2OghsnAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013년 06월 30일 01:33, Axel Lin wrote:

> The implementation in of_regulator_match() already ensures match->init_data is
> not NULL for all matched cases if the return value of of_regulator_match() > 0.
> 
> Thus remove NULL test for rmatch[i].init_data.
> 
> This patch also fixes the condition for loop iteration.
> The for loop should iterate "matched" times rather than ARRAY_SIZE(regulators)
> because we only allocate "matched" number of entries for rdata.
> Though in most cases, "matched" == ARRAY_SIZE(regulators).
> 
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> ---
>  drivers/regulator/max77693.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/drivers/regulator/max77693.c b/drivers/regulator/max77693.c
> index d45a4dd..ce4b96c 100644
> --- a/drivers/regulator/max77693.c
> +++ b/drivers/regulator/max77693.c
> @@ -190,9 +190,7 @@ static int max77693_pmic_dt_parse_rdata(struct device *dev,
>  
>  	tmp = *rdata;
>  
> -	for (i = 0; i < ARRAY_SIZE(regulators); i++) {
> -		if (!rmatch[i].init_data)
> -			continue;
> +	for (i = 0; i < matched; i++) {
>  		tmp->initdata = rmatch[i].init_data;
>  		tmp->of_node = rmatch[i].of_node;
>  		tmp->id = regulators[i].id;


Looks good to me,

Acked-by : Jonghwa Lee <jonghwa3.lee@samsung.com>


Thanks,
Jonghwa
