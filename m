Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751883Ab3B1JhH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 04:37:07 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:59108 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960Ab3B1JhB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 04:37:01 -0500
X-AuditID: cbfee68f-b7f6a6d000004969-3e-512f253bd68d
From: Jingoo Han <jg1.han@samsung.com>
To: "'Geert Uytterhoeven'" <geert@linux-m68k.org>
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <00a501ce158e$ef171610$cd454230$%han@samsung.com>
 <00ab01ce158f$6434eda0$2c9ec8e0$%han@samsung.com>
 <CAMuHMdVgeXNUaGxzV=sicvVM8m_1sd0Xqm2njaRn9QqM=VibfQ@mail.gmail.com>
In-reply-to: <CAMuHMdVgeXNUaGxzV=sicvVM8m_1sd0Xqm2njaRn9QqM=VibfQ@mail.gmail.com>
Subject: Re: [PATCH 07/19] rtc: rtc-ps3: remove erroneous __init/__exit
 annotations
Date: Thu, 28 Feb 2013 18:36:59 +0900
Message-id: <000001ce1597$27e88d40$77b9a7c0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4VkXPx7zC2fnSDS1y6YD797FuOwQABPWSw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPIsWRmVeSWpSXmKPExsVy+t8zY11rVf1AgyWzNS2WXLzKbjFn/Ro2
	i2e39jJZXF54idXi8q45bBb7OzsYHdg89kw8yeZxYsZvFo9DhzsYPfq2rGL0mD7vJ5PH501y
	AWxRXDYpqTmZZalF+nYJXBkL5k5gKzguUrGi/RpzA+Nh/i5GDg4JAROJHStNuhg5gUwxiQv3
	1rOB2EICyxglfk9khIibSHTtWM3excgFFJ/OKLHtzH8o5xejxNmnW5lBqtgE1CS+fDnMDmKL
	COhLbFv4jxGkiFlgD6PEz51vWCE6djBKPO6/BNbBKRAscWjKdLAOYYFQiaXzv7OA2CwCqhJX
	vxxkBTmPV8BWYv5qS5Awr4CgxI/J91hAwswC6hJTpuSChJkF5CU2r3nLDPGMusSjv7oQJxhJ
	7L7azgJRIiKx78U7sHMkBD6yS2zbdZUZYpOAxLfJh1ggemUlNh1ghnhYUuLgihssExglZiFZ
	PAth8Swki2ch2bCAkWUVo2hqQXJBcVJ6kbFecWJucWleul5yfu4mRkjk9u9gvHvA+hBjMtD2
	icxSosn5wMjPK4k3NDY2MTMxNTG3NDU3JU1YSZxX/pJMoJBAemJJanZqakFqUXxRaU5q8SFG
	Jg5OqQbGqkVloaaFV04rzTv/5MTj7h2q0+7aM017G3ye/4GYolK5uJv63NeNZ6/fu3RZa9J1
	PTn2OIuTHcznLsr/qHylmPN8V8WfzyGu9sJp37eEN/NuUfm+fusq7n1p+TceMFRP7N3y9p/L
	qzVeVipyrh0zfF88LGQrlvVxvxxyKSHR3WSBakTN8To+JZbijERDLeai4kQAd/Yn1PICAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHKsWRmVeSWpSXmKPExsVy+t9jQV1rVf1Ag64tKhZLLl5lt5izfg2b
	xbNbe5ksLi+8xGpxedccNov9nR2MDmweeyaeZPM4MeM3i8ehwx2MHn1bVjF6TJ/3k8nj8ya5
	ALaoBkabjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKA7
	lBTKEnNKgUIBicXFSvp2mCaEhrjpWsA0Ruj6hgTB9RgZoIGEdYwZC+ZOYCs4LlKxov0acwPj
	Yf4uRk4OCQETia4dq9khbDGJC/fWs3UxcnEICUxnlNh25j87hPOLUeLs063MIFVsAmoSX74c
	BusQEdCX2LbwHyNIEbPAHkaJnzvfsEJ07GCUeNx/CayDUyBY4tCU6WAdwgKhEkvnf2cBsVkE
	VCWufjkI1MDBwStgKzF/tSVImFdAUOLH5HssIGFmAXWJKVNyQcLMAvISm9e8ZQYJSwCFH/3V
	hTjBSGL31XYWiBIRiX0v3jFOYBSahWTQLIRBs5AMmoWkYwEjyypG0dSC5ILipPRcI73ixNzi
	0rx0veT83E2M4NTwTHoH46oGi0OMAhyMSjy8HSZ6gUKsiWXFlbmHGCU4mJVEeF349QOFeFMS
	K6tSi/Lji0pzUosPMSYDfTmRWUo0OR+YtvJK4g2NTcyMLI3MLIxMzM1JE1YS52U89SRASCA9
	sSQ1OzW1ILUIZgsTB6dUA6PcSekjXJYL3vtLHIyvCOksvXVaIOmaf7OmpqiJkuXD1N8FQuKn
	Rd8osP+esft8/qqNqVnhdT+3rDC+MSOotOOacwgLr+W75ft3rmYwXNu1zX5VrGgX86S53Fah
	PHylx096Na6Sd72XdkfWTPbd1dqmwsKncrtdjV6HrNjBmJQfuClTWir8qBJLcUaioRZzUXEi
	AI8qAa5RAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, February 28, 2013 5:56 PM, Geert Uytterhoeven wrote:
