Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757550AbaGNWsm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 18:48:42 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:37987 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756976AbaGNWsc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 18:48:32 -0400
MIME-version: 1.0
Content-type: text/plain; charset=windows-1252
X-AuditID: cbfee68f-b7fef6d000003970-5a-53c45e3ed0d6
Content-transfer-encoding: 8BIT
Message-id: <53C45E3D.90600@samsung.com>
Date: Tue, 15 Jul 2014 07:48:29 +0900
From: Jaehoon Chung <jh80.chung@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101
 Thunderbird/24.6.0
To: =?windows-1252?Q?Luk=E1=9A_Czerner?= <lczerner@redhat.com>,
        linux-mmc@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        chris@printf.net, Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [PATCH] mmc: Do not advertise secure discard if it is blacklisted
References: <1403090287-10673-1-git-send-email-lczerner@redhat.com>
 <alpine.LFD.2.00.1407141008180.13527@localhost.localdomain>
In-reply-to: <alpine.LFD.2.00.1407141008180.13527@localhost.localdomain>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHIsWRmVeSWpSXmKPExsWyRsSkSNcu7kiwwbTjXBYTLm9ntFj2YDOL
	xZ69J1ksLu+aw2Zx5H8/o8XxteEObB53ru1h87jxaiGTx/t9V9k8Pm+SC2CJ4rJJSc3JLEst
	0rdL4Mo4f+QYa8EZyYof0zQaGF+JdDFyckgImEicO/KPGcIWk7hwbz1bFyMXh5DAUkaJ6xu2
	McEU/Z9yhwUiMZ1RYubpfywgCV4BQYkfk+8B2RwczALyEkcuZUOYehL3L2pBlL9mlJj1ro8R
	olxD4s7jd+wgNSwCqhJL7keBhNkEdCS2fzsOtkpUIEziUNs8MFtEIFri1J2ZrCA2s0ClRNPk
	ZrBWYQE/ifevrCHGNzJK/N92A6yGU8BD4s6z2UwgCQmBXewSjyedZgNJsAgISHybfAjsTAkB
	WYlNB6D+lZQ4uOIGywRGsVlInpmF8MwshGcWMDKvYhRNLUguKE5KLzLWK07MLS7NS9dLzs/d
	xAiMq9P/nvXvYLx7wPoQYzLQwonMUqLJ+cC4zCuJNzQ2M7IwNTE1NjK3NCNNWEmc9/7DpCAh
	gfTEktTs1NSC1KL4otKc1OJDjEwcnFINjHk5l3rWN588F33dZtfz1c9iL5a9kombd3zd7HUi
	uYtnBpVrP3+lyHXeMETT/t3B4L09i+f9WCxR8HOJTLKx+GydjS+3NRx8u3ZFcbj8R3PjqnMV
	ZaWrgx7FlZWbCntu1l8gXPxcbY7IhZVlFtl3Z1+dafy5OK5yfvOL2c3rig5xB5xmz/yk91CJ
	pTgj0VCLuag4EQB+5lKEwQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLIsWRmVeSWpSXmKPExsVy+t9jQV27uCPBBssmM1lMuLyd0WLZg80s
	Fnv2nmSxuLxrDpvFkf/9jBbH14Y7sHncubaHzePGq4VMHu/3XWXz+LxJLoAlqoHRJiM1MSW1
	SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwdouZJCWWJOKVAoILG4
	WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsIYx4/yRY6wFZyQrfkzTaGB8JdLFyMkhIWAi8X/K
	HRYIW0ziwr31bF2MXBxCAtMZJWae/geW4BUQlPgx+R6QzcHBLCAvceRSNoSpJ3H/ohZE+WtG
	iVnv+hghyjUk7jx+xw5SwyKgKrHkfhRImE1AR2L7t+NMILaoQJjEobZ5YLaIQLTEqTszWUFs
	ZoFKiabJzWCtwgJ+Eu9fWUOMb2SU+L/tBlgNp4CHxJ1ns5kmMArMQnLcLITjZiEct4CReRWj
	aGpBckFxUnqukV5xYm5xaV66XnJ+7iZGcNQ+k97BuKrB4hCjAAejEg+vxLvDwUKsiWXFlbmH
	GCU4mJVEeO8ZHgkW4k1JrKxKLcqPLyrNSS0+xGgK9NpEZinR5HxgQskriTc0NjEzsjQyN7Qw
	MjZXEuc92GodKCSQnliSmp2aWpBaBNPHxMEp1cAotU199aIZCjWno140TnKsUeWXNOv7+GJ2
	6LLNDPofxe6rOv6umvzcz1XonMucN8UWXqFGnpcnyHDqz5yfYJZ02EnCV/v0AwdHTsYeF+Xb
	wRZ8FVG2K+6FXL56Qjpm+dpdmztnXyz1YfolMWWqdvFZ/U8yd69OkCvru2OtcjohQ9Xcbgdz
	6xUlluKMREMt5qLiRADZGmNK8AIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Lukas.

