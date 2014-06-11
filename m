Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753488AbaFKKbZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 06:31:25 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:26394 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751050AbaFKKbX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 06:31:23 -0400
X-AuditID: cbfee68e-b7fb96d000004bfc-93-53982ff8accb
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Message-id: <53982FF7.8030606@samsung.com>
Date: Wed, 11 Jun 2014 19:31:19 +0900
From: jonghwa3.lee@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120411
 Thunderbird/11.0.1
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>,
        Len Brown <len.brown@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, cw00.choi@samsung.com,
        Myungjoo Ham <myungjoo.ham@samsung.com>, jy0922.shim@samsung.com,
        inki.dae@samsung.com
Subject: Re: [RFC PATCH] PM: Domain: Add flag to assure that device's runtime
 pm callback is called at once.
References: <1402446800-4043-1-git-send-email-jonghwa3.lee@samsung.com>
 <CAPDyKFr6aoev3vSmxQOJWDGGFLWyE4eZ_0joQ45-GgZNztYdGA@mail.gmail.com>
In-reply-to: <CAPDyKFr6aoev3vSmxQOJWDGGFLWyE4eZ_0joQ45-GgZNztYdGA@mail.gmail.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrCIsWRmVeSWpSXmKPExsWyRsSkSPeH/oxgg9uTeSyuf3nOatG8eD2b
	xaT7E1gsXty7yGIxa8peJovLu+awWXzuPcJocbtxBZvF3VNH2SzOnL7EanF8bbgDt8fiPS+Z
	PO5c28PmsX/uGnaPLVfbWTz6tqxi9Fix+ju7x+dNcgHsUVw2Kak5mWWpRfp2CVwZO2Y+YSvY
	51pxqHsSWwPjJ+MuRk4OCQETiW+NXWwQtpjEhXvrgWwuDiGBpYwSXTvPssIUNR7uYIdITGeU
	2H7hLzNIgldAUOLH5HssIDazgLrEpHmLmCFsEYmLT6YwQtjaEssWvmaGaH7NKNFz7xQbRLOW
	xNc9b9lBbBYBVYmfa1eAbWMTkJN42/QNrFlUIEzi6oTjYAtEBDQk9jw8zwoyiFmgm1ni6oke
	sEHCAnkSHzc2gw0SEuhjlOi8rt3FyMHBKRAssfpMMki9hEArh0TPqxNsEMsEJL5NPsQCUiMh
	ICux6QAzxJeSEgdX3GCZwCg+C8lvs5D8NgvJb7OQ/LaAkWUVo2hqQXJBcVJ6kZFecWJucWle
	ul5yfu4mRmCMn/73rG8H480D1ocYk4HWT2SWEk3OB6aIvJJ4Q2MzIwtTE1NjI3NLM9KElcR5
	Fz1MChISSE8sSc1OTS1ILYovKs1JLT7EyMTBKdXA2LrcIf+Os8aWmdY2jv1HZqpHvCna9TLr
	6MzuwoUf3/vP4/8n4rhE9tXdlif3q3/M4zk+7dK3l6wZT4TOuz6qYmZNrDe/rpuXvT+wfoqr
	dFuRnIKSaNmOeumN/DL90y2KJTuYgtmfNUw+HXU5JLj50KldOnESwvYdH2L4FxfNerN9wg3+
	jZs+KbEUZyQaajEXFScCAGd5FgAHAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrOKsWRmVeSWpSXmKPExsVy+t9jQd0f+jOCDSYdY7S4/uU5q0Xz4vVs
	FpPuT2CxeHHvIovFrCl7mSwu75rDZvG59wijxe3GFWwWd08dZbM4c/oSq8XxteEO3B6L97xk
	8rhzbQ+bx/65a9g9tlxtZ/Ho27KK0WPF6u/sHp83yQWwRzUw2mSkJqakFimk5iXnp2Tmpdsq
	eQfHO8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYAHamkUJaYUwoUCkgsLlbSt8M0ITTETdcC
	pjFC1zckCK7HyAANJKxhzDjc28JY0OZaMfvrc/YGxl3GXYycHBICJhKNhzvYIWwxiQv31rN1
	MXJxCAlMZ5TYfuEvM0iCV0BQ4sfkeyxdjBwczALyEkcuZYOEmQXUJSbNW8QMUf+aUaLn3ik2
	iHotia973oINZRFQlfi5dgUriM0mICfxtukbI4gtKhAmcXXCcRYQW0RAQ2LPw/OsIIOYBbqZ
	Ja6e6AEbJCyQJ/FxYzPYICGBPkaJzuvaIEdwCgRLrD6TPIFRYBaS82YhnDcLyXkLGJlXMYqm
	FiQXFCel5xrpFSfmFpfmpesl5+duYgQng2fSOxhXNVgcYhTgYFTi4ZWQnh4sxJpYVlyZe4hR
	goNZSYT3luKMYCHelMTKqtSi/Pii0pzU4kOMyUDPTWSWEk3OByaqvJJ4Q2MTMyNLI3NDCyNj
	c9KElcR5D7ZaBwoJpCeWpGanphakFsFsYeLglGpgTDTfzHD+f9R5BWFj2YOHnnLk+xfO+VOR
	6ZuqZZzbr7rCWjzAmDfh36F8cfc3DWk9D55OymrgWPR/2/See70r6qd/imLhuSV/c2tu57aw
	sOSolZMUQuSS5N8zhjllT597wvPMnfAdqxtlC49LiGyfnbtKfuOMGcnW/CeCG59f21OYXKZX
	t/CAEktxRqKhFnNRcSIAfoUGnEoDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ulf,
