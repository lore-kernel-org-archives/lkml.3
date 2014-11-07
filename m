Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752088AbaKGLdS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 06:33:18 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:30162 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751681AbaKGLdL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 06:33:11 -0500
X-AuditID: cbfee68d-f79296d000004278-51-545cadf43961
From: Yadwinder Singh Brar <yadi.brar@samsung.com>
To: "'Eduardo Valentin'" <edubezval@gmail.com>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        rui.zhang@intel.com, amit.daniel@samsung.com, viresh.kumar@linaro.org,
        linux-samsung-soc@vger.kernel.org, yadi.brar01@gmail.com
References: <1415189785-18593-1-git-send-email-yadi.brar@samsung.com>
 <20141105204638.GB5243@developer>
 <004c01cff9b0$6b450740$41cf15c0$%brar@samsung.com>
 <20141106074907.GA8176@developer>
In-reply-to: <20141106074907.GA8176@developer>
Subject: RE: [PATCH] thermal: cpu_cooling: Update always cpufreq policy with
 thermal constraints
Date: Fri, 07 Nov 2014 17:03:05 +0530
Message-id: <001001cffa7e$a8419f90$f8c4deb0$%brar@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac/58x+g58Wj2IGmTa22pzE1L4UUtQAhqZJg
Content-language: en-us
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFIsWRmVeSWpSXmKPExsWyRsSkVvfL2pgQg46v1hYNV0Ms5l+5xmpx
	edccNovPvUcYLWac38dk8eRhH5vFxq8eFnN/N7I6cHjsnHWX3WPxnpdMHneu7WHz6NuyitHj
	8ya5ANYoLpuU1JzMstQifbsErowzvyezFHz1qOh51sHewLjZoouRk0NCwETi0pWv7BC2mMSF
	e+vZuhi5OIQEljJKHL3wkBWm6MC1HVCJ6YwSV/++ZIVwfjJKnJx1ASjDwcEmYCxx9iY3SIOI
	gI7EjbebmEBqmAX2M0o8f3ORCaLhEKPEy+ZDzCBVnAJ6Ek9vnWYBsYUFkiS6519iBLFZBFQl
	ps5/DbaaV8BO4vrBw4wQtqDEj8n3wOqZBbQk1u88zgRhy0tsXvOWGeQICQF1iUd/dUFMEQEj
	iVVThCEqxCUmPXjIDnKChMBHdol501azQawSkPg2+RALRKusxKYDzBAPS0ocXHGDZQKjxCwk
	i2chWTwLyeJZSFYsYGRZxSiaWpBcUJyUXmSoV5yYW1yal66XnJ+7iREYxaf/PevdwXj7gPUh
	RgEORiUe3hu8MSFCrIllxZW5hxhNgS6ayCwlmpwPTBV5JfGGxmZGFqYmpsZG5pZmSuK8ilI/
	g4UE0hNLUrNTUwtSi+KLSnNSiw8xMnFwSjUw9uvG3b17b47zwo4JcfWBl+eczFCwn6jxuLAk
	YKGK5cyfWofWl/7OXOmt+us0s+1aU96OjL9qk06Kl5urhfGsuldlZmNXa3u92/AgJ/vanov8
	hW8MV27V4ruqKjmvetPToOdrTvk9Fo2u5pN1suM6EXWvJWCu1ubb3Bc/r7vkz2jSPWVy3eZ/
	SizFGYmGWsxFxYkAdtiJFt0CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprCKsWRmVeSWpSXmKPExsVy+t9jQd0va2NCDGZ8NrRouBpiMf/KNVaL
	y7vmsFl87j3CaDHj/D4miycP+9gsNn71sJj7u5HVgcNj56y77B6L97xk8rhzbQ+bR9+WVYwe
	nzfJBbBGNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl
	5gCdoqRQlphTChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGHMOPN7MkvBV4+Knmcd
	7A2Mmy26GDk5JARMJA5c28EGYYtJXLi3Hsjm4hASmM4ocfXvS1YI5yejxMlZF4AyHBxsAsYS
	Z29ygzSICOhI3Hi7iQmkhllgP6PE8zcXmSAaDjFKvGw+xAxSxSmgJ/H01mkWEFtYIEmie/4l
	RhCbRUBVYur816wgNq+AncT1g4cZIWxBiR+T74HVMwtoSazfeZwJwpaX2LzmLTPIERIC6hKP
	/uqCmCICRhKrpghDVIhLTHrwkH0Co9AsJINmIRk0C8mgWUhaFjCyrGIUTS1ILihOSs810itO
	zC0uzUvXS87P3cQIThHPpHcwrmqwOMQowMGoxMN7gzcmRIg1say4MhfoVw5mJRHe2auBQrwp
	iZVVqUX58UWlOanFhxhNgf6cyCwlmpwPTF95JfGGxibmpsamliYWJmaWSuK8B1utA4UE0hNL
	UrNTUwtSi2D6mDg4pRoYIzKvqm+pm8liIGKjbCm0RTrCwN1/wvwuq/sSWmxmRzOC/nvWP5kk
	vGDDIZ9kq/vXPXZOy5deG9bHEn9I0F1NmPvdfBvtG/WXNrRYdL16+Ex04qK8i2fEquuuNK3P
	+3vHaNXlqmjuvXF/pm2L2zn5rPid2FO1s6fcv+M99Xso06SbE9Na76gaK7EUZyQaajEXFScC
	ANoG9p0nAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Eduardo Valentin, 

