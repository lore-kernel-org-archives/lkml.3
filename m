Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751253Ab3FYFJb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 01:09:31 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:19373 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741Ab3FYFJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 01:09:29 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee68f-b7f436d000000f81-31-51c926082564
Content-transfer-encoding: 8BIT
Message-id: <51C92607.7050403@samsung.com>
Date: Tue, 25 Jun 2013 14:09:27 +0900
From: jonghwa3.lee@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120411
 Thunderbird/11.0.1
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: anton.vorontsov@linaro.org, linux-kernel@vger.kernel.org,
        Myungjoo Ham <myungjoo.ham@samsung.com>
Subject: Re: [PATCH 1/2] power: charger-manager: regulator_get() never returns
 NULL.
References: <1372136569-551-1-git-send-email-jonghwa3.lee@samsung.com>
 <CAK9yfHxLDiu7tagRhPEK1aCCTYnMH7i2yKrtqquAwnfxHnZxSg@mail.gmail.com>
In-reply-to: <CAK9yfHxLDiu7tagRhPEK1aCCTYnMH7i2yKrtqquAwnfxHnZxSg@mail.gmail.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrCIsWRmVeSWpSXmKPExsWyRsSkSJdD7WSgwZVDGhYXW2+zWFzeNYfN
	4nbjCjaLk396GR1YPO5c28Pm0bdlFaPH501yAcxRXDYpqTmZZalF+nYJXBkX//1mKZjPXTHn
	n04D4xKOLkZODgkBE4nvXzrYIGwxiQv31gPZXBxCAksZJb596WSGKXq7ajYLRGI6o8Tl/+2s
	IAleAUGJH5PvASU4OJgF5CWOXMoGCTMLqEtMmreIGaL+JaPEqjmtUPVaEt9aWxhBbBYBVYn+
	xj52EJtNQE7ibdM3sLioQJjE1QnHWUBsEaD6l93LmSCGpkssa7wOViMMVLPg/n+oBb2MEitv
	PwcbxCkQLLHyxRF2kISEwDJ2ifeHvzBBbBOQ+Db5ENilEgKyEpsOQH0mKXFwxQ2WCYxis5D8
	Mwvhn1lI/lnAyLyKUTS1ILmgOCm9yFivODG3uDQvXS85P3cTIzCGTv971r+D8e4B60OMyUAb
	JzJLiSbnA2MwryTe0NjMyMLUxNTYyNzSjDRhJXFetRbrQCGB9MSS1OzU1ILUovii0pzU4kOM
	TBycUg2MW7hzeXpmf3z3xDki11rwov6fH5v9Gp/zfn7ZrHJ9VtXZKcs+nK12ZHmU/uWL95es
	lqe1B7PveAsIbNM8pm8bbZpYfGj2It2+iR/33To1f67rgpsSp1a9/nAsJJat0KJ6Vb3S6c+b
	Z5TvX7y2a135mnLGDfsef5I1iphw/orX98RYxWtPbwm9uqHEUpyRaKjFXFScCADbOZWStwIA	AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpkleLIzCtJLcpLzFFi42I5/e+xoC6H2slAg6urFC0utt5msbi8aw6b
	xe3GFWwWJ//0MjqweNy5tofNo2/LKkaPz5vkApijGhhtMlITU1KLFFLzkvNTMvPSbZW8g+Od
	403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4DWKSmUJeaUAoUCEouLlfTtME0IDXHTtYBpjND1
	DQmC6zEyQAMJaxgzLv77zVIwn7tizj+dBsYlHF2MnBwSAiYSb1fNZoGwxSQu3FvP1sXIxSEk
	MJ1R4vL/dlaQBK+AoMSPyfeAijg4mAXkJY5cygYJMwuoS0yat4gZov4lo8SqOa1Q9VoS31pb
	GEFsFgFVif7GPnYQm01ATuJt0zewuKhAmMTVCcfBFosA1b/sXs4EMTRdYlnjdbAaYaCaBff/
	Qy3oZZRYefs52CBOgWCJlS+OsE9gFJiF5L5ZCPfNQnLfAkbmVYyiqQXJBcVJ6bmGesWJucWl
	eel6yfm5mxjBEfpMagfjygaLQ4wCHIxKPLyRu04ECrEmlhVX5h5ilOBgVhLhDRUBCvGmJFZW
	pRblxxeV5qQWH2JMBvpuIrOUaHI+MHnklcQbGpuYGVkamRtaGBmbkyasJM57oNU6UEggPbEk
	NTs1tSC1CGYLEwenVANjYsTnlSeOzsoMjbRVt7A8XHrXME05qK1B4/DLDa0v4k/Xq/uq5maW
	KIr0rdB0SfyqIxfCWWTHy+k7VWLb5487KswiTwjtm/1quUndObmrKn6uyyrPHkz55G+0fIv0
	pKTOCmYN1wszfl/TV5894+QhZ/krzzL/id6sOKWwLzzNY13AedENy3mVWIozEg21mIuKEwFs
	jwAzFAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013년 06월 25일 14:07, Sachin Kamat wrote:

> On 25 June 2013 10:32, Jonghwa Lee <jonghwa3.lee@samsung.com> wrote:
>> This patch fixes return value checking of regulator_get() in charger-manager
>> driver. The API, regulator_get(), returns ERR_PTR() when it fails to get
>> regulator with given name, not NULL.
>>
>> Signed-off-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
>> Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>
>> ---
>>  drivers/power/charger-manager.c |    2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/power/charger-manager.c b/drivers/power/charger-manager.c
>> index ba42029..7d1bcde 100644
>> --- a/drivers/power/charger-manager.c
>> +++ b/drivers/power/charger-manager.c
>> @@ -1239,7 +1239,7 @@ static int charger_manager_register_extcon(struct charger_manager *cm)
>>
>>                 charger->consumer = regulator_get(cm->dev,
>>                                         charger->regulator_name);
>> -               if (charger->consumer == NULL) {
>> +               if (IS_ERR(charger->consumer)) {
>>                         dev_err(cm->dev, "Cannot find charger(%s)\n",
>>                                 charger->regulator_name);
>>                         ret = -EINVAL;
> 
>  You can as well make this ret = PTR_ERR(charger->consumer).


Yes, I'll fix it.

Thanks,
Jonghwa

> 
> ---
> With warm regards,
> Sachin
> 