I think it's reasonable. And CC'd Ulf.

Acked-by: Jaehoon Chung <jh80.chung@samsung.com>

Best Regards,
Jaehoon Chung

On 07/14/2014 05:10 PM, Lukáš Czerner wrote:
> On Wed, 18 Jun 2014, Lukas Czerner wrote:
> 
>> Date: Wed, 18 Jun 2014 13:18:07 +0200
>> From: Lukas Czerner <lczerner@redhat.com>
>> To: linux-mmc@vger.kernel.org
>> Cc: linux-fsdevel@vger.kernel.org, chris@printf.net,
>>     Lukas Czerner <lczerner@redhat.com>
>> Subject: [PATCH] mmc: Do not advertise secure discard if it is blacklisted
>>
>> Currently when the device secure discard implementation is
>> blacklisted (MMC_QUIRK_SEC_ERASE_TRIM_BROKEN quirk is set)
>> instead of secure discard we're going to do normal discard,
>> which is wrong.
>>
>> When the secure discard is known to be broken we should just
>> disallow it entirely and not advertise this functionality to
>> the user. Fix it.
>>
>> Also move mmc_fixup_device() in from of mmc_blk_alloc() so we
>> can get quirks set before we attempt to set queue information.
> 
> Where should I send it to get noticed ? It's sitting here for a
> month now.
> 
> Thanks!
> -Lukas
> 
>>
>> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
>> ---
>>  drivers/mmc/card/block.c | 6 +++---
>>  drivers/mmc/core/core.c  | 3 ++-
>>  2 files changed, 5 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
>> index 452782b..ede41f0 100644
>> --- a/drivers/mmc/card/block.c
>> +++ b/drivers/mmc/card/block.c
>> @@ -2028,8 +2028,7 @@ static int mmc_blk_issue_rq(struct mmc_queue *mq, struct request *req)
>>  		/* complete ongoing async transfer before issuing discard */
>>  		if (card->host->areq)
>>  			mmc_blk_issue_rw_rq(mq, NULL);
>> -		if (req->cmd_flags & REQ_SECURE &&
>> -			!(card->quirks & MMC_QUIRK_SEC_ERASE_TRIM_BROKEN))
>> +		if (req->cmd_flags & REQ_SECURE)
>>  			ret = mmc_blk_issue_secdiscard_rq(mq, req);
>>  		else
>>  			ret = mmc_blk_issue_discard_rq(mq, req);
>> @@ -2432,6 +2431,8 @@ static int mmc_blk_probe(struct mmc_card *card)
>>  	if (!(card->csd.cmdclass & CCC_BLOCK_READ))
>>  		return -ENODEV;
>>  
>> +	mmc_fixup_device(card, blk_fixups);
>> +
>>  	md = mmc_blk_alloc(card);
>>  	if (IS_ERR(md))
>>  		return PTR_ERR(md);
>> @@ -2446,7 +2447,6 @@ static int mmc_blk_probe(struct mmc_card *card)
>>  		goto out;
>>  
>>  	mmc_set_drvdata(card, md);
>> -	mmc_fixup_device(card, blk_fixups);
>>  
>>  	if (mmc_add_disk(md))
>>  		goto out;
>> diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
>> index 7dc0c85..d03a080 100644
>> --- a/drivers/mmc/core/core.c
>> +++ b/drivers/mmc/core/core.c
>> @@ -2102,7 +2102,8 @@ EXPORT_SYMBOL(mmc_can_sanitize);
>>  
>>  int mmc_can_secure_erase_trim(struct mmc_card *card)
>>  {
>> -	if (card->ext_csd.sec_feature_support & EXT_CSD_SEC_ER_EN)
>> +	if ((card->ext_csd.sec_feature_support & EXT_CSD_SEC_ER_EN) &&
>> +	    !(card->quirks & MMC_QUIRK_SEC_ERASE_TRIM_BROKEN))
>>  		return 1;
>>  	return 0;
>>  }
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

