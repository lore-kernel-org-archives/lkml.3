Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751939Ab3GXGOR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 02:14:17 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:53805 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751791Ab3GXGOO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 02:14:14 -0400
X-AuditID: cbfee691-b7fef6d000002d62-81-51ef70b49181
Message-id: <51EF70B4.2010806@samsung.com>
Date: Wed, 24 Jul 2013 15:14:12 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: rjw@sisk.pl, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        cpufreq@vger.kernel.org, kyungmin.park@samsung.com,
        myungjoo.ham@samsung.com,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>
Subject: Re: [PATCH 1/3 v6] cpufreq: Add debugfs directory for cpufreq
References: <1374146275-5758-1-git-send-email-cw00.choi@samsung.com>
 <1374146275-5758-2-git-send-email-cw00.choi@samsung.com>
 <CAKohpo=oTsEjzi_51UaZ8ww8UEfZ6hwKAnu9rFgGBkt=TfHi8A@mail.gmail.com>
 <51EF2D06.7000704@samsung.com>
In-reply-to: <51EF2D06.7000704@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrEIsWRmVeSWpSXmKPExsWyRsSkSHdrwftAg3MHWC2eNv1gtzjb9Ibd
	4v2hZ8wWl3fNYbP43HuE0eJ24wo2i/6FvUwWG796OHB43Lm2h83j9r/HzB59W1Yxejxa3MLo
	8XmTXABrFJdNSmpOZllqkb5dAlfG7TM8BY2cFat/rmFrYFzC1sXIySEhYCLxt/EylC0mceHe
	eiCbi0NIYCmjRPexVmaYokPL7jBDJBYxSjxovcMO4bxilLj1dC8TSBWvgJbE667JYDaLgKrE
	9SvLwcayAcX3v7gBZosKhEmsnH6FBaJeUOLH5HtANgeHCFDNy5upIDOZBc4zSuz+fw5ss7CA
	m8T5e91gvUICzxklNi7jBbE5BbQl/hzcB1bDLKAjsb91GhuELS+xec1bsEslBC6xS6yf9IAV
	4iABiW+TD4EtkxCQldh0AOozSYmDK26wTGAUm4XkpFlIxs5CMnYBI/MqRtHUguSC4qT0IlO9
	4sTc4tK8dL3k/NxNjMD4O/3v2cQdjPcPWB9iTAZaOZFZSjQ5Hxi/eSXxhsZmRhamJqbGRuaW
	ZqQJK4nzqrdYBwoJpCeWpGanphakFsUXleakFh9iZOLglGpg5N0VHfZe7c4m+x1uero5E64z
	LrgxJ/hgtbjWn6YNiy/M3bXbZt4kudX/3+1exbu2YuHyReZWqgvaihcdudlZ9nTufPPdtrEh
	BlFqYhX/K3s6xRVZXDmuuv6ebRvXdGsWl2Lo0lv5W+e9vnuXaV2VVLr8IQ+TGaXf3DUff2Y5
	z3v2Q9jxOV2rFJRYijMSDbWYi4oTAWCGCunVAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprPKsWRmVeSWpSXmKPExsVy+t9jAd0tBe8DDfofWVk8bfrBbnG26Q27
	xftDz5gtLu+aw2bxufcIo8XtxhVsFv0Le5ksNn71cODwuHNtD5vH7X+PmT36tqxi9Hi0uIXR
	4/MmuQDWqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23
	zBygW5QUyhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCBhDWMGbfP8BQ0clas/rmG
	rYFxCVsXIyeHhICJxKFld5ghbDGJC/fWA8W5OIQEFjFKPGi9ww7hvGKUuPV0LxNIFa+AlsTr
	rslgNouAqsT1K8vBJrEBxfe/uAFmiwqESaycfoUFol5Q4sfke0A2B4cIUM3Lm6kgM5kFzjNK
	7P5/DmyzsICbxPl73WC9QgLPGSU2LuMFsTkFtCX+HNwHVsMsoCOxv3UaG4QtL7F5zVvmCYwC
	s5CsmIWkbBaSsgWMzKsYRVMLkguKk9JzDfWKE3OLS/PS9ZLzczcxgqP7mdQOxpUNFocYBTgY
	lXh4C2a9CxRiTSwrrsw9xCjBwawkwvtC5n2gEG9KYmVValF+fFFpTmrxIcZkYAhMZJYSTc4H
	Jp68knhDYxMzI0sjc0MLI2Nz0oSVxHkPtFoHCgmkJ5akZqemFqQWwWxh4uCUamA0lWm5HZS7
	+qq0RUjL8a8R9cc+yl7TTxFdwBD+2HVb6Y61k199mpr4Nkf+88Ztv/6uUqpaeWLT3M7PBmXK
	S02y1V+pJ2seaXH4umn6PHePPWHFhneyRLqZBetjF6sU8BTuKKw/EGBnGG5t2vzS9VT87EIT
	drX1fq+Ub68RuOhRIxDOFWInZKLEUpyRaKjFXFScCAAfHKDOMgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Viresh,

>>> +       if (!policy->cpu_debugfs[idx]) {
>>> +               pr_err("creating debugfs directory failed\n");
>>> +               return -ENODEV;
>>> +       }
>>> +
>>> +       return 0;
>>> +}
>>> +
>>> +static int cpufreq_create_debugfs_symlink(struct cpufreq_policy *policy,
>>> +                                          unsigned int src_cpu,
>>> +                                          unsigned int dest_cpu)
>>
>> Only use policy and cpu for which symlink has to be created as param
>> to this routine. And create link to policy->cpu.
>>
> 
> OK, I'll simplify function prototype(cpufreq_create_debugfs_symlink) by removing
> unnecessary parameter.
> 

I considered the parameter type of cpufreq_create_debugfs_symlink() and then
I need following function declaration because this function didn't always need to
create symbolic link to policy->cpu. This function declaration is capable of creating
symbolic link as 'dest_cpu -> src_cpu'

	+static int cpufreq_create_debugfs_symlink(unsigned int src_cpu,
	+                                          unsigned int dest_cpu)

Thanks,
Chanwoo Choi


