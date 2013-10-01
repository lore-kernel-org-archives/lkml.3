Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751989Ab3JAIdY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 04:33:24 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:9672 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751509Ab3JAIdV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 04:33:21 -0400
X-AuditID: cbfee68e-b7f756d000004512-aa-524a88cfd594
Message-id: <524A88CF.4050601@samsung.com>
Date: Tue, 01 Oct 2013 17:33:19 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: myungjoo.ham@samsung.com, broonie@kernel.org,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] extcon: arizona: Get pdata from arizona structure not
 device
References: <1380378897-7164-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
 <5248B9BA.9020003@samsung.com>
 <20130930095202.GY3635@opensource.wolfsonmicro.com>
 <524A0369.1080101@samsung.com>
 <20131001082236.GZ3635@opensource.wolfsonmicro.com>
In-reply-to: <20131001082236.GZ3635@opensource.wolfsonmicro.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPIsWRmVeSWpSXmKPExsWyRsSkUPd8h1eQwZKpBhZTHz5hs/g35Qa7
	xeVdc9gsbjeuYLNY/vY/mwOrx6ZVnWweLyf+ZvPo27KK0ePzJrkAligum5TUnMyy1CJ9uwSu
	jK+fexkL5vFVfJ+2n6WBcTN3FyMnh4SAicT8K+2MELaYxIV769m6GLk4hASWMkp03O9hhyna
	/PwaWJGQwHRGiYbPuhBFrxglzt88DVbEK6Al8fX+ahYQm0VAVeLPm+VgcTag+P4XN9hAbFGB
	MImV06+wQNQLSvyYfA/MFhGwkJiy5BZzFyMHB7NAqcSPpcEgYWGBYIl3O3uYIHY1MUl83PeQ
	GSTBKeAg0TXjJ5jNLKAjsb91GhuELS+xec1bZpAGCYFd7BKvp69lgzhIQOLb5EMsIAskBGQl
	Nh1ghnhMUuLgihssExjFZiE5aRaSsbOQjF3AyLyKUTS1ILmgOCm9yEivODG3uDQvXS85P3cT
	IzCyTv971reD8eYB60OMyUArJzJLiSbnAyMzryTe0NjMyMLUxNTYyNzSjDRhJXFetRbrQCGB
	9MSS1OzU1ILUovii0pzU4kOMTBycUg2MSbO2GTAHbmWa+oT/TP++ra09bqvvLm9b06a+Z7a8
	2OKcSYbWhzcxeuqs/xz569SJKyy5/KcS7haqnLxyXPZ6P8+0Mwxzq0zq73e6aT6RWq56sMm2
	vK62cWfQtr2bmZgk5t9/V/ugh93Kzn+Oobnp9bnXUqKZWAITrqVv2jSv0XaOo/e1dKYMJZbi
	jERDLeai4kQA8nSb48ICAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphleLIzCtJLcpLzFFi42I5/e+xoO75Dq8gg87XGhZTHz5hs/g35Qa7
	xeVdc9gsbjeuYLNY/vY/mwOrx6ZVnWweLyf+ZvPo27KK0ePzJrkAlqgGRpuM1MSU1CKF1Lzk
	/JTMvHRbJe/geOd4UzMDQ11DSwtzJYW8xNxUWyUXnwBdt8wcoMVKCmWJOaVAoYDE4mIlfTtM
	E0JD3HQtYBojdH1DguB6jAzQQMIaxoyvn3sZC+bxVXyftp+lgXEzdxcjJ4eEgInE5ufXGCFs
	MYkL99azgdhCAtMZJRo+63YxcgHZrxglzt88zQ6S4BXQkvh6fzULiM0ioCrx581ysDgbUHz/
	ixtgzaICYRIrp19hgagXlPgx+R6YLSJgITFlyS3mLkYODmaBUokfS4NBwsICwRLvdvYwQexq
	YpL4uO8hM0iCU8BBomvGTzCbWUBHYn/rNDYIW15i85q3zBMYBWYhWTELSdksJGULGJlXMYqm
	FiQXFCel5xrqFSfmFpfmpesl5+duYgTH7TOpHYwrGywOMQpwMCrx8BrUewYJsSaWFVfmHmKU
	4GBWEuFtq/AKEuJNSaysSi3Kjy8qzUktPsSYDAyBicxSosn5wJSSVxJvaGxiZmRpZG5oYWRs
	TpqwkjjvgVbrQCGB9MSS1OzU1ILUIpgtTBycUg2M4a9qwix/mJ+aO2n1sYaAbfvND5rN7mB+
	5jLpUSinq/XO+Tye+rWq+QGOwSpev7pXrCszNhF5IrnP6ZF7RM75DY7djz0aZDXnXm7u4OjM
	iXb/eWrdkTfbHhUylE7oubFAbf667oS+o+Gp6X+0dzns/dbvvMxvksWy88ptC19vvXRN9sHl
	hYsuKrEUZyQaajEXFScCADqJsb8fAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/01/2013 05:22 PM, Charles Keepax wrote:
> On Tue, Oct 01, 2013 at 08:04:09AM +0900, Chanwoo Choi wrote:
>> On 09/30/2013 06:52 PM, Charles Keepax wrote:
>>> On Mon, Sep 30, 2013 at 08:37:30AM +0900, Chanwoo Choi wrote:
>>>> No, extcon-arizona driver don't currently support DT to get platform data.
>>>> I cannot find some dt function to parse data from dts file.
>>>> You have to implement extcon-arizona driver by using DT binding style
>>>> to get platform data. I think this patch is not necessary.
>>>
>>> Currently the Arizona MFD driver reads the device tree
>>> information and populates the pdata structure, this happens in
>>> drivers/mfd/arizona-core.c. Then the various drivers just use the
>>> pdata as normal.
>>>
>>> Admittedly, at the moment we don't parse any data for the extcon
>>> driver but without this patch we will attempt to use a NULL
>>> pointer on device tree systems.
>>>
>>> I would also be happy to implement this as a NULL check on the
>>> pdata when we use it if that is preferable? But since we have the
>>> cached pdata seems we might as well use it.
>>>
>>
>> I find below pdata list for extcon-arizona driver.
>> But, drivers/mfd/arizona-core.c don't parse dt data for below pdata list
>> of extcon-arizona. Did you test this patch for extcon-arizona operation?
> 
> The extcon driver will function using its default settings if
> blank pdata is provided, so it has been tested with those
> settings. I am presently working on device tree bindings for the
> pdata for the extcon driver which I hope to send a new spin of
> upstream this week or next, so it has been tested against the
> first version of those patches as well.

OK,
I check arizona->pdata including the pdata field for extcon-arizona.

Applied it.

Thanks,
Chanwoo Choi