> 
> On Thu, Feb 28, 2013 at 9:41 AM, Jingoo Han <jg1.han@samsung.com> wrote:
> > __init/__exit annotations for probe()/remove() are supposed to be
> > __devinit/__devexit, because __init/__exit for probe()/remove()
> > are not correct. However, __devinit/__devexit are not used,
> > because CONFIG_HOTPLUG was removed. Thus, these annotations
> > should be removed.
> 
> Nack.
> 
> This driver does not use platform_driver_register(), but
> platform_driver_probe().
> Hence the .probe can only be called from platform_driver_probe()
> (which is __init),
> not at any later time.

Oops, you are right.
In this case, bind/unbind via sysfs is disabled.

Also, other drivers I sent for use platform_driver_probe().
So, my patchset is useless. 

Thank you for your comment :)


Best regards,
Jingoo Han

> 
> I did not check the other drivers you sent patches for.
> 
> > Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> > ---
> >  drivers/rtc/rtc-ps3.c |    6 +++---
> >  1 files changed, 3 insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/rtc/rtc-ps3.c b/drivers/rtc/rtc-ps3.c
> > index 968133c..8a24d11 100644
> > --- a/drivers/rtc/rtc-ps3.c
> > +++ b/drivers/rtc/rtc-ps3.c
> > @@ -58,7 +58,7 @@ static const struct rtc_class_ops ps3_rtc_ops = {
> >         .set_time = ps3_set_time,
> >  };
> >
> > -static int __init ps3_rtc_probe(struct platform_device *dev)
> > +static int ps3_rtc_probe(struct platform_device *dev)
> >  {
> >         struct rtc_device *rtc;
> >
> > @@ -71,7 +71,7 @@ static int __init ps3_rtc_probe(struct platform_device *dev)
> >         return 0;
> >  }
> >
> > -static int __exit ps3_rtc_remove(struct platform_device *dev)
> > +static int ps3_rtc_remove(struct platform_device *dev)
> >  {
> >         rtc_device_unregister(platform_get_drvdata(dev));
> >         return 0;
> > @@ -82,7 +82,7 @@ static struct platform_driver ps3_rtc_driver = {
> >                 .name = "rtc-ps3",
> >                 .owner = THIS_MODULE,
> >         },
> > -       .remove = __exit_p(ps3_rtc_remove),
> > +       .remove = ps3_rtc_remove,
> >  };
> >
> >  static int __init ps3_rtc_init(void)
> 
> Gr{oetje,eeting}s,
> 
>                         Geert
> 
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
> 
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
>                                 -- Linus Torvalds

