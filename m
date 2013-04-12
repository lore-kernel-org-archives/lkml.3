Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754054Ab3DLMLF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 08:11:05 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:33656 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752878Ab3DLMLC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 08:11:02 -0400
X-AuditID: cbfee68d-b7f786d000005188-50-5167f9d4c90b
From: "myungjoo.ham" <myungjoo.ham@samsung.com>
To: "'Rafael J. Wysocki'" <rjw@sisk.pl>, "'Axel Lin'" <axel.lin@ingics.com>,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>
Cc: "'Rafael J. Wysocki'" <rafael.j.wysocki@intel.com>,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1365746058.4025.1.camel@phoenix>
 <1413655.hhUbBAKNUi@vostro.rjw.lan>
In-reply-to: <1413655.hhUbBAKNUi@vostro.rjw.lan>
Subject: RE: [RESEND][PATCH 1/3] PM / devfreq: exynos4_bus: Fix missing
 mutex_unlock if opp_find_freq_floor fails
Date: Fri, 12 Apr 2013 21:11:00 +0900
Message-id: <002101ce3776$cbc83f90$6358beb0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQKqXKTL/tflJ9mr78t5cAONgHW1LgH5W0x+lwppaoA=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPIsWRmVeSWpSXmKPExsWyRsSkSPfKz/RAg5k/xC2OzPnKbNG74Cqb
	xdmmN+wWl3fNYbP43HuE0eLxirfsFv0Le5kc2D3afpZ5LN7zksmjb8sqRo9Hi1sYPT5vkgtg
	jeKySUnNySxLLdK3S+DKmLq6vGC+YMWPG21sDYxfeboYOTkkBEwkZixZygRhi0lcuLeerYuR
	i0NIYCmjxLSZD9hgivrub2WFSExnlPj//CIThPObUWLpym0sIFVsAvoSe679YgRJiAgsYJR4
	O/kgO0iCWaBA4u/M/2BFQgLBEldPgIzi5OAUMJBY2bAPbLewQLHE/675zCA2i4CqROPulUBx
	Dg5eAUuJSzfdQcK8AoISPybfYwEJMwuoS0yZkgsxXVviybsLrBCHKkjsOPuaEcQWEbCSmLvy
	ENQFIhL7XrwDO01C4C27xOzLvVCrBCS+TT4ENlNCQFZi0wFmiDmSEgdX3GCZwCgxC8nmWQib
	ZyHZPAvJhgWMLKsYRVMLkguKk9KLDPWKE3OLS/PS9ZLzczcxAiP39L9nvTsYbx+wPsSYDLR9
	IrOUaHI+MPLzSuINjc2MLExNTI2NzC3NSBNWEudVa7EOFBJITyxJzU5NLUgtii8qzUktPsTI
	xMEp1cB4ceK0WctbuP/zqizt9rB93P7yfmnuvb1hR6J36e+QmnYzJp356qnNTveq2j+8fCBZ
	Nlf0w48jl04//KeU8eGjfuDFt5+vfrJ1Er2yaa3Yy5OFD6pOthVbdXB3fnd8ErrFNC5gz8qC
	ozOFDWtYJzy0/PTw9+Sgk3vMn/oyZM7wF/gY0M27IX7XJSWW4oxEQy3mouJEAPlxWPLyAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDKsWRmVeSWpSXmKPExsVy+t9jQd0rP9MDDa4/ELA4Mucrs0Xvgqts
	Fmeb3rBbXN41h83ic+8RRovHK96yW/Qv7GVyYPdo+1nmsXjPSyaPvi2rGD0eLW5h9Pi8SS6A
	NaqB0SYjNTEltUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMH6Awl
	hbLEnFKgUEBicbGSvh2mCaEhbroWMI0Rur4hQXA9RgZoIGENY8bU1eUF8wUrftxoY2tg/MrT
	xcjJISFgItF3fysrhC0mceHeerYuRi4OIYHpjBL/n19kgnB+M0osXbmNBaSKTUBfYs+1X4wg
	CRGBBYwSbycfZAdJMAsUSPyd+R+sSEggWOLqCYixnAIGEisb9jGB2MICxRL/u+Yzg9gsAqoS
	jbtXAsU5OHgFLCUu3XQHCfMKCEr8mHyPBSTMLKAuMWVKLsR0bYkn7y5AHaogsePsa0YQW0TA
	SmLuykNQF4hI7HvxjnECo9AsJJNmIUyahWTSLCQdCxhZVjGKphYkFxQnpeca6RUn5haX5qXr
	JefnbmIEp4Vn0jsYVzVYHGIU4GBU4uF9IZweKMSaWFZcmXuIUYKDWUmEN2ZvWqAQb0piZVVq
	UX58UWlOavEhxmSgNycyS4km5wNTVl5JvKGxiZmRpZG5oYWRsTlpwkrivAdbrQOFBNITS1Kz
	U1MLUotgtjBxcEo1MC6O3HxKUtc1ITjppOurI1MiXV9e6N1wZkeft0NM1AIFydzowxKRluUZ
	YXnbpyZwZ13nZBCIi/UqueN5T7lNevkMZtaEd2bM5RvKuY4sX3imqU75juIz88qZFSr6HpN3
	K+/kTbjMtoDhTvIWw0uK4UwtBfLz18qd3S8Z+FLMatONjON3llmeVWIpzkg01GIuKk4EAALh
	WINPAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Friday, April 12, 2013 11:52:01 AM 함명주 wrote:
