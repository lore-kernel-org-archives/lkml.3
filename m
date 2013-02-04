Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753804Ab3BDBLn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 20:11:43 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:12102 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753600Ab3BDBLl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 20:11:41 -0500
X-AuditID: cbfee61b-b7fb06d000000f28-64-510f0ab9ea2f
Message-id: <510F0AB9.3090105@samsung.com>
Date: Mon, 04 Feb 2013 10:11:21 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, myungjoo.ham@samsung.com
Subject: Re: [PATCH 1/3] extcon: max8997: Make max8997_extcon_cable static
References: <1359452402-15885-1-git-send-email-sachin.kamat@linaro.org>
In-reply-to: <1359452402-15885-1-git-send-email-sachin.kamat@linaro.org>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJIsWRmVeSWpSXmKPExsVy+t8zLd2dXPyBBu//Sltc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MP2fusxX0s1VM+bKYrYHxB0sXIyeHhICJxPNLf5ghbDGJC/fW
	s3UxcnEICSxjlLi15j8zTNHWbUtYIRKLGCV2n7zPCOF0MkmcPdjPBFLFK6AlceljK1gHi4Cq
	ROfjNWAr2IDi+1/cYAOxRQXCJFZOv8ICUS8o8WPyPTBbBKjmZfdyoDkcHMwCVhIblxqDhIUF
	vCTuzOtmBLGFBNwlFnRdZAUp4RTwkDi/0AckzCxgLbFy0jZGCFteYvOat8wgp0kINLNLzLxy
	CeocAYlvkw+xgPRKCMhKbDoA9ZekxMEVN1gmMIrNQnLQLCRjZyEZu4CReRWjaGpBckFxUnqu
	kV5xYm5xaV66XnJ+7iZGSERI72Bc1WBxiFGAg1GJh5fhF1+gEGtiWXFl7iFGCQ5mJRHeq0ZA
	Id6UxMqq1KL8+KLSnNTiQ4zJQAdOZJYSTc4HRmteSbyhsYGxoaGloZmppakBacJK4ryMp54E
	CAmkJ5akZqemFqQWwWxh4uCUamBcUWPOldO+aOJzO22jzVlqsdExX6rClKoF0i6t8eQuPvdz
	TpqvLofBAd7tLO8SSzlPHH/a7LH9xpHKL8/+RGu//Rh8VHvlwptCfxO7tQ8m1a9eqLBx7lIB
	wTUKeSYCLFH7y/0DaoWPn897NLOaMWvOklO3SncHurZfMGD558+nuLXw1fzPL7cpsRRnJBpq
	MRcVJwIAGxC8b8wCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBIsWRmVeSWpSXmKPExsVy+t9jAd2dXPyBBt9villc3jWHzYHR4/Mm
	uQDGqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zByg
	qUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwjrGjD9n7rMV9LNVTPmymK2B
	8QdLFyMnh4SAicTWbUtYIWwxiQv31rN1MXJxCAksYpTYffI+I4TTySRx9mA/E0gVr4CWxKWP
	rcwgNouAqkTn4zVgk9iA4vtf3GADsUUFwiRWTr/CAlEvKPFj8j0wWwSo5mX3cqA5HBzMAlYS
	G5cag4SFBbwk7szrZgSxhQTcJRZ0XWQFKeEU8JA4v9AHJMwsYC2xctI2RghbXmLzmrfMExgF
	ZiFZMAtJ2SwkZQsYmVcxiqYWJBcUJ6XnGukVJ+YWl+al6yXn525iBMfbM+kdjKsaLA4xCnAw
	KvHwMvziCxRiTSwrrsw9xCjBwawkwnvVCCjEm5JYWZValB9fVJqTWnyIMRno/4nMUqLJ+cBU
	kFcSb2hsYmZkaWRmbGJubEyasJI4L+OpJwFCAumJJanZqakFqUUwW5g4OKUaGJvYNlwveRRW
	JqR6QFo9e5rk5xqurIjwbt62IOMLi2faWhi/bL3dUMe9ac3WkyEdM77HWbavXl988fKvO/7n
	bp6yX7kta3qeL1uusK/X6eRM396fLIcea3kyntWe8/TEVZHp6080v63z/2qgUvLd7F3ierlb
	X8S7fzvzPG8PYwlxcE2win6Yo8RSnJFoqMVcVJwIANVLSqP7AgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/29/2013 06:40 PM, Sachin Kamat wrote:
> 'max8997_extcon_cable' is used only in this file. Hence make it static.
>
> Signed-off-by: Sachin Kamat<sachin.kamat@linaro.org>
> ---
>   drivers/extcon/extcon-max8997.c |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/extcon/extcon-max8997.c b/drivers/extcon/extcon-max8997.c
> index df9358e..7039541 100644
> --- a/drivers/extcon/extcon-max8997.c
> +++ b/drivers/extcon/extcon-max8997.c
> @@ -109,7 +109,7 @@ struct max8997_muic_info {
>   	struct extcon_dev	*edev;
>   };
>   
> -const char *max8997_extcon_cable[] = {
> +static const char *max8997_extcon_cable[] = {
>   	[0] = "USB",
>   	[1] = "USB-Host",
>   	[2] = "TA",
Patches 1-3 applied.

Thanks,
Chanwoo Choi
