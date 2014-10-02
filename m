Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752695AbaJBNSJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 09:18:09 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:65275 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751507AbaJBNSI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 09:18:08 -0400
Message-ID: <542D508B.9070002@nod.at>
Date: Thu, 02 Oct 2014 15:18:03 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Tanya Brokhman <tlinder@codeaurora.org>, dedekind1@gmail.com
CC: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] UBI: Fastmap: Calc fastmap size correctly
References: <1412029248-22454-1-git-send-email-richard@nod.at> <1412029248-22454-3-git-send-email-richard@nod.at> <542D4FD0.9050606@codeaurora.org>
In-Reply-To: <542D4FD0.9050606@codeaurora.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 02.10.2014 15:14, schrieb Tanya Brokhman:
> On 9/30/2014 1:20 AM, Richard Weinberger wrote:
>> We need to add fm_sb too.
>>
>> Signed-off-by: Richard Weinberger <richard@nod.at>
>> ---
>>   drivers/mtd/ubi/fastmap.c | 3 ++-
>>   1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/mtd/ubi/fastmap.c b/drivers/mtd/ubi/fastmap.c
>> index 0431b46..2b0d8d6 100644
>> --- a/drivers/mtd/ubi/fastmap.c
>> +++ b/drivers/mtd/ubi/fastmap.c
>> @@ -24,7 +24,8 @@ size_t ubi_calc_fm_size(struct ubi_device *ubi)
>>   {
>>       size_t size;
>>
>> -    size = sizeof(struct ubi_fm_hdr) + \
>> +    size = sizeof(struct ubi_fm_sb) + \
>> +        sizeof(struct ubi_fm_hdr) + \
>>           sizeof(struct ubi_fm_scan_pool) + \
>>           sizeof(struct ubi_fm_scan_pool) + \
>>           (ubi->peb_count * sizeof(struct ubi_fm_ec)) + \
>>
> 
> Not sure what's the proper way doing this (Reviewed-by/Acked-by) but I agree this patch is required. I would just elaborate a bit more on the commit message.

If you read this patch and find it good, please add your Reviewed-by.
Thanks a lot for reviewing my patches!

Thanks,
//richard