On Thursday, November 06, 2014 1:19 PM, Eduardo Valentin wrote:
> Hello Yadwinder,
> 
> On Thu, Nov 06, 2014 at 04:26:27PM +0530, Yadwinder Singh Brar wrote:
> > Hello Eduardo Valentin,
> >
> > On Thursday, November 06, 2014 2:17 AM, Eduardo Valentin wrote:
> > > Hello Yadwinder,
> > >
> > > On Wed, Nov 05, 2014 at 05:46:25PM +0530, Yadwinder Singh Brar
> wrote:
> > > > Existing code updates cupfreq policy only while executing
> > > > cpufreq_apply_cooling() function (i.e. when notify_device !=
> > > NOTIFY_INVALID).
> > >
> > > Correct. The case you mention is when we receive a notification
> from
> > > cpufreq. But also, updates the cpufreq policy when the cooling
> > > device changes state, a call from thermal framework.
> >
> > I mentioned thermal framework case only, existing code updates
> cupfreq
> > policy only when (notify_device != NOTIFY_INVALID), which happens
> only
> > when notification comes from cpufreq_update_policy while changing
> > cooling device's state(i.e. cpufreq_apply_cooling()).
> > In case of other notifications notify_device is always
> NOTIFY_INVALID.
> 
> I see your point.
> 
> >
> > >
> > > > It doesn't apply constraints when cpufreq policy update happens
> > > > from any other place but it should update the cpufreq policy with
> > > > thermal constraints every time when there is a cpufreq policy
> > > > update, to keep state of cpufreq_cooling_device and max_feq of
> > > > cpufreq policy in
> > > sync.
> > >
> > > I am not sure I follow you here. Can you please elaborate on 'any
> > > other places'? Could you please mention (also in the commit log)
> > > what are the case the current code does not cover? For instance,
> the
> > > cpufreq_apply_cooling gets called on notification coming from
> > > thermal subsystem, and for changes in cpufreq subsystem,
> > > cpufreq_thermal_notifier is called.
> > >
> >
> > "Other places" mean possible places from where
> cpufreq_update_policy()
> > can be called at runtime, an instance in present kernel is
> cpufreq_resume().
> > But since cpufreq_update_policy() is an exposed API, I think for
> > robustness, generic cpu cooling should be able to take care of any
> > possible case(in future as well).
> >
> 
> OK. I understand now. Can you please improve your commit message by
> adding the descriptions you mentioned here?
>

Sure, will post updated patch.
 
