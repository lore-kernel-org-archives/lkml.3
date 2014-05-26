Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751949AbaEZJLJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 05:11:09 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:20373 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751713AbaEZJLE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 05:11:04 -0400
X-AuditID: cbfee68d-b7fd46d000005f36-b3-538305252b92
Message-id: <53830525.3090902@samsung.com>
Date: Mon, 26 May 2014 18:11:01 +0900
From: Jaehoon Chung <jh80.chung@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101
 Thunderbird/24.4.0
MIME-version: 1.0
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Jaehoon Chung <jh80.chung@samsung.com>,
        linux-mmc <linux-mmc@vger.kernel.org>, Chris Ball <chris@printf.net>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Tushar Behera <tushar.behera@linaro.org>
Subject: Re: [PATCH 1/3] mmc: host: add slot argument to mmc_of_parse
References: <1400840721-11050-1-git-send-email-jh80.chung@samsung.com>
 <1400840721-11050-2-git-send-email-jh80.chung@samsung.com>
 <20140526080916.GE12777@ldesroches-Latitude-E6320>
 <5382FD78.3060402@gmail.com>
 <CAPDyKFrZXd30wXJNsO64-Np129_53D=TVv2yBmBhsOxJa0Sm6g@mail.gmail.com>
In-reply-to: <CAPDyKFrZXd30wXJNsO64-Np129_53D=TVv2yBmBhsOxJa0Sm6g@mail.gmail.com>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrEIsWRmVeSWpSXmKPExsWyRsSkQFeVtTnYYMUDGYsJl7czWsw/co7V
	4savNlaLy7vmsFkc+d/PaDHj/D4miw/3LzJbtP/dy2ZxfG24A6fHnWt72DxuvFrI5NG3ZRWj
	x+dNcgEsUVw2Kak5mWWpRfp2CVwZK86sYy24wlGxbO9ilgbGz2xdjJwcEgImEstXXoayxSQu
	3FsPZgsJLGWUWH3CCaZm+4o97F2MXEDx6YwSB65tY4VwXjNKvNm2jRmkildAS+L7321MXYwc
	HCwCqhIvdyeDhNkEdCS2fzvOBGKLCoRJPN38hw2iXFDix+R7LCC2iICGxJ6H58FmMgv8ZZJo
	2DuXFSQhLOAqcerWUiaIZfOYJE7uWcMOkuAUCJbYsvAXWBGzgLrEpHmLmCFseYnNa94yQ5x9
	i13iwJckEJtFQEDi2+RDLCDHSQjISmw6AFUiKXFwxQ2WCYxis5DcNAvJ1FlIpi5gZF7FKJpa
	kFxQnJReZKhXnJhbXJqXrpecn7uJERh/p/89693BePuA9SHGZKCVE5mlRJPzgfGbVxJvaGxm
	ZGFqYmpsZG5pRpqwkjhv0sOkICGB9MSS1OzU1ILUovii0pzU4kOMTBycUg2MZot2FTZrx51w
	eP5OqPbQn79NcfcusbvsFzWr/Xa5dNna38dEHn9gNF57UD/gy75lDlznJI+e+bdAMvyh26d3
	ET7p/2P3fNH5JbMxIatNKGY6267dipm6cRfPTH9SrzTb3fe8svptsfM3/mjdnH8gqSul/ve9
	/6b/lbwPO8+5kMEUWe7FoMj5UImlOCPRUIu5qDgRAMnOn/XVAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrIKsWRmVeSWpSXmKPExsVy+t9jQV1V1uZgg54tIhYTLm9ntJh/5Byr
	xY1fbawWl3fNYbM48r+f0WLG+X1MFh/uX2S2aP+7l83i+NpwB06PO9f2sHnceLWQyaNvyypG
	j8+b5AJYohoYbTJSE1NSixRS85LzUzLz0m2VvIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8AnTd
	MnOAblFSKEvMKQUKBSQWFyvp22GaEBripmsB0xih6xsSBNdjZIAGEtYwZqw4s4614ApHxbK9
	i1kaGD+zdTFyckgImEhsX7GHHcIWk7hwbz1QnItDSGA6o8SBa9tYIZzXjBJvtm1jBqniFdCS
	+P53G1MXIwcHi4CqxMvdySBhNgEdie3fjjOB2KICYRJPN/9hgygXlPgx+R4LiC0ioCGx5+F5
	sJnMAn+ZJBr2zmUFSQgLuEqcurWUCWLZPCaJk3vWgJ3EKRAssWXhL7AiZgF1iUnzFjFD2PIS
	m9e8ZZ7AKDALyZJZSMpmISlbwMi8ilE0tSC5oDgpPddQrzgxt7g0L10vOT93EyM4wp9J7WBc
	2WBxiFGAg1GJh/eAd1OwEGtiWXFl7iFGCQ5mJRHe5g9AId6UxMqq1KL8+KLSnNTiQ4zJwCCY
	yCwlmpwPTD55JfGGxiZmRpZG5oYWRsbmpAkrifMeaLUOFBJITyxJzU5NLUgtgtnCxMEp1cCo
	7nX9xr5zErz6bE+Ss9Q8L516e/3yOd6VHy9lZ6gtjGL8tEyaocGh0qqfe9f2GS8Xhqkm9kTs
	YDw4seERf8zMue8/eTV2TF0h+2jiHaMd8x6fsWJi95x/40VTxox6oecmRoevLprduz5gyuLj
	H/3bk9fEmM71C9TtP3/qYmCz3j6B9Q/YbtjaKrEUZyQaajEXFScCAEa8zTI0AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Ulf.

On 05/26/2014 05:44 PM, Ulf Hansson wrote:
> On 26 May 2014 10:38, Jaehoon Chung <jh80.chung@gmail.com> wrote:
>> Hi,
>>
>> On 05/26/2014 05:09 PM, Ludovic Desroches wrote:
>>> On Fri, May 23, 2014 at 07:25:19PM +0900, Jaehoon Chung wrote:
>>>> From: Ludovic Desroches <ludovic.desroches@atmel.com>
>>>>
>>>> Some hosts manage several slots. In these case information such as the
>>>> bus width, chi detect and others are into the slot node. So we have to
>>>
>>> /s/chi detect/chip detect
>> Will fix.
>>
>> Tushar have suggested the rename mmc_of_parse_slot() instead of __mmc_of_parse().
>> I'm not sure which name is better. How about?
>>
>> If never mind, i will change to mmc_of_parse_slot(), then send patch-v2.
> 
> I would prefer to keep it as is, but just because that's my taste. :-)
Ok. I think so.
I want to merge this patch-set for fixing the dw-mmc problem, before release the 3.16.

dw-mmc controller also used the slot concept, so some property didn't parse with mmc_of_parse().

Best Regards,
Jaehoon Chung
 
> 
> Kind regards
> Ulf Hansson
> 

