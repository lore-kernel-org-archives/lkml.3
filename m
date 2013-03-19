Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757938Ab3CSJfo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 05:35:44 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:55746 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754928Ab3CSJfm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 05:35:42 -0400
X-AuditID: cbfee68d-b7f786d000005188-60-5148316db4ae
Message-id: <5148316D.9040801@samsung.com>
Date: Tue, 19 Mar 2013 18:35:41 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, myungjoo.ham@samsung.com
Subject: Re: [PATCH 1/1] extcon: max77693: Staticize default_init_data
References: <1363666036-14006-1-git-send-email-sachin.kamat@linaro.org>
In-reply-to: <1363666036-14006-1-git-send-email-sachin.kamat@linaro.org>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupkkeLIzCtJLcpLzFFi42I5/e+Ztm6uoUegwcOpQhaXd81hc2D0+LxJ
	LoAxissmJTUnsyy1SN8ugStjU9tZ9oIPHBUNu16wNTCuZu9i5OCQEDCRuDYnsIuRE8gUk7hw
	bz0biC0ksIxR4vJkboi4icSp7XuByrmA4osYJT41HGOEcDqZJM5OmcYCUsUroCWx+v5PZhCb
	RUBVor3vLtgkNqD4/hc3wGxRgTCJldOvQNULSvyYfA/MFgGqedm9nAnkIGYBK4mNS41BTGEB
	N4k1rzgh7nGXeLd0E9gUTgEPiaktv5lAbGYBHYn9rdPYIGx5ic1r3jKDnCYh0Mwu8fP+PFaI
	cwQkvk0+xALxr6zEpgPMEH9JShxccYNlAqPYLCQHzUIydhaSsQsYmVcxiqYWJBcUJ6UXGeoV
	J+YWl+al6yXn525ihERD7w7G2wesDzEmA62cyCwlmpwPjKa8knhDYzMjC1MTU2Mjc0sz0oSV
	xHnVWqwDhQTSE0tSs1NTC1KL4otKc1KLDzEycXBKNTBWTH7xNf2Q6fa/d+I6CwqnRhn+mzWt
	vtTj5STWj9XXf1dcvGf7qeXlBEOZeJPI/5e1Vv4/8+l/yFKp+sUW1XGm/qfZV35wKH7f/H0r
	X9s1DdcuGZWdhf67Zyd96js8p2jVf8f8jiUnV2otO/Dc0EYguv4il8LGj1uuObK8ELKV2xO7
	y2NVo+RhJZbijERDLeai4kQA4F/HPpwCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBIsWRmVeSWpSXmKPExsVy+t9jAd1cQ49Ag1NLeS0u75rD5sDo8XmT
	XABjVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7Q
	VCWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYR1jxqa2s+wFHzgqGna9YGtg
	XM3excjJISFgInFq+14oW0ziwr31bF2MXBxCAosYJT41HGOEcDqZJM5OmcYCUsUroCWx+v5P
	ZhCbRUBVor3vLhuIzQYU3//iBpgtKhAmsXL6Fah6QYkfk++B2SJANS+7lzN1MXJwMAtYSWxc
	agxiCgu4Sax5xQlSISTgLvFu6SawKZwCHhJTW34zgdjMAjoS+1unsUHY8hKb17xlnsAoMAvJ
	gllIymYhKVvAyLyKUTS1ILmgOCk910ivODG3uDQvXS85P3cTIzjenknvYFzVYHGIUYCDUYmH
	VyHMPVCINbGsuDL3EKMEB7OSCO8qfY9AId6UxMqq1KL8+KLSnNTiQ4zJQP9PZJYSTc4HpoK8
	knhDYxMzI0sjM2MTc2Nj0oSVxHkPtloHCgmkJ5akZqemFqQWwWxh4uCUamDcMHXGA5MfPBI5
	DJ1pz05V77Wee21Rs3XE3JTOi9Ofzl9S4HjYa8o/9g8caiIndefFcTK1dvFqtl5P6767Ijl1
	hbjfpVJHQ43244336ifXp/t93mX/6uk3m+QTfv01sw41MPYGH7i+bf/qOR9i7yzz3yGqImSU
	f/mrOR9Tqd46s10Ch6uPz/+sxFKckWioxVxUnAgAId+9evsCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/19/2013 01:07 PM, Sachin Kamat wrote:
> Commit 0ec83bd246 ("extcon: max77693: Initialize register of MUIC
> device to bring up it without platform data") added this structure
> but forgot to make it static. Without this patch we get the following
> warning:
> drivers/extcon/extcon-max77693.c:41:26: warning:
> symbol 'default_init_data' was not declared. Should it be static?
>
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> ---
>  drivers/extcon/extcon-max77693.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/extcon/extcon-max77693.c b/drivers/extcon/extcon-max77693.c
> index 8f3c947..7b2e93d 100644
> --- a/drivers/extcon/extcon-max77693.c
> +++ b/drivers/extcon/extcon-max77693.c
> @@ -38,7 +38,7 @@
>   * extcon-max77693 driver use 'default_init_data' to bring up base operation
>   * of MAX77693 MUIC device.
>   */
> -struct max77693_reg_data default_init_data[] = {
> +static struct max77693_reg_data default_init_data[] = {
>  	{
>  		/* STATUS2 - [3]ChgDetRun */
>  		.addr = MAX77693_MUIC_REG_STATUS2,
Applied it. Thanks.

Chanwoo Choi
