Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752894AbaEHCHa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 22:07:30 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:15811 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751851AbaEHCH1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 22:07:27 -0400
X-AuditID: cbfee68f-b7eff6d000002b70-3e-536ae6dd2a0c
From: Jonghwan Choi <jhbird.choi@samsung.com>
To: "'Nishanth Menon'" <nm@ti.com>
Cc: "'Viresh Kumar'" <viresh.kumar@linaro.org>,
        "'Linux PM list'" <linux-pm@vger.kernel.org>,
        "'open list'" <linux-kernel@vger.kernel.org>,
        "'Rafael J. Wysocki'" <rjw@rjwysocki.net>,
        "'Len Brown'" <len.brown@intel.com>,
        "'Amit Daniel Kachhap'" <amit.daniel@samsung.com>
References: <000001cf643d$69e5e350$3db1a9f0$@samsung.com>
 <CAOh2x=m8DzmLOGqL0E_seOZMuzU=O9vQuu-JEp+E5454RmfEXw@mail.gmail.com>
 <003901cf6664$e4e8d2a0$aeba77e0$@samsung.com>
 <CAKohpon7W726Hxj5OJ6SnmPz3gYhAeBRr1wS3SCa3F2hSLriLQ@mail.gmail.com>
 <5367946F.1030407@ti.com>
 <CAKohpon-KZpSJK7PxpLjZS7sVPcYraDxb4oJHN6dxSagD+F--Q@mail.gmail.com>
 <CAGo_u6pUVeMM9mqe5htvM1X_4pkRGEUVOA2ty4ZPfUyLcLZkrw@mail.gmail.com>
 <CAKohpokfcptseU6ST+e_GfU6poVJxXCXMeoYCvT65060v5GJYQ@mail.gmail.com>
 <003e01cf6984$fb950280$f2bf0780$@samsung.com>
 <CAGo_u6o0J_T_hnmDAiYpsDxe77iKPCjuWisZJfTjYYOVGJF96A@mail.gmail.com>
 <CAKohpo=qbj9w5=wWHEG=9c2spjbbhaDaXG+F-Lhe9QffV9sDbw@mail.gmail.com>
 <001501cf6a5c$07bc2520$17346f60$@samsung.com>
 <CAGo_u6rAY1Cqh6_1RPsjGMwqNSVr=yW+VgyXfEjA6V+LT-SMcQ@mail.gmail.com>
In-reply-to: <CAGo_u6rAY1Cqh6_1RPsjGMwqNSVr=yW+VgyXfEjA6V+LT-SMcQ@mail.gmail.com>
Subject: RE: [PATCH 1/3] PM / OPP: Add support for descending order for cpufreq
 table
Date: Thu, 08 May 2014 11:07:24 +0900
Message-id: <000301cf6a62$413c16b0$c3b44410$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQIqe0fjYa0YwQL6oKQ2dX7E8rarYwGe0UWzAg3L9n0CFbDXrQI73VqNAJ+GCpEBnU9akQFwpfDYAuYRDbQCG7oysAHyEw+TAdaKEeECfNgZepnINCYg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCIsWRmVeSWpSXmKPExsVy+t8zfd27z7KCDW5ulrBouBpiMWvKXiaL
	y7vmsFl87j3CaPHmx1kmizOnL7FabPzq4cDusXjPSyaPO9f2sHlsudrO4tG3ZRWjx/Eb25k8
	Pm+SC2CL4rJJSc3JLEst0rdL4MrYesiw4Kxcxabph1gbGM+KdjFyckgImEhMfDOPCcIWk7hw
	bz1bFyMXh5DAMkaJ7Xda2GCK7j9awAxiCwksYpTYf8kJougfo8TpzpWsIAk2AV2JY+u3ANkc
	HCICChJdW1VBapgFupkk+if8ZoJomMsmcfXqdrBJnALBElNfTQDbICwQLrFm3UywM1gEVCWu
	v+lhBLF5BSwlmu//Y4WwBSV+TL7HArKAWUBdYsqUXJAws4C2xJN3F1ghDlWQ2HH2NSPILhGB
	FkaJ5hmXmCGKRCT2vXgHlpAQ+Mku8fbMbEaIZQIS3yYfAhsqISArsekAM8QgSYmDK26wTGCU
	mIVk9SyE1bOQrJ6FZMMCRpZVjKKpBckFxUnpRcZ6xYm5xaV56XrJ+bmbGCEx3L+D8e4B60OM
	yUDbJzJLiSbnA1NAXkm8obGZkYWpiamxkbmlGWnCSuK89x8mBQkJpCeWpGanphakFsUXleak
	Fh9iZOLglGpgLG0QuJbSmty3OeHiSY7p/klKBRumX9K2cF3N9n5DcplT5SHTIybhC4v5c+5c
	4jH4Euvv1mndycdyU3ENv/i5A+zbXil+EH+leWOTk6CdwDH9q9vcvkR47LhrdGnJzGU/0yNO
	Oxl0XVEoWcUX8nHX+uPvEi6kbGW3YZqvoiwe3bU5wZG7Q1ZYiaU4I9FQi7moOBEAhCjA7PcC	AAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrIKsWRmVeSWpSXmKPExsVy+t9jAd27z7KCDZ6cELZouBpiMWvKXiaL
	y7vmsFl87j3CaPHmx1kmizOnL7FabPzq4cDusXjPSyaPO9f2sHlsudrO4tG3ZRWjx/Eb25k8
	Pm+SC2CLamC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXL
	zAE6RUmhLDGnFCgUkFhcrKRvh2lCaIibrgVMY4Sub0gQXI+RARpIWMeYsfWQYcFZuYpN0w+x
	NjCeFe1i5OSQEDCRuP9oATOELSZx4d56NhBbSGARo8T+S05djFxA9j9GidOdK1lBEmwCuhLH
	1m8Bsjk4RAQUJLq2qoLUMAt0M0n0T/jNBNEwl03i6tXtYFM5BYIlpr6aADZVWCBcYs26mUwg
	NouAqsT1Nz2MIDavgKVE8/1/rBC2oMSPyfdYQBYwC6hLTJmSCxJmFtCWePLuAivEoQoSO86+
	ZgTZJSLQwijRPOMSM0SRiMS+F+8YJzAKzUIyahbCqFlIRs1C0rGAkWUVo2hqQXJBcVJ6rpFe
	cWJucWleul5yfu4mRnCCeCa9g3FVg8UhRgEORiUe3gznrGAh1sSy4srcQ4wSHMxKIrz+k4FC
	vCmJlVWpRfnxRaU5qcWHGJOBHp3ILCWanA9MXnkl8YbGJmZGlkZmFkYm5uakCSuJ8x5stQ4U
	EkhPLEnNTk0tSC2C2cLEwSnVwMjOb3Q2+UIdK6fZvMCFFvt8i2b8f+/89cikxV4HSv9qTlm3
	zuBHnc/fOX1yIc01vxvt3r/Sm17IbRDw++EM4+4NE0NLay9P2agZO7PksuFErUlX7v41jzBd
	2MAhymEWYXTkiUCPUdnsuJjtKs0zusOPbe06cyJMcesJ6yPSt7T4n746czMh/pYSS3FGoqEW
	c1FxIgCuhlaiVAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I believe that 3 item is required for DVFS. Those are frequency, voltage, divider value.