> > > >
> > > > This patch modifies code to maintain a global cpufreq_dev_list
> and
> > > get
> > > > corresponding cpufreq_cooling_device for policy's cpu from
> > > > cpufreq_dev_list when there is any policy update.
> > >
> > > OK. Please give real examples of when the current code fails to
> > > catch the event.
> > >
> >
> > While resuming cpufreq updates cpufreq_policy for boot cpu and it
> > restores default policy->usr_policy irrespective of cooling device's
> > cpufreq_state since notification gets missed because (notify_device
> ==
> > NOTIFY_INVALID).
> > Another thing, Rather I would say an issue, I observed is that
> > Userspace is able to change max_freq irrespective of cooling device's
> > state, as notification gets missed.
> >
> 
> Include also the examples above you gave.
> 
> Have you verified if with this patch the issue with userland goes away?
> 

Yes, Userspace is not able to set scaling_max_freq more than the
cooling device constraint(cpufreq_val).

But I have a question here, Is it OK to silently set scaling_max_freq
less than the requested value from userspace ? 

> > >
> > > BR,
> > >
> > > Eduardo Valentin
> > >
> > > >
> > > > Signed-off-by: Yadwinder Singh Brar <yadi.brar@samsung.com>
> > > > ---
> > > >  drivers/thermal/cpu_cooling.c |   37 ++++++++++++++++++++-------
> ----
> > > ------
> > > >  1 files changed, 20 insertions(+), 17 deletions(-)
> > > >
> > > > diff --git a/drivers/thermal/cpu_cooling.c
> > > > b/drivers/thermal/cpu_cooling.c index 1ab0018..5546278 100644
> > > > --- a/drivers/thermal/cpu_cooling.c
> > > > +++ b/drivers/thermal/cpu_cooling.c
> > > > @@ -50,15 +50,14 @@ struct cpufreq_cooling_device {
> > > >  	unsigned int cpufreq_state;
> > > >  	unsigned int cpufreq_val;
> > > >  	struct cpumask allowed_cpus;
> > > > +	struct list_head node;
> > > >  };
> > > >  static DEFINE_IDR(cpufreq_idr);
> > > >  static DEFINE_MUTEX(cooling_cpufreq_lock);
> > > >
> > > >  static unsigned int cpufreq_dev_count;
> > > >
> > > > -/* notify_table passes value to the CPUFREQ_ADJUST callback
> > > function.
> > > > */ -#define NOTIFY_INVALID NULL -static struct
> > > > cpufreq_cooling_device *notify_device;
> > > > +static LIST_HEAD(cpufreq_dev_list);
> > > >
> > > >  /**
> > > >   * get_idr - function to get a unique id.
> > > > @@ -287,15 +286,12 @@ static int cpufreq_apply_cooling(struct
> > > > cpufreq_cooling_device *cpufreq_device,
> > > >
> > > >  	cpufreq_device->cpufreq_state = cooling_state;
> > > >  	cpufreq_device->cpufreq_val = clip_freq;
> > > > -	notify_device = cpufreq_device;
> > > >
> > > >  	for_each_cpu(cpuid, mask) {
> > > >  		if (is_cpufreq_valid(cpuid))
> > > >  			cpufreq_update_policy(cpuid);
> > > >  	}
> > > >
> > > > -	notify_device = NOTIFY_INVALID;
> > > > -
> > > >  	return 0;
> > > >  }
> > > >
> > > > @@ -316,21 +312,27 @@ static int cpufreq_thermal_notifier(struct
> > > > notifier_block *nb,  {
> > > >  	struct cpufreq_policy *policy = data;
> > > >  	unsigned long max_freq = 0;
> > > > +	struct cpufreq_cooling_device *cpufreq_dev;
> > > >
> > > > -	if (event != CPUFREQ_ADJUST || notify_device ==
> NOTIFY_INVALID)
> > > > +	if (event != CPUFREQ_ADJUST)
> > > >  		return 0;
> > > >
> > > > -	if (cpumask_test_cpu(policy->cpu, &notify_device-
> >allowed_cpus))
> > > > -		max_freq = notify_device->cpufreq_val;
> > > > -	else
> > > > -		return 0;
> > > > +	mutex_lock(&cooling_cpufreq_lock);
> > > > +	list_for_each_entry(cpufreq_dev, &cpufreq_dev_list, node) {
> > > > +		if (!cpumask_test_cpu(policy->cpu,
> > > > +					&cpufreq_dev->allowed_cpus))
> > > > +			continue;
> > > >
> > > > -	/* Never exceed user_policy.max */
> > > > -	if (max_freq > policy->user_policy.max)
> > > > -		max_freq = policy->user_policy.max;
> > > > +		max_freq = cpufreq_dev->cpufreq_val;
> > > >
> >
> > I think I missed to post updated patch, Actually it should be :
> >
> > +	if (!cpufreq_dev->cpufreq_val)
> > +		cpufreq_dev->cpufreq_val = get_cpu_frequency(
> > +
> > cpumask_any(&cpufreq_dev->allowed_cpus),
> > +							cpufreq_dev->state);
> > +	max_freq = cpufreq_dev->cpufreq_val;
> >
> > I will send another version of patch.
> 
> ok.
> 
> >
> > > > -	if (policy->max != max_freq)
> > > > -		cpufreq_verify_within_limits(policy, 0, max_freq);
> > > > +		/* Never exceed user_policy.max */
> > > > +		if (max_freq > policy->user_policy.max)
> > > > +			max_freq = policy->user_policy.max;
> > > > +
> > > > +		if (policy->max != max_freq)
> > > > +			cpufreq_verify_within_limits(policy, 0,
> max_freq);
> > > > +	}
> > > > +	mutex_unlock(&cooling_cpufreq_lock);
> > >
> > > So, the problem is when we have several cpu cooling devices and you
> > > want to search for the real max among the existing cpu cooling
> devices?
> > >
> 
> By max, I meant the maximun constraint (lowest frequency).
> 
> >
> > Sorry I didn't get your question completely I think.
> > No, above code doesn't find max among existing cooling devices.
> > It simply finds cooling device corresponding to policy's cpu and
> > applies updates policy accordingly.
> 
> yeah, that's what it does, but for all matching devices, correct?
> 

