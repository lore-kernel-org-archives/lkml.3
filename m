Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751247AbaKFK4v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 05:56:51 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:26325 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750955AbaKFK4s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 05:56:48 -0500
X-AuditID: cbfee691-f79b86d000004a5a-d2-545b53eda279
From: Yadwinder Singh Brar <yadi.brar@samsung.com>
To: "'Eduardo Valentin'" <edubezval@gmail.com>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        rui.zhang@intel.com, amit.daniel@samsung.com, viresh.kumar@linaro.org,
        linux-samsung-soc@vger.kernel.org, yadi.brar01@gmail.com
References: <1415189785-18593-1-git-send-email-yadi.brar@samsung.com>
 <20141105204638.GB5243@developer>
In-reply-to: <20141105204638.GB5243@developer>
Subject: RE: [PATCH] thermal: cpu_cooling: Update always cpufreq policy with
 thermal constraints
Date: Thu, 06 Nov 2014 16:26:27 +0530
Message-id: <004c01cff9b0$6b450740$41cf15c0$%brar@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac/5OZ44aja5hOCMRaKDYLCr3sdN3QAaugUw
Content-language: en-us
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrBIsWRmVeSWpSXmKPExsWyRsSkWvdtcHSIQW8Tn0XD1RCL+VeusVpc
	3jWHzeJz7xFGixnn9zFZPHnYx2ax8auHxdzfjawOHB47Z91l91i85yWTx51re9g8+rasYvT4
	vEkugDWKyyYlNSezLLVI3y6BK+P5jQtsBQ9NK14du8vawLhZu4uRk0NCwETi49k/zBC2mMSF
	e+vZuhi5OIQEljJKTDtzgxWm6Ov6BewgtpDAIkaJ6/esIIp+Mkr8uHkBqJuDg03AWOLsTW6Q
	GhEBHYkbbzcxgdQwC+xnlHj+5iITRHOmxMM5P8GGcgroSZz/8RQsLiyQJNE9/xIjiM0ioCqx
	8MI1sGW8AnYSn1ccYoawBSV+TL7HAmIzC2hJrN95nAnClpfYvOYt2A0SAuoSj/7qgpgiAkYS
	e87rQlSIS0x68JAd5BwJga/sEm877zJDrBKQ+Db5EAtEq6zEpgPQcJCUOLjiBssERolZSBbP
	QrJ4FpLFs5CsWMDIsopRNLUguaA4Kb3IVK84Mbe4NC9dLzk/dxMjMIJP/3s2cQfj/QPWhxgF
	OBiVeHgFT0SFCLEmlhVX5h5iNAW6aCKzlGhyPjBN5JXEGxqbGVmYmpgaG5lbmimJ8+pI/wwW
	EkhPLEnNTk0tSC2KLyrNSS0+xMjEwSnVwGje+W929VbOmd9kZpbonVlt0m3eH7P+0WV/p8Rs
	ufi9mXwSbre1pUv/Of44XXEqU+OBXLjpzkOHV8zbz/TxdVbxAcYX0kde9tY01G1i0/C4K97D
	rnTjtfcqtzO+Mp9XCq94kneHaXJJR62FzRNxoV3+Txf+CTJ5GlAZXi84OfHGieZjEiuOH1Ni
	Kc5INNRiLipOBADxBH4w2wIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprEKsWRmVeSWpSXmKPExsVy+t9jAd23wdEhBj82sls0XA2xmH/lGqvF
	5V1z2Cw+9x5htJhxfh+TxZOHfWwWG796WMz93cjqwOGxc9Zddo/Fe14yedy5tofNo2/LKkaP
	z5vkAlijGhhtMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0y
	c4BOUVIoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jBmPL9xga3goWnFq2N3
	WRsYN2t3MXJySAiYSHxdv4AdwhaTuHBvPRuILSSwiFHi+j2rLkYuIPsno8SPmxeYuxg5ONgE
	jCXO3uQGqRER0JG48XYTE0gNs8B+Ronnby4yQTRnSjyc85MVxOYU0JM4/+MpWFxYIEmie/4l
	RhCbRUBVYuGFa2CLeQXsJD6vOMQMYQtK/Jh8jwXEZhbQkli/8zgThC0vsXnNW7AbJATUJR79
	1QUxRQSMJPac14WoEJeY9OAh+wRGoVlIBs1CMmgWkkGzkLQsYGRZxSiaWpBcUJyUnmuoV5yY
	W1yal66XnJ+7iRGcHp5J7WBc2WBxiFGAg1GJh3fH0agQIdbEsuLK3EOMEhzMSiK81v7RIUK8
	KYmVValF+fFFpTmpxYcYTYH+nMgsJZqcD0xdeSXxhsYm5qbGppYmFiZmlkrivAdarQOFBNIT
	S1KzU1MLUotg+pg4OKUaGBuCE5+r3rbefK70m8GJ/F0iVZt7jpseYzQrmsqt7bichflu+d8f
	L8/Er5rmurb6/j+5ZNPKD/t3sAjanTZZevCXVdwO8/MvwhKCE25yffYyylyzJ0Oo4PeTqMcb
	T+179IdR9WiggnWJ1MveeTeuP1y2VmrC14CKdn2WzI0Blk7rxf6Jb3+UPkeJpTgj0VCLuag4
	EQA/BGvtJQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Eduardo Valentin,

