Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760190AbaGPHvb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 03:51:31 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:58177 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758364AbaGPHv2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 03:51:28 -0400
X-AuditID: cbfee68d-b7fd46d000005f36-e7-53c62efd4637
From: Jingoo Han <jg1.han@samsung.com>
To: "'Bean Huo'" <beanhuo@outlook.com>, dwmw2@infradead.org,
        computersforpeace@gmail.com
Cc: paul.gortmaker@windriver.com, artem.bityutskiy@linux.intel.com,
        b32955@freescale.com, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org, christian.riesch@omicron.at,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <BLU185-W10713E955F9530C4D53490A6F70@phx.gbl>
 <BLU185-W62B0858FCD7D3A71127B41A6F70@phx.gbl>
In-reply-to: <BLU185-W62B0858FCD7D3A71127B41A6F70@phx.gbl>
Subject: Re: [PATCH v5] mtd:nor:timeout:fix do_write_buffer() timeout error
Date: Wed, 16 Jul 2014 16:51:25 +0900
Message-id: <002201cfa0ca$be634b10$3b29e130$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac+gxklBediFhGgZQa+NyP75BM18+gABBysQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmplleLIzCtJLcpLzFFi42I5/e+Zge5fvWPBBk9Xm1u8efyM2eLCLBmL
	Bw8WMFtcb97IbnHkwlpmi4krJzNbXF54idXi8q45bBa7m5axW1zbe5zZgcvj3+F+Jo+ds+6y
	e2xeoeUx72Sgx+Yl9R6rJyxj89j8+gWzR9+WVYwenzfJeazfspUpgCuKyyYlNSezLLVI3y6B
	K2Pn3fmMBVtlKl7v3sjYwNgi3sXIySEhYCKxf8JyZghbTOLCvfVsXYxcHEICyxgl/l3axQxT
	NLF/PitEYjqjxNs3Z6Cc34wSX9+tYQOpYhNQk/jy5TA7iC0iECFx/MxCJpAiZoE7jBILtqxn
	BUkICWRKPFv+EqiIg4NTwEpiy6sEkLCwgLdEd88bFhCbRUBV4tzWVrCZvAK2EuembmKFsAUl
	fky+B1bDLKAj0fv9GzOErS3x5N0FVpCREgLqEo/+6oKYIgJGEtcmlkJUiEjse/GOEeQaCYGl
	HBKb2rYzQ6wSkPg2+RALRKusxKYDUP9KShxccYNlAqPELCSLZyFZPAvJ4llIVixgZFnFKJpa
	kFxQnJReZKhXnJhbXJqXrpecn7uJEZIEencw3j5gfYgxGWj9RGYp0eR8YBLJK4k3NDYzsjA1
	MTU2Mrc0I01YSZw36WFSkJBAemJJanZqakFqUXxRaU5q8SFGJg5OqQZGxS6tn2v+PSwIblTs
	K583O2exj9sizjV9jtbNXw0jAl7e2L3kVHHvec6HBQfT//Gcu6G5uz3s8avvptH3N3d484ff
	5pwrIhK0warM73ykZvPBcstIr8zLDBNCdsxQMM9Nump2gX//r8tbjVe8ybgvVF2VM+158Prw
	wo1PuoWmXojyYhZd43JciaU4I9FQi7moOBEAMnsJuxgDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCKsWRmVeSWpSXmKPExsVy+t9jQd2/eseCDZ4vMbJ48/gZs8WFWTIW
	Dx4sYLa43ryR3eLIhbXMFhNXTma2uLzwEqvF5V1z2Cx2Ny1jt7i29zizA5fHv8P9TB47Z91l
	99i8Qstj3slAj81L6j1WT1jG5rH59Qtmj74tqxg9Pm+S81i/ZStTAFdUA6NNRmpiSmqRQmpe
	cn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtCtSgpliTmlQKGAxOJiJX07
	TBNCQ9x0LWAaI3R9Q4LgeowM0EDCOsaMnXfnMxZslal4vXsjYwNji3gXIyeHhICJxMT++awQ
	tpjEhXvr2boYuTiEBKYzSrx9c4YVwvnNKPH13Ro2kCo2ATWJL18Os4PYIgIREsfPLGQCKWIW
	uMMosWDLerBRQgKZEs+WvwQq4uDgFLCS2PIqASQsLOAt0d3zhgXEZhFQlTi3tRVsJq+ArcS5
	qZtYIWxBiR+T74HVMAvoSPR+/8YMYWtLPHl3gRVkpISAusSjv7ogpoiAkcS1iaUQFSIS+168
	Y5zAKDQLyaBZSAbNQjJoFpKWBYwsqxhFUwuSC4qT0nMN9YoTc4tL89L1kvNzNzGCU8wzqR2M
	KxssDjEKcDAq8fBuCDkaLMSaWFZcmXuIUYKDWUmEV4TlWLAQb0piZVVqUX58UWlOavEhRlOg
	PycyS4km5wPTX15JvKGxiZmRpZGZhZGJubmSOO+BVutAIYH0xJLU7NTUgtQimD4mDk6pBsZI
	sVZXl5ZVbz6bzb8WN+tWyPKNXuf3ZSW5/1RQmvHMezaLFI9lReWJZ88E5TY/eL3U5Fp358lZ
	d6oWbFwxd067kqDvZieH2P/sZn13JXs/sJ3rFvS/YTd9hv3WJvXj9rGMm7LXB9dEBBhvme3H
	w/j8buFO5keuRzbcfZGcX21w08hxxrS1smFKLMUZiYZazEXFiQBsVkksRwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, July 16, 2014 4:19 PM, Bean Huo wrote:
