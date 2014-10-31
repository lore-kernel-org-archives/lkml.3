Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161705AbaJaCZ4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 22:25:56 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:14352 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161558AbaJaCZy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 22:25:54 -0400
X-AuditID: cbfee691-f79b86d000004a5a-80-5452f32ff96c
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Message-id: <5452F32F.8010103@samsung.com>
Date: Fri, 31 Oct 2014 11:25:51 +0900
From: jonghwa3.lee@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120411
 Thunderbird/11.0.1
To: =?UTF-8?B?S3J6eXN6dG9mIEtvesWCb3dza2k=?= <k.kozlowski@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, sre@kernel.org,
        dbaryshkov@gmail.com, dwmw2@infradead.org, anton@enomsg.org,
        pavel@ucw.cz, myungjoo.ham@samsung.com, cw00.choi@samsung.com
Subject: Re: [PATCH 01/10] power: charger-manager: Use thermal subsystem
 interface only to get temperature.
References: <1414672996-28355-1-git-send-email-jonghwa3.lee@samsung.com>
 <1414672996-28355-2-git-send-email-jonghwa3.lee@samsung.com>
 <54523907.4030609@samsung.com>
In-reply-to: <54523907.4030609@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrAIsWRmVeSWpSXmKPExsWyRsSkQFf/c1CIQf8vM4uDWzUtrn95zmox
	6cl7ZouJKyczW7x+YWhxedccNovPvUcYLW43rmCzuHvqKJvF6d0lDlweE/o/MXrsnHWX3WPz
	Ci2PTas62Tz6tqxi9Fix+ju7x+dNcgHsUVw2Kak5mWWpRfp2CVwZ3x9oFNzirWi8vIWlgfEb
	VxcjJ4eEgInEoduzmSBsMYkL99azdTFycQgJLGWU2Hl+IxNM0b4nt5ggEosYJd7N72AESfAK
	CEr8mHyPBcRmFlCXmDRvETOELSJxtvMYE4StLbFs4WtmiObXjBI/mmYyQTRrSXzsnwbWzCKg
	KvHyxjt2EJtNQE7ibdM3sAWiAmESVyccB6sREXCTOH1xNdTQU4wSl1Zzg9jCArkSk579ZQWx
	hQRWMEq8XecIYnMCLd53rYURZLGEwEd2iWerrjNCLBOQ+Db5ENBQDqCErMSmA8wQX0pKHFxx
	g2UCo/gsJL/NQvLbLCS/zULy2wJGllWMoqkFyQXFSelFpnrFibnFpXnpesn5uZsYgRF9+t+z
	iTsY7x+wPsQowMGoxMO74HhQiBBrYllxZe4hRlOgiyYyS4km5wPTRl5JvKGxmZGFqYmpsZG5
	pZmSOK+O9M9gIYH0xJLU7NTUgtSi+KLSnNTiQ4xMHJxSDYz76n64mj+umXt80iT7KNmbfEKF
	kc5N93ftSJXjqis3So4vD96VOFmsdd3nWIUjnjynjP1slr76maLewFiipsPh/dTzm8HKwy1c
	XU9s13vfKXvZO+1499V9e24//3/+2tTav5fEW8t5/qbdKk//+3f11QO3y94rZR9ZduDR7myV
	VAnWxs+JC3cqsRRnJBpqMRcVJwIAbsur7eMCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpkleLIzCtJLcpLzFFi42I5/e+xgK7+56AQg7mNBhYHt2paXP/ynNVi
	0pP3zBYTV05mtnj9wtDi8q45bBafe48wWtxuXMFmcffUUTaL07tLHLg8JvR/YvTYOesuu8fm
	FVoem1Z1snn0bVnF6LFi9Xd2j8+b5ALYoxoYbTJSE1NSixRS85LzUzLz0m2VvIPjneNNzQwM
	dQ0tLcyVFPISc1NtlVx8AnTdMnOAjlNSKEvMKQUKBSQWFyvp22GaEBripmsB0xih6xsSBNdj
	ZIAGEtYwZtzd84294BBvxaybZxkbGO9xdTFyckgImEjse3KLCcIWk7hwbz1bFyMXh5DAIkaJ
	d/M7GEESvAKCEj8m32PpYuTgYBaQlzhyKRskzCygLjFp3iJmiPrXjBI/mmYyQdRrSXzsn8YC
	YrMIqEq8vPGOHcRmE5CTeNv0DWymqECYxNUJx8FqRATcJE5fXM0EMfQUo8Sl1dwgtrBArsSk
	Z39ZQWwhgRWMEm/XOYLYnALaEvuutTBOYBSYheS8WQjnzUJy3gJG5lWMoqkFyQXFSem5RnrF
	ibnFpXnpesn5uZsYwdH/THoH46oGi0OMAhyMSjy8C44HhQixJpYVV+YeYpTgYFYS4Z30FijE
	m5JYWZValB9fVJqTWnyI0RTouYnMUqLJ+cDElFcSb2hsYmZkaWRuaGFkbK4kznuw1TpQSCA9
	sSQ1OzW1ILUIpo+Jg1OqgZFn0cEZ1ldruI958+cx79yp+u3rboNNSZ9mCO/dYzgnwe7pRCPJ
	y5VqK1LFLBcdfnWsheFI+K3NrzJd+6O5s8R5OSQYPG/aS4mkP53odlynOGxZiYPIPIWc0qf7
	LqW7azKu1wxlcTjj5OFw4S/Tvfzj/eptZV+YjZuPWe1Qn/oip0zza/jna0osxRmJhlrMRcWJ
	AK25y7kUAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
On 2014년 10월 30일 22:11, Krzysztof Kozłowski wrote:

> On 30.10.2014 13:43, Jonghwa Lee wrote:
>> It drops the way of using power_supply interface to reference battery's
>> temperature. Then it tries to use thermal subsystem's only. This makes driver
>> more simple and also can remove ifdeferies.
>>
>> Signed-off-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
>> ---
>>  drivers/power/Kconfig                 |    1 +
>>  drivers/power/charger-manager.c       |  113 ++++++++-------------------------
>>  include/linux/power/charger-manager.h |    3 +-
>>  3 files changed, 28 insertions(+), 89 deletions(-)
>>
>> diff --git a/drivers/power/Kconfig b/drivers/power/Kconfig
>> index 8ff2511..115d153 100644
>> --- a/drivers/power/Kconfig
>> +++ b/drivers/power/Kconfig
>> @@ -317,6 +317,7 @@ config CHARGER_MANAGER
>>  	bool "Battery charger manager for multiple chargers"
>>  	depends on REGULATOR
>>  	select EXTCON
>> +	select THERMAL
> 
> I think both of "select" here could be dangerous. Select should rather
> be used for non-visible errors. Just use "depends on".
> 
>>  }
>> @@ -623,7 +594,7 @@ static int cm_check_thermal_status(struct charger_manager *cm)
>>  		 * occur hazadous result. We have to handle it
>>  		 * depending on battery type.
>>  		 */
>> -		dev_err(cm->dev, "Failed to get battery temperature\n");
>> +		dev_dbg(cm->dev, "Failed to get battery temperature\n");
> 
> A valuable change but not strictly related to the commit. Additionally
> that is a user-visible change. Could you split it to separate patch?
> 
> Best regards,
> Krzysztof
> 
> 


All your comments are acceptable. I'll fix them all.
Thanks for your comments.

Thanks,
Jonghwa