On 2014년 06월 11일 17:27, Ulf Hansson wrote:

> On 11 June 2014 02:33, Jonghwa Lee <jonghwa3.lee@samsung.com> wrote:
>> When device uses generic pm domain, its own runtime suspend callback will be
>> executed only when all devices in the same domain are suspended. However, some
>> device needs sychronized runtime suspend and not to be deffered.
>> For those devices, Generic pm domain adds new API for adding device with flag,
>> which shows that it guerantees driver's runtime suspend will be executed right
>> away not at the time domain is really powered off.
>> Existed API, pm_genpd_add_device(), now adds device with flag representing this
>> device is not needed sychrnoized callback. It will work as same as before.
> 
> Hi Jonghwa,
> 
> I understand you have an issue of the behaviour of genpd here and I
> agree we need a solution, but I am not sure this is the correct one.
> :-)
> 
> The current behaviour of how genpd deals with runtime PM suspend
> callbacks has two severe issues:
> 
> 1 ) It prevents fine grained power management within a domain. Simply
> because those resources that are controlled on levels below the
> pm_domain, can't be put in low power state until the complete domain
> will be dropped.
> 2 ) All devices within a domain will be runtime PM suspended at the
> same time. This causes a thundering herd problem since latencies gets
> accumulated for each device in a domain.
> 
> Instead I think we should try to change the default behaviour of genpd
> and let it invoke the runtime PM callbacks immediately and not wait
> for the domain to be dropped. Do you think that could work?
> 


Yes, I think it could. I didn't understand why genpd prohibits device to be
suspended separately but puts all devices suspended altogether. But, I'm just
afraid to change genpd's behavior totally due to my own inconvenience.

And addition to above problems, there is one more problem due to genpd's current
bust suspending.

3) It would break the device dependency. Even if devices request to be suspended
sequentially considering their dependencies, genpd simply ignores it and let
them suspended in order of registration. It means suspending order absolutely
depends on when device is bound to genpd.

Observing 3 definite problems, it looks genpd should be changed. However,
someone might want to keep it work as like before, who knows? I respectfully ask
Rafael's opinion.

Best regards
Jonghwa