> > > On Friday, April 12, 2013 01:54:18 PM Axel Lin wrote:
> > > > We need to call mutex_unlock() in the error path.
> > > > 
> > > > Signed-off-by: Axel Lin <axel.lin@ingics.com>
> > > 
> > > All three patches applied to linux-pm.git/linux-next.
> > > 
> > > Exynos maintainers, if you have any objections, please holler.
> > > 
> > > Thanks,
> > > Rafael
> > 
> > This patch was included in the last pull-request patchset
> > though the path was updated. (its precedessor patch moved
> > exynos drivers to /drivers/devfreq/exynos/* after adding
> > Exynos common driver files)
> 
> OK, so do you want me to drop it?
> 
> What about the remaining two?

Yes, please drop 1/3. It's duplicated.

The patches 2~3/3 can wait. They are actually not bugfixes.

> 
> Do you have any more devfreq patches for me to take into v3.10?  If so,
> please send a pull request ASAP.
> 
> Thanks,
> Rafael
> 
> 
> > > 
> > > > ---
> > > >  drivers/devfreq/exynos4_bus.c |    3 ++-
> > > >  1 file changed, 2 insertions(+), 1 deletion(-)
> > > > 
> > > > diff --git a/drivers/devfreq/exynos4_bus.c b/drivers/devfreq/exynos4_bus.c
> > > > index 1deee09..54b9615 100644
> > > > --- a/drivers/devfreq/exynos4_bus.c
> > > > +++ b/drivers/devfreq/exynos4_bus.c
> > > > @@ -974,7 +974,8 @@ static int exynos4_busfreq_pm_notifier_event(struct notifier_block *this,
> > > >  			rcu_read_unlock();
> > > >  			dev_err(data->dev, "%s: unable to find a min freq\n",
> > > >  				__func__);
> > > > -			return PTR_ERR(opp);
> > > > +			err = PTR_ERR(opp);
> > > > +			goto unlock;
> > > >  		}
> > > >  		new_oppinfo.rate = opp_get_freq(opp);
> > > >  		new_oppinfo.volt = opp_get_voltage(opp);
> > > > 
> > > -- 
> > > I speak only for myself.
> > > Rafael J. Wysocki, Intel Open Source Technology Center.
> > > 
> > > 
> > > 
> > >        
> > >   
> > >          
> > > 
> 
> -- 
> I speak only for myself.
> Rafael J. Wysocki, Intel Open Source Technology Center.
> 
> 
> 
>        
>   
>          
>

