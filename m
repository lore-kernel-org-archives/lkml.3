Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750921AbaLPBYL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 20:24:11 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:56403 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745AbaLPBYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 20:24:08 -0500
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee691-f79b86d000004a5a-9d-548f89a76469
Content-transfer-encoding: 8BIT
Message-id: <548F89A6.7000202@samsung.com>
Date: Tue, 16 Dec 2014 10:23:50 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: myungjoo.ham@samsung.com, kyungmin.park@samsung.com, kgene.kim@samsung.com,
        rafael.j.wysocki@intel.com, a.kesavan@samsung.com,
        tomasz.figa@gmail.com, b.zolnierkie@samsung.com,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: Re: [RFC PATCHv3 1/7] devfreq: event: Add new devfreq_event class to
 provide basic data for devfreq governor
References: <1418372852-12454-1-git-send-email-cw00.choi@samsung.com>
 <1418372852-12454-2-git-send-email-cw00.choi@samsung.com>
 <1418655186.20866.5.camel@AMDC1943>
In-reply-to: <1418655186.20866.5.camel@AMDC1943>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLIsWRmVeSWpSXmKPExsWyRsSkUHd5Z3+IwZHd7BaP1yxmstg4Yz2r
	xfwj51gtXr8wtOhdcJXN4mzTG3aLTY+vsVpc3jWHzeJz7xFGixnn9zFZ3G5cwWbxeMVbdotV
	u/4wOvB67Jx1l91j8Z6XTB6bl9R79G1ZxejxeZNcAGsUl01Kak5mWWqRvl0CV8amtnPMBZNl
	K/792sLWwPhNvIuRk0NCwETi+fGZrBC2mMSFe+vZuhi5OIQEljJKfL/WwAJTtGP/cnYQW0hg
	EaPE7UPxIDavgKDEj8n3gGo4OJgF5CWOXMoGCTMLqEtMmreIGWLOa6DywzuZQGp4BbQkHkyK
	BKlhEVCVeLBnGdheNqDw/hc32EBsUYEwiZXTr4CtFREwlDi4ezsTyBxmgetMEj0XDzKBJIQF
	yiXOfZ7LCnHPckaJ/r1RIDangIFE/6WvYA9ICPxll9jx6xUzxDYBiW+TD4EdKiEgK7HpADPE
	X5ISB1fcYJnAKDYLyTuzEN6ZheSdBYzMqxhFUwuSC4qT0otM9YoTc4tL89L1kvNzNzECY/X0
	v2cTdzDeP2B9iFGAg1GJhzegsD9EiDWxrLgy9xCjKdARE5mlRJPzgQkhryTe0NjMyMLUxNTY
	yNzSTEmcV0f6Z7CQQHpiSWp2ampBalF8UWlOavEhRiYOTqkGxgifct/T/eznFkmoZrtsePPJ
	9kWU4IU9Lz8ndpleWZdQtHRJzFebqxPY1YSLlif/3RCrFl3y6qZtWb2ckP+kTIXrF1o+C3nu
	npjA3r5qweUVOkf0DXWnrEk5V/87rC/q1eX8sO5196wXXo7ar3c8yX3DyU0/li4Xf3X1cDuH
	qfnryG+llxZImyixFGckGmoxFxUnAgBw9j//0AIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpnleLIzCtJLcpLzFFi42I5/e+xgO6yzv4Qg5c7rC0er1nMZLFxxnpW
	i/lHzrFavH5haNG74CqbxdmmN+wWmx5fY7W4vGsOm8Xn3iOMFjPO72OyuN24gs3i8Yq37Bar
	dv1hdOD12DnrLrvH4j0vmTw2L6n36NuyitHj8ya5ANaoBkabjNTElNQihdS85PyUzLx0WyXv
	4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKAblRTKEnNKgUIBicXFSvp2mCaEhrjpWsA0
	Ruj6hgTB9RgZoIGENYwZm9rOMRdMlq3492sLWwPjN/EuRk4OCQETiR37l7ND2GISF+6tZwOx
	hQQWMUrcPhQPYvMKCEr8mHyPpYuRg4NZQF7iyKVskDCzgLrEpHmLmLsYuYDKXwOVH97JBFLD
	K6Al8WBSJEgNi4CqxIM9y1hBbDag8P4XN8DGiwqESaycfoUFxBYRMJQ4uHs7E8gcZoHrTBI9
	Fw8ygSSEBcolzn2eywpxz3JGif69USA2p4CBRP+lr2wTGAVmITlvFsJ5s5Cct4CReRWjaGpB
	ckFxUnqukV5xYm5xaV66XnJ+7iZGcCJ4Jr2DcVWDxSFGAQ5GJR7ewML+ECHWxLLiytxDjBIc
	zEoivElZQCHelMTKqtSi/Pii0pzU4kOMpkDfTWSWEk3OByapvJJ4Q2MTMyNLI3NDCyNjcyVx
	XiX7thAhgfTEktTs1NSC1CKYPiYOTqkGRnWFbVoHlBl1qx6fSTzxl9Mwsv6IzHxtF1H+/Uwu
	NmKrqtP6boedsnWx2HX+6yoB2dRJq8RSqi3nGR9suh71wXtLdBd74kwZlgDNd70pD5ZPVuY4
	FjMpdt8DtxfX+T3Suuxt7t876nkk8Irp/AcZ35ws9/SmreXJksx7aHDBNM5z4ty6F577lFiK
	MxINtZiLihMBRYddYhoDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Krzysztof,

