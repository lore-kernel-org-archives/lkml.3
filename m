Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751339AbaLPBPX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 20:15:23 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:54487 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868AbaLPBPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 20:15:20 -0500
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee691-f79b86d000004a5a-34-548f87a4d6c0
Content-transfer-encoding: 8BIT
Message-id: <548F87A4.5060000@samsung.com>
Date: Tue, 16 Dec 2014 10:15:16 +0900
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
Subject: Re: [RFC PATCHv3 2/7] devfreq: event: Add the list of supported
 devfreq-event type
References: <1418372852-12454-1-git-send-email-cw00.choi@samsung.com>
 <1418372852-12454-3-git-send-email-cw00.choi@samsung.com>
 <1418655206.20866.6.camel@AMDC1943>
In-reply-to: <1418655206.20866.6.camel@AMDC1943>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPIsWRmVeSWpSXmKPExsWyRsSkSHdJe3+IwbI5JhaP1yxmstg4Yz2r
	xfwj51gtXr8wtOhdcJXN4mzTG3aLTY+vsVpc3jWHzeJz7xFGixnn9zFZ3G5cwWbxeMVbdotV
	u/4wOvB67Jx1l91j8Z6XTB6bl9R79G1ZxejxeZNcAGsUl01Kak5mWWqRvl0CV8aL5U/ZCg5L
	V6w91sHWwHhOrIuRk0NCwETi5swTLBC2mMSFe+vZuhi5OIQEljJKfF+1hh2m6GD/HKjEdEaJ
	gwtWMYIkeAUEJX5MvgfUzcHBLCAvceRSNkiYWUBdYtK8RcwgtpDAa0aJbftZIMq1JJa+fQhm
	swioSqxcfgSshg0ovv/FDTYQW1QgTGLl9CtgNSIChhIHd29nAtnLLHCdSaLn4kEmkISwQKzE
	rJZdrBAHLWeUePP+FytIglPAQOLitBOMIAkJgb/sEotXvmeCWCcg8W3yIbBLJQRkJTYdYIb4
	TFLi4IobLBMYxWYh+WcWwj+zkPyzgJF5FaNoakFyQXFSepGpXnFibnFpXrpecn7uJkZgvJ7+
	92ziDsb7B6wPMQpwMCrx8AYU9ocIsSaWFVfmHmI0BTpiIrOUaHI+MCnklcQbGpsZWZiamBob
	mVuaKYnz6kj/DBYSSE8sSc1OTS1ILYovKs1JLT7EyMTBKdXAOLuXfad+1I6XifqWIsEsPHXx
	cR3rryxwdHttIteQGm3mdF342Of187alFm19byH7dfMZjt+m4S6qLia/4jpD81r8ggNu/jYu
	1NA6LLg0UIA9vTBFYvnkpANMr8vuszg7rulc1XbRb0bReudNfJO1kx3amiZfOhW8Wbf7y945
	VVm/J8mKzvmpxFKckWioxVxUnAgAUgni2tICAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupkleLIzCtJLcpLzFFi42I5/e+xoO6S9v4Qg6UvtSwer1nMZLFxxnpW
	i/lHzrFavH5haNG74CqbxdmmN+wWmx5fY7W4vGsOm8Xn3iOMFjPO72OyuN24gs3i8Yq37Bar
	dv1hdOD12DnrLrvH4j0vmTw2L6n36NuyitHj8ya5ANaoBkabjNTElNQihdS85PyUzLx0WyXv
	4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKAblRTKEnNKgUIBicXFSvp2mCaEhrjpWsA0
	Ruj6hgTB9RgZoIGENYwZL5Y/ZSs4LF2x9lgHWwPjObEuRk4OCQETiYP9c9ggbDGJC/fWA9lc
	HEIC0xklDi5YxQiS4BUQlPgx+R5LFyMHB7OAvMSRS9kgYWYBdYlJ8xYxg9hCAq8ZJbbtZ4Eo
	15JY+vYhmM0ioCqxcvkRsBo2oPj+FzfAdokKhEmsnH4FrEZEwFDi4O7tTCB7mQWuM0n0XDzI
	BJIQFoiVmNWyixXioOWMEm/e/2IFSXAKGEhcnHaCcQKjwCwk981CuG8WkvsWMDKvYhRNLUgu
	KE5KzzXSK07MLS7NS9dLzs/dxAhOBs+kdzCuarA4xCjAwajEwxtY2B8ixJpYVlyZe4hRgoNZ
	SYQ3KQsoxJuSWFmVWpQfX1Sak1p8iNEU6L2JzFKiyfnARJVXEm9obGJmZGlkbmhhZGyuJM6r
	ZN8WIiSQnliSmp2aWpBaBNPHxMEp1cCYdt5B9+6TmWuuMp8+0sDzQ5utvTG08ei/l6eqK6dt
	1lRcO6EyzXwv56HQrUe/Feu8PGEoZ2H5n0mXgV/Faa/VwXoOuRkxOUnbju+bMXnjhG+G2T3F
	E0SaXzd/28b795dS133GTXn7Tx24kRBrYr+j6cuRtjferVss4lVdSzgX97oFc+bfSjBRYinO
	SDTUYi4qTgQAQpdxShwDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Krzysztof,

