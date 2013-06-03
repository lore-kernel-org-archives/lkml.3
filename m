Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751918Ab3FCHFr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 03:05:47 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:56331 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750861Ab3FCHFk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 03:05:40 -0400
X-AuditID: cbfee68e-b7f276d000002279-39-51ac40424944
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andy Shevchenko'" <andy.shevchenko@gmail.com>
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, Jingoo Han <jg1.han@samsung.com>
References: <001501ce5e9a$15731080$40593180$@samsung.com>
 <CAHp75Vce+=1Fdb0Eqg0w+e511cAJeZ8cP6-d+9ng=s-5tJ5C+g@mail.gmail.com>
In-reply-to: <CAHp75Vce+=1Fdb0Eqg0w+e511cAJeZ8cP6-d+9ng=s-5tJ5C+g@mail.gmail.com>
Subject: Re: [PATCH] rtc: rtc-pcf2123: replace strict_strtoul() with kstrtoul()
Date: Mon, 03 Jun 2013 16:05:37 +0900
Message-id: <000101ce6028$c01fa220$405ee660$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQHaFBu34hL0jvjsvPzUTvEDad8SNwFy0d89mQCR7fA=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLIsWRmVeSWpSXmKPExsVy+t8zA10nhzWBBmfviVosuXiV3WLO+jVs
	Fi8nHGa0uLzwEqvF5V1z2Cz2d3YwOrB57Jx1l91jz8STbB4nZvxm8ejbsorRY/q8n0wenzfJ
	BbBFcdmkpOZklqUW6dslcGVM225e0M1TsfbQEqYGxk7OLkZODgkBE4lD246zQNhiEhfurWfr
	YuTiEBJYxigx80MfI1zR0dvsEInpjBJ7V59kgXB+MUrM/9XPBFLFJqAm8eXLYXYQW0TAUGLu
	ozPMIEXMArsYJSbP7mEGSQgJNDBK7Guw6WJk5+AUCJZ4KQESFRbwlzjZ+AdoMwcHi4CqxJYu
	UZAwr4ClxLMjv1kgbEGJH5PvsYCUMAuoS0yZkgsSZhaQl9i85i0zxJkKEjvOvmaEOMBK4tr+
	pcwQNSIS+168g3rlK7vErhM2IDaLgIDEt8mHwEZKCMhKbDoANUZS4uCKGywTGCVmIVk8C2Hx
	LCSLZyFZsICRZRWjaGpBckFxUnqRkV5xYm5xaV66XnJ+7iZGSNT27WC8ecD6EGMy0PaJzFKi
	yfnAqM8riTc0NjOyMDUxNTYytzQjTVhJnFetxTpQSCA9sSQ1OzW1ILUovqg0J7X4ECMTB6dU
	A2O64n3lZduYW3Zma1y5/HZ2aq363fp9Elof+6XDtvmGe98WimHwaBe75KvV+HBd+6WjHNHH
	f+98/WnxM7ElBx5fPqm78diGaZvDMq+kstzQOii+foLiJAOZuBsuDPITYj5crTOYbJtlt0fn
	seB2q8wdbII+s1PVDcVC5n8R050c9St/4f+nJ78rsRRnJBpqMRcVJwIA9n0DKfACAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNKsWRmVeSWpSXmKPExsVy+t9jQV0nhzWBBjdvCFosuXiV3WLO+jVs
	Fi8nHGa0uLzwEqvF5V1z2Cz2d3YwOrB57Jx1l91jz8STbB4nZvxm8ejbsorRY/q8n0wenzfJ
	BbBFNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl5gDd
	oaRQlphTChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGPMmLbdvKCbp2LtoSVMDYyd
	nF2MnBwSAiYSh47eZoewxSQu3FvP1sXIxSEkMJ1RYu/qkywQzi9Gifm/+plAqtgE1CS+fDkM
	1iEiYCgx99EZZpAiZoFdjBKTZ/cwgySEBBoYJfY12HQxsnNwCgRLvJQAiQoL+EucbPwDtICD
	g0VAVWJLlyhImFfAUuLZkd8sELagxI/J91hASpgF1CWmTMkFCTMLyEtsXvOWGeJMBYkdZ18z
	QhxgJXFt/1JmiBoRiX0v3jFOYBSahWTSLIRJs5BMmoWkYwEjyypG0dSC5ILipPRcQ73ixNzi
	0rx0veT83E2M4KTwTGoH48oGi0OMAhyMSjy8HdtXBQqxJpYVV+YeYpTgYFYS4U1euTpQiDcl
	sbIqtSg/vqg0J7X4EGMy0JsTmaVEk/OBCSuvJN7Q2MTMyNLIzMLIxNycNGElcd4DrdaBQgLp
	iSWp2ampBalFMFuYODilGhh99zhKLBJYfD5zqvjD5TPS+cX17DL+OM9nu/xq31XV7YxTthQE
	PDWdOPWpQVOMYvtZtYPpCXNvTTSyZY2+q+x+/OUG+XAtRk6Vyff3yN+pFF1Tk/wkMqJ9jo1A
	ApfwJa0YFhth3fbiiXelb/1dzFnqs2HaYVO1FrbkzU6nTp/LP3sqesqqZj4lluKMREMt5qLi
	RABbDmHoTgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, June 02, 2013 8:56 PM, Andy Shevchenko wrote:
> On Sat, Jun 1, 2013 at 10:31 AM, Jingoo Han <jg1.han@samsung.com> wrote:
> > The usage of strict_strtoul() is not preferred, because
> > strict_strtoul() is obsolete. Thus, kstrtoul() should be
> > used.
> 
> > --- a/drivers/rtc/rtc-pcf2123.c
> > +++ b/drivers/rtc/rtc-pcf2123.c
> > @@ -94,7 +94,7 @@ static ssize_t pcf2123_show(struct device *dev, struct device_attribute *attr,
> >
> >         r = container_of(attr, struct pcf2123_sysfs_reg, attr);
> >
> > -       if (strict_strtoul(r->name, 16, &reg))
> > +       if (kstrtoul(r->name, 16, &reg))
> >                 return -EINVAL;
> 
> ret = kstrtoul(...);
> if (ret)
> return ret;
> 
> > @@ -117,8 +117,7 @@ static ssize_t pcf2123_store(struct device *dev, struct device_attribute *attr,
> >
> >         r = container_of(attr, struct pcf2123_sysfs_reg, attr);
> >
> > -       if (strict_strtoul(r->name, 16, &reg)
> > -               || strict_strtoul(buffer, 10, &val))
> > +       if (kstrtoul(r->name, 16, &reg) || kstrtoul(buffer, 10, &val))
> >                 return -EINVAL;
> 
> I see no harm to allow user to write octal values as well.
> Thus, just
> ret = kstrtoul(r->name, 0, &reg);

If you want to do this, please send another patch later, on top of this patch.
I just want to address the replacing strict_strtoul() with kstrtoul().

Best regards,
Jingoo Han

> if (ret)
> return ret;
> 
> Alessandro, what do you think?
> 
> --
> With Best Regards,
> Andy Shevchenko