> 
> For some Norflashes,the size of the buffer program has been
> increased from 256 bytes to 512 bytes,2ms maximum timeout can
> not adapt to all the different vendor's norflash.There maximum
> timeout information in the CFI area,so the best way is to choose
> the result calculated according to timeout field of struct cfi_ident
> that probed from norflash's CFI aera.This is also a standard defined
> by CFI.If haven't probed this information,or smaller than 2000us,then
> specify a defualt value 2000us.
> 
> Tested with Micron JS28F512M29EWx and Micron MT28EW512ABA flash devices.
> 
> Signed-off-by: bean huo <beanhuo@outlook.com>
> ---
> changes
> 	v1->v2:Deleted unused parameters in this patch
> 		(word_write_time_max and erase_time_max).Using usecs_to_jiffies
> 		instead of msecs_to_jiffies for convert timeout value into jiffies.
> 	v2->v3:Removed unnecessary messages form comments and deleted trailing whitespace.
> 	V3->v4:If haven't probed timeout information,or smaller than 2000us,specify default
> 	       2000us.
> 	v4->v5:add one whitespace
>  drivers/mtd/chips/cfi_cmdset_0002.c |   28 ++++++++++++++++++++++++++--
>  1 file changed, 26 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/mtd/chips/cfi_cmdset_0002.c b/drivers/mtd/chips/cfi_cmdset_0002.c
> index e21fde9..c248a8c 100644
> --- a/drivers/mtd/chips/cfi_cmdset_0002.c
> +++ b/drivers/mtd/chips/cfi_cmdset_0002.c
> @@ -628,6 +628,24 @@ struct mtd_info *cfi_cmdset_0002(struct map_info *map, int primary)
>  		cfi->chips[i].word_write_time = 1<<cfi->cfiq->WordWriteTimeoutTyp;
>  		cfi->chips[i].buffer_write_time = 1<<cfi->cfiq->BufWriteTimeoutTyp;
>  		cfi->chips[i].erase_time = 1<<cfi->cfiq->BlockEraseTimeoutTyp;
> +		/*
> +		 * First calculate the timeout max according to timeout
> +		 * field of struct cfi_ident that probed from chip's CFI
> +		 * aera.If haven't probed this information,or smaller than
> +		 * 2000us,we will specify defualt value 2000us,and the time
> +		 * unit is us.
> +		 */
> +		if (cfi->cfiq->BufWriteTimeoutTyp &&
> +			cfi->cfiq->BufWriteTimeoutMax){
> +			cfi->chips[i].buffer_write_time_max =
> +				1<<(cfi->cfiq->BufWriteTimeoutTyp +
> +					cfi->cfiq->BufWriteTimeoutMax);
> +			} else {
> +				cfi->chips[i].buffer_write_time_max = 0;
> +				}

Please keep the coding style as below.

		if ( ) {
			...
		} else {
			...
		}

Best regards,
Jingoo Han

> +		cfi->chips[i].buffer_write_time_max =
> +			((cfi->chips[i].buffer_write_time_max>= 2000)
> +			 ? cfi->chips[i].buffer_write_time_max : 2000);
>  		cfi->chips[i].ref_point_counter = 0;
>  		init_waitqueue_head(&(cfi->chips[i].wq));
>  	}
> @@ -1462,8 +1480,14 @@ static int __xipram do_write_buffer(struct map_info *map, struct flchip *chip,
>  {
>  	struct cfi_private *cfi = map->fldrv_priv;
>  	unsigned long timeo = jiffies + HZ;
> -	/* see comments in do_write_oneword() regarding uWriteTimeo. */
> -	unsigned long uWriteTimeout = ( HZ / 1000 ) + 1;
> +	/*
> +	 * Use the result that calculated according to timeout field
> +	 * of struct cfi_ident that probed from norflash's CFI aera.
> +	 * See more comments in cfi_cmdset_0002().uWriteTimeout is
> +	 * used for timeout step,it must be concerted into jiffies.
> +	 */
> +	unsigned long uWriteTimeout =
> +				usecs_to_jiffies(chip->buffer_write_time_max);
>  	int ret = -EIO;
>  	unsigned long cmd_adr;
>  	int z, words;
> --
> 1.7.9.5 		 	   		  =