Exactly !! though in existing kernel we don't have multiple devices yet.

> well, in fact your code is going through all cpu cooling devices that
> match the cpu ids and applying their max allowed freq, when they differ
> from policy->max. cpufreq_verify_within_limits will update the policy
> if your request is lower than policy max. Then you will, in the end,
> apply the lowest among the existing matching cpu cooling devices.
> 

yes ..

> Which, turns out to be the correct thing to do, since we are not doing
> it per request in single cooling devices.
> 
> Can you please also add a comment about this strategy?
> 

Sure.

Best Regards,
Yadwinder

> 
> BR,
> 
> Eduardo Valentin
> 
> >
> > Regards,
> > Yadwinder
> >
> > > >  	return 0;
> > > >  }
> > > > @@ -486,7 +488,7 @@ __cpufreq_cooling_register(struct device_node
> > > *np,
> > > >
> 	cpufreq_register_notifier(&thermal_cpufreq_notifier_block,
> > > >  					  CPUFREQ_POLICY_NOTIFIER);
> > > >  	cpufreq_dev_count++;
> > > > -
> > > > +	list_add(&cpufreq_dev->node, &cpufreq_dev_list);
> > > >  	mutex_unlock(&cooling_cpufreq_lock);
> > > >
> > > >  	return cool_dev;
> > > > @@ -549,6 +551,7 @@ void cpufreq_cooling_unregister(struct
> > > > thermal_cooling_device *cdev)
> > > >
> > > >  	cpufreq_dev = cdev->devdata;
> > > >  	mutex_lock(&cooling_cpufreq_lock);
> > > > +	list_del(&cpufreq_dev->node);
> > > >  	cpufreq_dev_count--;
> > > >
> > > >  	/* Unregister the notifier for the last cpufreq cooling
> device
> > > > */
> > > > --
> > > > 1.7.0.4
> > > >
> >