> Kind regards
> Ulf Hansson
> 
>>
>> Signed-off-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
>> ---
>>  drivers/base/power/domain.c |   17 ++++++++++++++---
>>  include/linux/pm_domain.h   |   19 ++++++++++++++++---
>>  2 files changed, 30 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/base/power/domain.c b/drivers/base/power/domain.c
>> index ae098a2..6c7a786 100644
>> --- a/drivers/base/power/domain.c
>> +++ b/drivers/base/power/domain.c
>> @@ -503,6 +503,9 @@ static int pm_genpd_poweroff(struct generic_pm_domain *genpd)
>>         genpd->poweroff_task = current;
>>
>>         list_for_each_entry_reverse(pdd, &genpd->dev_list, list_node) {
>> +               if (dev_gpd_data(pdd->dev)->rpmflags & GENPD_RPM_SYNC)
>> +                       continue;
>> +
>>                 ret = atomic_read(&genpd->sd_count) == 0 ?
>>                         __pm_genpd_save_device(pdd, genpd) : -EBUSY;
>>
>> @@ -625,6 +628,9 @@ static int pm_genpd_runtime_suspend(struct device *dev)
>>         if (stop_ok && !stop_ok(dev))
>>                 return -EBUSY;
>>
>> +       if (dev_gpd_data(dev)->rpmflags & GENPD_RPM_SYNC)
>> +               genpd_save_dev(genpd, dev);
>> +
>>         ret = genpd_stop_dev(genpd, dev);
>>         if (ret)
>>                 return ret;
>> @@ -1416,7 +1422,7 @@ static void __pm_genpd_free_dev_data(struct device *dev,
>>   * @td: Set of PM QoS timing parameters to attach to the device.
>>   */
>>  int __pm_genpd_add_device(struct generic_pm_domain *genpd, struct device *dev,
>> -                         struct gpd_timing_data *td)
>> +                         struct gpd_timing_data *td, enum genpd_rpmflags flags)
>>  {
>>         struct generic_pm_domain_data *gpd_data_new, *gpd_data = NULL;
>>         struct pm_domain_data *pdd;
>> @@ -1472,6 +1478,7 @@ int __pm_genpd_add_device(struct generic_pm_domain *genpd, struct device *dev,
>>         gpd_data->need_restore = genpd->status == GPD_STATE_POWER_OFF;
>>         gpd_data->td.constraint_changed = true;
>>         gpd_data->td.effective_constraint_ns = -1;
>> +       gpd_data->rpmflags = flags;
>>         mutex_unlock(&gpd_data->lock);
>>
>>   out:
>> @@ -1494,6 +1501,7 @@ int __pm_genpd_of_add_device(struct device_node *genpd_node, struct device *dev,
>>                              struct gpd_timing_data *td)
>>  {
>>         struct generic_pm_domain *genpd = NULL, *gpd;
>> +       enum genpd_rpmflags rpmflags;
>>
>>         dev_dbg(dev, "%s()\n", __func__);
>>
>> @@ -1512,7 +1520,9 @@ int __pm_genpd_of_add_device(struct device_node *genpd_node, struct device *dev,
>>         if (!genpd)
>>                 return -EINVAL;
>>
>> -       return __pm_genpd_add_device(genpd, dev, td);
>> +       rpmflags = of_property_read_bool(dev->of_node, "pm-genpd-rpmsync");
>> +
>> +       return __pm_genpd_add_device(genpd, dev, td, rpmflags);
>>  }
>>
>>
>> @@ -1525,7 +1535,8 @@ int __pm_genpd_of_add_device(struct device_node *genpd_node, struct device *dev,
>>  int __pm_genpd_name_add_device(const char *domain_name, struct device *dev,
>>                                struct gpd_timing_data *td)
>>  {
>> -       return __pm_genpd_add_device(pm_genpd_lookup_name(domain_name), dev, td);
>> +       struct generic_pm_domain *genpd = pm_genpd_lookup_name(domain_name);
>> +       return __pm_genpd_add_device(genpd, dev, td, GENPD_RPM_ASYNC);
>>  }
>>
>>  /**
>> diff --git a/include/linux/pm_domain.h b/include/linux/pm_domain.h
>> index 7c1d252..d36e5cf 100644
>> --- a/include/linux/pm_domain.h
>> +++ b/include/linux/pm_domain.h
>> @@ -106,6 +106,11 @@ struct gpd_timing_data {
>>         bool cached_stop_ok;
>>  };
>>
>> +enum genpd_rpmflags {
>> +       GENPD_RPM_ASYNC = 0,
>> +       GENPD_RPM_SYNC,
>> +};
>> +
>>  struct generic_pm_domain_data {
>>         struct pm_domain_data base;
>>         struct gpd_dev_ops ops;
>> @@ -114,6 +119,7 @@ struct generic_pm_domain_data {
>>         struct mutex lock;
>>         unsigned int refcount;
>>         bool need_restore;
>> +       enum genpd_rpmflags rpmflags;
>>  };
>>
>>  #ifdef CONFIG_PM_GENERIC_DOMAINS
>> @@ -132,7 +138,8 @@ extern struct dev_power_governor simple_qos_governor;
>>  extern struct generic_pm_domain *dev_to_genpd(struct device *dev);
>>  extern int __pm_genpd_add_device(struct generic_pm_domain *genpd,
>>                                  struct device *dev,
>> -                                struct gpd_timing_data *td);
>> +                                struct gpd_timing_data *td,
>> +                                enum genpd_rpmflags flags);
>>
>>  extern int __pm_genpd_of_add_device(struct device_node *genpd_node,
>>                                     struct device *dev,
>> @@ -180,7 +187,8 @@ static inline struct generic_pm_domain *dev_to_genpd(struct device *dev)
>>  }
>>  static inline int __pm_genpd_add_device(struct generic_pm_domain *genpd,
>>                                         struct device *dev,
>> -                                       struct gpd_timing_data *td)
>> +                                       struct gpd_timing_data *td,
>> +                                       enum genpd_rpmflags flags);
>>  {
>>         return -ENOSYS;
>>  }
>> @@ -263,10 +271,15 @@ static inline bool default_stop_ok(struct device *dev)
>>  #define pm_domain_always_on_gov NULL
>>  #endif
>>
>> +static inline int pm_genpd_add_device_rpmsync(struct generic_pm_domain *genpd,
>> +                                     struct device *dev)
>> +{
>> +       return __pm_genpd_add_device(genpd, dev, NULL, GENPD_RPM_SYNC);
>> +}
>>  static inline int pm_genpd_add_device(struct generic_pm_domain *genpd,
>>                                       struct device *dev)
>>  {
>> -       return __pm_genpd_add_device(genpd, dev, NULL);
>> +       return __pm_genpd_add_device(genpd, dev, NULL, GENPD_RPM_ASYNC);
>>  }
>>
>>  static inline int pm_genpd_of_add_device(struct device_node *genpd_node,
>> --
>> 1.7.9.5
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
> 