Currently OPP only supports voltage and frequency. 
So some cpufreq and devfreq driver get a divider value from struct divider table.

How about adding that divider value into struct dev_pm_opp like this;

struct dev_pm_opp {
        struct list_head node;

        bool available;
        unsigned long rate;
        unsigned long u_volt;
        unsigned int ctl[2]; // Added

        struct device_opp *dev_opp;
        struct rcu_head head;
};
In my test, it works very wel..

I got a this idea from _PCT in acpi spec.

Then we can remove a lot of code related to divide table. And we also can solve this problem.

Thanks

Best Regarfs.


> -----Original Message-----
> From: menon.nishanth@gmail.com [mailto:menon.nishanth@gmail.com] On Behalf
> Of Nishanth Menon
> Sent: Thursday, May 08, 2014 10:56 AM
> To: Jonghwan Choi
> Cc: Viresh Kumar; Linux PM list; open list; Rafael J. Wysocki; Len Brown;
> Amit Daniel Kachhap
> Subject: Re: [PATCH 1/3] PM / OPP: Add support for descending order for
> cpufreq table
> 
> On Wed, May 7, 2014 at 8:22 PM, Jonghwan Choi <jhbird.choi@samsung.com>
> wrote:
> >> @Jonghwan: Please consider doing this:
> >> - Don't play with the order of frequencies in table.
> >> - Instead initialize .driver_data filed with values that you need to
> >> write in the registers for all frequencies. i.e. 0 for highest
> >> frequency and
> >> FREQ_COUNT-1 for lowest one.
> >
> > -> For that, I changed like this.
> > For initializing .driver_data, I changed dev_pm_opp_init_cpufreq_table
> function().
> >
> >
> > --- a/drivers/base/power/opp.c
> > +++ b/drivers/base/power/opp.c
> > @@ -622,12 +622,12 @@ EXPORT_SYMBOL_GPL(dev_pm_opp_disable);
> >   * or in contexts where mutex locking cannot be used.
> >   */
> >  int dev_pm_opp_init_cpufreq_table(struct device *dev,
> > -                           struct cpufreq_frequency_table **table)
> > +               struct cpufreq_frequency_table **table, int order)
> >  {
> >         struct device_opp *dev_opp;
> >         struct dev_pm_opp *opp;
> >         struct cpufreq_frequency_table *freq_table;
> > -       int i = 0;
> > +       int i = 0, index = 0;
> >
> >         /* Pretend as if I am an updater */
> >         mutex_lock(&dev_opp_list_lock); @@ -649,16 +649,22 @@ int
> > dev_pm_opp_init_cpufreq_table(struct device *dev,
> >                 return -ENOMEM;
> >         }
> >
> > +       if (OPP_TABLE_ORDER_DESCENDING == order)
> > +               index = dev_pm_opp_get_opp_count(dev) - 1;
> > +
> >         list_for_each_entry(opp, &dev_opp->opp_list, node) {
> >                 if (opp->available) {
> > -                       freq_table[i].driver_data = i;
> > +                       if (OPP_TABLE_ORDER_DESCENDING == order)
> > +                               freq_table[i].driver_data = index--;
> > +                       else
> > +                               freq_table[i].driver_data = index++;
> >                         freq_table[i].frequency = opp->rate / 1000;
> >                         i++;
> >                 }
> >         }
> >         mutex_unlock(&dev_opp_list_lock);
> >
> > -       freq_table[i].driver_data = i;
> > +       freq_table[i].driver_data = index;
> >         freq_table[i].frequency = CPUFREQ_TABLE_END;
> >
> >         *table = &freq_table[0];
> >
> >
> > Is it acceptiable?
> 
> Personally, I feel that filling up driver_data should be left to the
> driver(caller of dev_pm_opp_init_cpufreq_table). for example providing a
> function pointer which decides what that value should be (be it index or
> some magical register value).. Viresh might have better opinions.
> 
> Regards,
> Nishanth Menon