On 12/15/2014 11:53 PM, Krzysztof Kozlowski wrote:
> On pią, 2014-12-12 at 17:27 +0900, Chanwoo Choi wrote:
>> This patch add new devfreq_event class for devfreq_event device which provide
>> raw data (e.g., memory bus utilization/GPU utilization). This raw data from
>> devfreq_event data would be used for the governor of devfreq subsystem.
>> - devfreq_event device : Provide raw data for governor of existing devfreq device
>> - devfreq device       : Monitor device state and change frequency/voltage of device
>>                          using the raw data from devfreq_event device
>>
>> The devfreq subsystem support generic DVFS(Dynamic Voltage/Frequency Scaling)
>> for Non-CPU Devices. The devfreq device would dertermine current device state
>> using various governor (e.g., ondemand, performance, powersave). After completed
>> determination of system state, devfreq device would change the frequency/voltage
>> of devfreq device according to the result of governor.
>>
>> But, devfreq governor must need basic data which indicates current device state.
>> Existing devfreq subsystem only consider devfreq device which check current system
>> state and determine proper system state using basic data. There is no subsystem
>> for device providing basic data to devfreq device.
>>
>> The devfreq subsystem must need devfreq_event device(data-provider device) for
>> existing devfreq device. So, this patch add new devfreq_event class for
>> devfreq_event device which read various basic data(e.g, memory bus utilization,
>> GPU utilization) and provide measured data to existing devfreq device through
>> standard APIs of devfreq_event class.
>>
>> The following description explains the feature of two kind of devfreq class:
>> - devfreq class (existing)
>>  : devfreq consumer device use raw data from devfreq_event device for
>>    determining proper current system state and change voltage/frequency
>>    dynamically using various governors.
>>
>> - devfreq_event class (new)
>>  : Provide measured raw data to devfreq device for governor
>>
>> Cc: MyungJoo Ham <myungjoo.ham@samsung.com>
>> Cc: Kyungmin Park <kyungmin.park@samsung.com>
>> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> 
> [...]
> 
>> +/**
>> + * devfreq_event_get_event() - Get event and total_event from devfreq-event dev.
>> + * @edev	: the devfreq-event device
>> + *
>> + * Note that this function get the calculated event data from devfreq-event dev
>> + * after stoping the progress of whole sequence of devfreq-event dev. Return
>> + * current event data and total_event should be stored in second parameter
>> + * (total_event).
>> + */
>> +u64 devfreq_event_get_event(struct devfreq_event_dev *edev, u64 *total_event)
>> +{
> 
> I think this function should return int (0 for success, negative
> otherwise) and store the "event" under pointer passed as argument.
> Why? Because:
> 1. error conditions are indicated with 'return 0' but should be 'return
> -EINVAL'
> 2. Exynos-ppmu driver returns -EINVAL.
> Checking for error conditions is in such case more complex than it
> should.

In this patchset,
the return value (event) and *total_event of devfreq_event_get_event() should
be used for busy_time/total_time of struct devfreq_dev_status (include/linux/devfreq.h).
The busy_time/total_time is 'unsigned long' type.

So, I'll modify the prototype of devfreq_event_get_event() as following by adding
new 'devfreq_event_data' structure.

struct devfreq_event_data {
	u64 event;
	u64 total_event;
};

int devfreq_event_get_event(struct devfreq_event_edev *edev, struct devfreq_event_data *edata);

Best Regards,
Chanwoo Choi