On Thursday, November 06, 2014 2:17 AM, Eduardo Valentin wrote:
> Hello Yadwinder,
> 
> On Wed, Nov 05, 2014 at 05:46:25PM +0530, Yadwinder Singh Brar wrote:
> > Existing code updates cupfreq policy only while executing
> > cpufreq_apply_cooling() function (i.e. when notify_device !=
> NOTIFY_INVALID).
> 
> Correct. The case you mention is when we receive a notification from
> cpufreq. But also, updates the cpufreq policy when the cooling device
> changes state, a call from thermal framework.

I mentioned thermal framework case only, existing code updates
cupfreq policy only when (notify_device != NOTIFY_INVALID),
which happens only when notification comes from cpufreq_update_policy
while changing cooling device's state(i.e. cpufreq_apply_cooling()).
In case of other notifications notify_device is always NOTIFY_INVALID.

> 
> > It doesn't apply constraints when cpufreq policy update happens from
> > any other place but it should update the cpufreq policy with thermal
> > constraints every time when there is a cpufreq policy update, to keep
> > state of cpufreq_cooling_device and max_feq of cpufreq policy in
> sync.
> 
> I am not sure I follow you here. Can you please elaborate on 'any other
> places'? Could you please mention (also in the commit log) what are the
> case the current code does not cover? For instance, the
> cpufreq_apply_cooling gets called on notification coming from thermal
> subsystem, and for changes in cpufreq subsystem,
> cpufreq_thermal_notifier is called.
> 

"Other places" mean possible places from where cpufreq_update_policy()
can be called at runtime, an instance in present kernel is cpufreq_resume().
But since cpufreq_update_policy() is an exposed API, I think
for robustness, generic cpu cooling should be able to take care of any
possible case(in future as well).

> >
> > This patch modifies code to maintain a global cpufreq_dev_list and
> get
> > corresponding cpufreq_cooling_device for policy's cpu from
> > cpufreq_dev_list when there is any policy update.
> 
> OK. Please give real examples of when the current code fails to catch
> the event.
> 

While resuming cpufreq updates cpufreq_policy for boot cpu and it
restores default policy->usr_policy irrespective of cooling device's
cpufreq_state since notification gets missed because (notify_device ==
NOTIFY_INVALID).
Another thing, Rather I would say an issue, I observed is that
Userspace is able to change max_freq irrespective of cooling
device's state, as notification gets missed.
  
