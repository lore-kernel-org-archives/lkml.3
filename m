Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753020AbaIVHBn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 03:01:43 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:21968 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167AbaIVHBm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 03:01:42 -0400
X-AuditID: cbfee691-f79b86d000004a5a-87-541fc954193e
Message-id: <541FC954.2080606@samsung.com>
Date: Mon, 22 Sep 2014 16:01:40 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Jean Delvare <jdelvare@suse.de>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] extcon: sm5502: Drop useless include
References: <1410902175.3951.28.camel@chaos.site>
In-reply-to: <1410902175.3951.28.camel@chaos.site>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpkkeLIzCtJLcpLzFFi42JZI2JSpBtyUj7E4PEMHYuldz+xWVzeNYfN
	4nbjCjYHZo++LasYPTafrvb4vEkugDmKyyYlNSezLLVI3y6BK2P7t/lsBYdYKxo/1TYw7mLp
	YuTkkBAwkVh5vAHKFpO4cG89WxcjF4eQwFJGiW+vpzHCFB373sUMYgsJTGeUODRbB6LoNaPE
	892Pwbp5BbQk5r6bxg5iswioStw9cgIszgYU3//iBhuILSoQJrFy+hWoekGJH5PvgdkiAsoS
	z/8fYwWxmQWiJN4fu8UEYgsLWEr8Pj0PqIYDaJmhxNLDQSBhTgEjiaNfutghytUlJs1bxAxh
	y0tsXvOWGeLm6ewSnxvNIc4RkPg2+RDYGAkBWYlNB6BKJCUOrrjBMoFRbBaSg2YhmToLydQF
	jMyrGEVTC5ILipPSi0z1ihNzi0vz0vWS83M3MQJj5vS/ZxN3MN4/YH2IUYCDUYmH90eLfIgQ
	a2JZcWXuIUZToCsmMkuJJucDIzOvJN7Q2MzIwtTE1NjI3NJMSZxXR/pnsJBAemJJanZqakFq
	UXxRaU5q8SFGJg5OqQZG3i/hEpu4d8/gXdx65tqNQ1bruvJu3ZQN5vz3YPNDJ1Yv2ZM3zN98
	O6UulTftd0PtxZxOy2+/I79e/buDpV1HRs5ymfd0nXnCclyrO6/MCNj398dKxiktEe4ufX8n
	fvv1q6Vjx9a5Vt1vlXOYJ+p81KhuPtOsMzvu4xx7VpOoz9eutiguTX1SrcRSnJFoqMVcVJwI
	AP//+1eUAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDIsWRmVeSWpSXmKPExsVy+t9jQd2Qk/IhBosvqVosvfuJzeLyrjls
	FrcbV7A5MHv0bVnF6LH5dLXH501yAcxRDYw2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6
	hpYW5koKeYm5qbZKLj4Bum6ZOUCLlBTKEnNKgUIBicXFSvp2mCaEhrjpWsA0Ruj6hgTB9RgZ
	oIGENYwZ27/NZys4xFrR+Km2gXEXSxcjJ4eEgInEse9dzBC2mMSFe+vZQGwhgemMEodm63Qx
	cgHZrxklnu9+DNbAK6AlMffdNHYQm0VAVeLukRNgcTag+P4XN8CaRQXCJFZOvwJVLyjxY/I9
	MFtEQFni+f9jrCA2s0CUxPtjt5hAbGEBS4nfp+cB1XAALTOUWHo4CCTMKWAkcfRLFztEubrE
	pHmLmCFseYnNa94yT2AUmIVkwywkZbOQlC1gZF7FKJpakFxQnJSea6RXnJhbXJqXrpecn7uJ
	ERyTz6R3MK5qsDjEKMDBqMTD+6NFPkSINbGsuDL3EKMEB7OSCO/RHKAQb0piZVVqUX58UWlO
	avEhRlNgAExklhJNzgemi7ySeENjEzMjSyNzQwsjY3Mlcd6DrdaBQgLpiSWp2ampBalFMH1M
	HJxSDYwi2Wn5K2pWLJI7a5+y5W9g8sUb/la1CzZqs+l/FFI/YtL37MBWV45F+1h+nd7sGvyh
	8twnhnMbIjcfm19rfNGp9P4Bi+21J2wYPvA3apzl/uO/yaJ0w4KX1rknr8ZF9PAzyGySyv9s
	Hnoxa+KUZCX73WH7WFXyXLJeyr+IklQ7kzN9F7thILcSS3FGoqEWc1FxIgAcTm7o3wIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/17/2014 06:16 AM, Jean Delvare wrote:
> Don't include <linux/input.h> when the driver does not use anything
> from this header file.
> 
> Signed-off-by: Jean Delvare <jdelvare@suse.de>
> Cc: Chanwoo Choi <cw00.choi@samsung.com>
> Cc: MyungJoo Ham <myungjoo.ham@samsung.com>

Applied.

Thanks,
Chanwoo Choi

> ---
>  drivers/extcon/extcon-sm5502.c |    1 -
>  1 file changed, 1 deletion(-)
> 
> --- a/drivers/extcon/extcon-sm5502.c
> +++ b/drivers/extcon/extcon-sm5502.c
> @@ -17,7 +17,6 @@
>  
>  #include <linux/err.h>
>  #include <linux/i2c.h>
> -#include <linux/input.h>
>  #include <linux/interrupt.h>
>  #include <linux/irqdomain.h>
>  #include <linux/kernel.h>
> 