On 12/15/2014 11:53 PM, Krzysztof Kozlowski wrote:
> On pią, 2014-12-12 at 17:27 +0900, Chanwoo Choi wrote:
>> This patch adds the list of supported devfreq-event type as following.
>> Each devfreq-event device driver would support the various devfreq-event type
>> for devfreq governor at the same time.
>> - DEVFREQ_EVENT_TYPE_RAW_DATA
>> - DEVFREQ_EVENT_TYPE_UTILIZATION
>> - DEVFREQ_EVENT_TYPE_BANDWIDTH
>> - DEVFREQ_EVENT_TYPE_LATENCY
>>
>> Cc: MyungJoo Ham <myungjoo.ham@samsung.com>
>> Cc: Kyungmin Park <kyungmin.park@samsung.com>
>> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
>> ---
>>  drivers/devfreq/devfreq-event.c | 44 +++++++++++++++++++++++++++++++++++++----
>>  include/linux/devfreq.h         | 29 ++++++++++++++++++++++-----
>>  2 files changed, 64 insertions(+), 9 deletions(-)
>>
>> diff --git a/drivers/devfreq/devfreq-event.c b/drivers/devfreq/devfreq-event.c
>> index eaf59c1..9444f93 100644
>> --- a/drivers/devfreq/devfreq-event.c
>> +++ b/drivers/devfreq/devfreq-event.c
>> @@ -29,6 +29,9 @@
>>  #include <linux/of.h>
>>  #include "governor.h"
>>  
>> +#define EVENT_TYPE_RAW_DATA_MAX		U64_MAX
>> +#define EVENT_TYPE_UTILIZATION_MAX	100
>> +
>>  static struct class *devfreq_event_class;
>>  
>>  /* The list of all devfreq event list */
>> @@ -144,7 +147,8 @@ EXPORT_SYMBOL_GPL(devfreq_event_is_enabled);
>>   * Note that this function set the event to the devfreq-event device to start
>>   * for getting the event data which could be various event type.
>>   */
>> -int devfreq_event_set_event(struct devfreq_event_dev *edev)
>> +int devfreq_event_set_event(struct devfreq_event_dev *edev,
>> +				enum devfreq_event_type type)
>>  {
>>  	int ret;
>>  
>> @@ -158,7 +162,15 @@ int devfreq_event_set_event(struct devfreq_event_dev *edev)
>>  		return -EPERM;
>>  
>>  	mutex_lock(&edev->lock);
>> -	ret = edev->desc->ops->set_event(edev);
>> +
>> +	if ((edev->desc->type & type) == 0) {
>> +		dev_err(&edev->dev, "unsupported of devfreq-event type\n");
>> +		mutex_unlock(&edev->lock);
>> +		return -EINVAL;
>> +	}
>> +
>> +	ret = edev->desc->ops->set_event(edev, type);
>> +
>>  	mutex_unlock(&edev->lock);
>>  
>>  	return ret;
>> @@ -174,7 +186,9 @@ EXPORT_SYMBOL_GPL(devfreq_event_set_event);
>>   * current event data and total_event should be stored in second parameter
>>   * (total_event).
>>   */
>> -u64 devfreq_event_get_event(struct devfreq_event_dev *edev, u64 *total_event)
>> +u64 devfreq_event_get_event(struct devfreq_event_dev *edev,
>> +				enum devfreq_event_type type,
>> +				u64 *total_event)
>>  {
>>  	u64 event;
>>  
>> @@ -190,7 +204,27 @@ u64 devfreq_event_get_event(struct devfreq_event_dev *edev, u64 *total_event)
>>  		return 0;
>>  
>>  	mutex_lock(&edev->lock);
>> -	event = edev->desc->ops->get_event(edev, total_event);
>> +
>> +	if ((edev->desc->type & type) == 0) {
>> +		dev_err(&edev->dev, "unsupported of devfreq-event type\n");
>> +		return -EINVAL;
>> +	}
>> +
>> +	event = edev->desc->ops->get_event(edev, type, total_event);
>> +
>> +	switch (type) {
>> +	case DEVFREQ_EVENT_TYPE_RAW_DATA:
>> +	case DEVFREQ_EVENT_TYPE_BANDWIDTH:
>> +	case DEVFREQ_EVENT_TYPE_LATENCY:
>> +		if ((event > *total_event)
>> +			|| ((event > EVENT_TYPE_RAW_DATA_MAX) ||
>> +				*total_event > EVENT_TYPE_RAW_DATA_MAX))
>> +			event = 0;
> 
> missing break here.

My mistake. I'll add it and 'default' case statement.

Best Regards,
Chanwoo Choi
