Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751408AbaKKAa3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 19:30:29 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:50020 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799AbaKKAa1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 19:30:27 -0500
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee68f-f791c6d000004834-5e-546158a0bb67
Content-transfer-encoding: 8BIT
Message-id: <546158A0.5000707@samsung.com>
Date: Tue, 11 Nov 2014 09:30:24 +0900
From: jonghwa3.lee@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120411
 Thunderbird/11.0.1
To: "Tc, Jenny" <jenny.tc@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "sre@kernel.org" <sre@kernel.org>,
        "dbaryshkov@gmail.com" <dbaryshkov@gmail.com>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "anton@enomsg.org" <anton@enomsg.org>, "pavel@ucw.cz" <pavel@ucw.cz>
Subject: Re: [PATCH 2/3] power: core: Add variables related temperature to
 power_supply_info.
References: <1412679518-21499-1-git-send-email-jonghwa3.lee@samsung.com>
 <1412679518-21499-3-git-send-email-jonghwa3.lee@samsung.com>
 <20ADAB092842284E95860F279283C5642ED9EDE3@BGSMSX104.gar.corp.intel.com>
In-reply-to: <20ADAB092842284E95860F279283C5642ED9EDE3@BGSMSX104.gar.corp.intel.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPIsWRmVeSWpSXmKPExsWyRsSkUHdBRGKIwYH3BhYHt2paTHryntli
	4srJzBZrv/awW1zeNYfN4nPvEUaLu6eOslmc3l3iwOExof8To8fOWXfZPTav0PJYvOclk8em
	VZ1sHitWf2f3+LxJLoA9issmJTUnsyy1SN8ugSvjysv57AU7OSrmtkxgaWA8y9bFyMkhIWAi
	0fWnDcoWk7hwbz2QzcUhJLCUUWLZ0sdMMEWrbm1jgkhMZ5TY8GQ1K0iCV0BQ4sfkeyxdjBwc
	zALyEkcuZYOEmQXUJSbNW8QMUf+aUWLCtD/sEPVaEi9fzWYBsVkEVCXW72oEW8AmICfxtukb
	I4gtKhAmcXXCcbAaEQEViakt38EWMwscZ5L4dPMdM8gyYYF4idmfQyEWXGSU6L84B6yBE6j5
	zbe7jCAJCYFH7BL7nz1hh9gmIPFt8iGwSyUEZCU2HWCG+ExS4uCKGywTGMVmIflnFsI/s5D8
	s4CReRWjaGpBckFxUnqRsV5xYm5xaV66XnJ+7iZGYDye/vesfwfj3QPWhxgFOBiVeHg1/BND
	hFgTy4orcw8xmgIdMZFZSjQ5Hxj1eSXxhsZmRhamJqbGRuaWZkrivAulfgYLCaQnlqRmp6YW
	pBbFF5XmpBYfYmTi4JRqYDwu6TxjaoPmjO9iOg+fys+5oHT2wOrzsx3mKE/h9ut7+GO/46sn
	cXM320d/UJ6sub77vETbknkBU7re5K+Ka7ujEbP05p43lTtdlT7UH3YO27y8YDH/A/btvBpy
	Td/S9BarHmqS/5LJ8P9I4AWvIxE9C2fFOsf+zHaWXxoRsOVujaFbsLB8zmElluKMREMt5qLi
	RABg+ZA6wgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrJIsWRmVeSWpSXmKPExsVy+t9jQd0FEYkhBrvnaFoc3KppMenJe2aL
	iSsnM1us/drDbnF51xw2i8+9Rxgt7p46ymZxeneJA4fHhP5PjB47Z91l99i8Qstj8Z6XTB6b
	VnWyeaxY/Z3d4/MmuQD2qAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE
	3FRbJRefAF23zBygm5QUyhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCBhDWMGVde
	zmcv2MlRMbdlAksD41m2LkZODgkBE4lVt7YxQdhiEhfurQeKc3EICUxnlNjwZDUrSIJXQFDi
	x+R7LF2MHBzMAvISRy5lg4SZBdQlJs1bxAxR/5pRYsK0P+wQ9VoSL1/NZgGxWQRUJdbvagRb
	wCYgJ/G26RsjiC0qECZxdcJxsBoRARWJqS3fmUAGMQscZ5L4dPMdM8gyYYF4idmfQyEWXGSU
	6L84B6yBE6j5zbe7jBMYBWYhuW8Wwn2zkNy3gJF5FaNoakFyQXFSeq6hXnFibnFpXrpecn7u
	JkZwtD+T2sG4ssHiEKMAB6MSD6+mf2KIEGtiWXFl7iFGCQ5mJRFeHw2gEG9KYmVValF+fFFp
	TmrxIUZToO8mMkuJJucDE1FeSbyhsYmZkaWRuaGFkbG5kjjvgVbrQCGB9MSS1OzU1ILUIpg+
	Jg5OqQbG9l/m/hei2Rk/ir/aqfBd7nvqr4IVXPabN3KKOIrlJgk5TLHTcg+dFiV+9urTG1/b
	4/WrYzqtDQUtw066T/Fidd91ntnlVL7dVz2J6tm5XHMqxXS3s39/M+PGitcRat8lS1ib5Hyv
	2j/XCd4xb9nzfR7Hmg71RJnqmH57byRvtk53P9sppXYlluKMREMt5qLiRACrkLDxDAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014년 11월 10일 20:16, Tc, Jenny wrote:

>> @@ -241,6 +241,8 @@ struct power_supply_info {
>>  	int charge_empty_design;
>>  	int energy_full_design;
>>  	int energy_empty_design;
>> +	int temperature_max;
>> +	int temperature_min;
>>  	int use_for_apm;
>>  };
> 
> 
> The CC,CV and restart threshold would vary based on the battery temperature
> So I would suggest to have temperature zone table as part  of battery info
> along with other attributes.
> 
> int iterm; //charge termination current (used to stop charging)
> int temp_zone_count; // number of temperature zone tables present
> struct batt_temp_mon_table temp_mon_tbl[MAX_TEMP_MON_TABLE]; //temperature zone table array
> 
> struct  batt_temp_mon_table {
> 	 short int temp_max;
> 	 short int cc;
> 	 short int cv;
> 	 short int vbat_vchk_drop_uv;
> 	 short int temp_min;
> };
> 


IMO, throttling cc/cv according the temperature can be done via thermal fw
interface. However voltage drop and charging termination current can be added here.


Jonghwa

> -Jenny
> 
> 