> 
> BR,
> 
> Eduardo Valentin
> 
> >
> > Signed-off-by: Yadwinder Singh Brar <yadi.brar@samsung.com>
> > ---
> >  drivers/thermal/cpu_cooling.c |   37 ++++++++++++++++++++-----------
> ------
> >  1 files changed, 20 insertions(+), 17 deletions(-)
> >
> > diff --git a/drivers/thermal/cpu_cooling.c
> > b/drivers/thermal/cpu_cooling.c index 1ab0018..5546278 100644
> > --- a/drivers/thermal/cpu_cooling.c
> > +++ b/drivers/thermal/cpu_cooling.c
> > @@ -50,15 +50,14 @@ struct cpufreq_cooling_device {
> >  	unsigned int cpufreq_state;
> >  	unsigned int cpufreq_val;
> >  	struct cpumask allowed_cpus;
> > +	struct list_head node;
> >  };
> >  static DEFINE_IDR(cpufreq_idr);
> >  static DEFINE_MUTEX(cooling_cpufreq_lock);
> >
> >  static unsigned int cpufreq_dev_count;
> >
> > -/* notify_table passes value to the CPUFREQ_ADJUST callback
> function.
> > */ -#define NOTIFY_INVALID NULL -static struct cpufreq_cooling_device
> > *notify_device;
> > +static LIST_HEAD(cpufreq_dev_list);
> >
> >  /**
> >   * get_idr - function to get a unique id.
> > @@ -287,15 +286,12 @@ static int cpufreq_apply_cooling(struct
> > cpufreq_cooling_device *cpufreq_device,
> >
> >  	cpufreq_device->cpufreq_state = cooling_state;
> >  	cpufreq_device->cpufreq_val = clip_freq;
> > -	notify_device = cpufreq_device;
> >
> >  	for_each_cpu(cpuid, mask) {
> >  		if (is_cpufreq_valid(cpuid))
> >  			cpufreq_update_policy(cpuid);
> >  	}
> >
> > -	notify_device = NOTIFY_INVALID;
> > -
> >  	return 0;
> >  }
> >
> > @@ -316,21 +312,27 @@ static int cpufreq_thermal_notifier(struct
> > notifier_block *nb,  {
> >  	struct cpufreq_policy *policy = data;
> >  	unsigned long max_freq = 0;
> > +	struct cpufreq_cooling_device *cpufreq_dev;
> >
> > -	if (event != CPUFREQ_ADJUST || notify_device == NOTIFY_INVALID)
> > +	if (event != CPUFREQ_ADJUST)
> >  		return 0;
> >
> > -	if (cpumask_test_cpu(policy->cpu, &notify_device->allowed_cpus))
> > -		max_freq = notify_device->cpufreq_val;
> > -	else
> > -		return 0;
> > +	mutex_lock(&cooling_cpufreq_lock);
> > +	list_for_each_entry(cpufreq_dev, &cpufreq_dev_list, node) {
> > +		if (!cpumask_test_cpu(policy->cpu,
> > +					&cpufreq_dev->allowed_cpus))
> > +			continue;
> >
> > -	/* Never exceed user_policy.max */
> > -	if (max_freq > policy->user_policy.max)
> > -		max_freq = policy->user_policy.max;
> > +		max_freq = cpufreq_dev->cpufreq_val;
> >

I think I missed to post updated patch,
Actually it should be :

+	if (!cpufreq_dev->cpufreq_val)
+		cpufreq_dev->cpufreq_val = get_cpu_frequency(
+
cpumask_any(&cpufreq_dev->allowed_cpus),
+							cpufreq_dev->state);
+	max_freq = cpufreq_dev->cpufreq_val;

I will send another version of patch.

> > -	if (policy->max != max_freq)
> > -		cpufreq_verify_within_limits(policy, 0, max_freq);
> > +		/* Never exceed user_policy.max */
> > +		if (max_freq > policy->user_policy.max)
> > +			max_freq = policy->user_policy.max;
> > +
> > +		if (policy->max != max_freq)
> > +			cpufreq_verify_within_limits(policy, 0, max_freq);
> > +	}
> > +	mutex_unlock(&cooling_cpufreq_lock);
> 
> So, the problem is when we have several cpu cooling devices and you
> want to search for the real max among the existing cpu cooling devices?
>

Sorry I didn't get your question completely I think.
No, above code doesn't find max among existing cooling devices.
It simply finds cooling device corresponding to policy's cpu
and applies updates policy accordingly.

Regards,
Yadwinder
 
> >  	return 0;
> >  }
> > @@ -486,7 +488,7 @@ __cpufreq_cooling_register(struct device_node
> *np,
> >  		cpufreq_register_notifier(&thermal_cpufreq_notifier_block,
> >  					  CPUFREQ_POLICY_NOTIFIER);
> >  	cpufreq_dev_count++;
> > -
> > +	list_add(&cpufreq_dev->node, &cpufreq_dev_list);
> >  	mutex_unlock(&cooling_cpufreq_lock);
> >
> >  	return cool_dev;
> > @@ -549,6 +551,7 @@ void cpufreq_cooling_unregister(struct
> > thermal_cooling_device *cdev)
> >
> >  	cpufreq_dev = cdev->devdata;
> >  	mutex_lock(&cooling_cpufreq_lock);
> > +	list_del(&cpufreq_dev->node);
> >  	cpufreq_dev_count--;
> >
> >  	/* Unregister the notifier for the last cpufreq cooling device */
> > --
> > 1.7.0.4
> >

