Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754814Ab3IZD4l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 23:56:41 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:64713 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751172Ab3IZD4j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 23:56:39 -0400
X-AuditID: cbfee68e-b7f756d000004512-67-5243b0758bc4
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Tomasz Figa'" <t.figa@samsung.com>,
        "'Mateusz Krawczuk'" <m.krawczuk@partner.samsung.com>
Cc: ben-linux@fluff.org, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        m.szyprowski@samsung.com,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>
References: <1379931289-29384-1-git-send-email-m.krawczuk@partner.samsung.com>
 <2025079.MVbFYJdokX@amdc1227>
In-reply-to: <2025079.MVbFYJdokX@amdc1227>
Subject: RE: [PATCH] DT: if dt is available don't use s3c_arch_init
Date: Thu, 26 Sep 2013 12:56:37 +0900
Message-id: <029601ceba6c$661bdf20$32539d60$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac64Wa3u7cZmBXNqTFSTb6DPtV6xtwCEmO7Q
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrPIsWRmVeSWpSXmKPExsVy+t8zQ93SDc5BBmc+ylhMWneAyeJs0xt2
	i02Pr7FaXN41h81ixvl9TBa3L/NanF5zitli7ZG77BbrZ7xmceD0aGnuYfP4u+oFs8fmJfUe
	B9/tYfLo27KK0ePzJrkAtigum5TUnMyy1CJ9uwSujFPr1jEXvOOuWLCmmbWBcR9nFyMnh4SA
	icSm92+YIGwxiQv31rN1MXJxCAksY5T4c+o7excjB1jR6XXmEPFFjBLzX69kh3D+Mkqsvr6b
	HaSbTUBD4vD7Z2C2iECsxMM9V5hAipgFHjNK3Fq2GCwhJJAn0bvlOtg6TgEtiW1HnoLFhQWc
	JZ587GQFsVkEVCXe/O0Eq+EVsJXo6f7JDGELSvyYfI8FxGYG6l2/8zgThC0vsXnNW2aIS9Ul
	Hv3VhbjBSOLzp+lsECUiEvtevGMEuUdCoJFDYvqPHYwQuwQkvk0+xALRKyux6QAzJCQkJQ6u
	uMEygVFiFpLNs5BsnoVk8ywkKxYwsqxiFE0tSC4oTkovMtIrTswtLs1L10vOz93ECInsvh2M
	Nw9YH2JMBlo/kVlKNDkfmBjySuINjc2MLExNTI2NzC3NSBNWEudVa7EOFBJITyxJzU5NLUgt
	ii8qzUktPsTIxMEp1cDo7zm5P0Xo/6M9WtOK9hdcMVuaJHSCpfyY4JXTomseizMfCv/98eeS
	TVb1flUHU7OPVIupb+FieTyjneeu9nzVSP7lmzUu/2Fr7vOKepitr5T0fYWMDtuhquan87Te
	LNjbKn/G3HnXqksf2PwFzm3trbHSa/PxfLbil1vr5Q0Be9cvnMt+zLJXiaU4I9FQi7moOBEA
	1fBOSgIDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDKsWRmVeSWpSXmKPExsVy+t9jAd3SDc5BBn9aJSwmrTvAZHG26Q27
	xabH11gtLu+aw2Yx4/w+Jovbl3ktTq85xWyx9shddov1M16zOHB6tDT3sHn8XfWC2WPzknqP
	g+/2MHn0bVnF6PF5k1wAW1QDo01GamJKapFCal5yfkpmXrqtkndwvHO8qZmBoa6hpYW5kkJe
	Ym6qrZKLT4CuW2YO0FFKCmWJOaVAoYDE4mIlfTtME0JD3HQtYBojdH1DguB6jAzQQMI6xoxT
	69YxF7zjrliwppm1gXEfZxcjB4eEgInE6XXmXYycQKaYxIV769m6GLk4hAQWMUrMf72SHcL5
	yyix+vpudpAqNgENicPvn4HZIgKxEg/3XGECKWIWeMwocWvZYrCEkECeRO+W60wgNqeAlsS2
	I0/B4sICzhJPPnaygtgsAqoSb/52gtXwCthK9HT/ZIawBSV+TL7HAmIzA/Wu33mcCcKWl9i8
	5i0zxNXqEo/+6kLcYCTx+dN0NogSEYl9L94xTmAUmoVk0iwkk2YhmTQLScsCRpZVjKKpBckF
	xUnpuUZ6xYm5xaV56XrJ+bmbGMFp45n0DsZVDRaHGAU4GJV4eC8wOwcJsSaWFVfmHmKU4GBW
	EuH9ZgQU4k1JrKxKLcqPLyrNSS0+xJgM9OhEZinR5HxgSssriTc0NjEzsjQyszAyMTcnTVhJ
	nPdgq3WgkEB6YklqdmpqQWoRzBYmDk6pBsb2rD2ikZ9uWTR7mH2auXuOoLTChvLZ7U0iR5YL
	/46d5CB/STpFv/Tg0q1fr/yRUJdlttrYFhQ+f1vT7dBD+u+8r4o217bx9lgkufxaOnvHfrX1
	ExgbXIsZC6z+Wq5aaTP53ZyKq9a3vh7dG9p8cfrjU0m5734ItYTXL5nWfNf9pNjvfRqix34p
	sRRnJBpqMRcVJwIA+xUb6l8DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tomasz Figa wrote:
> 
> Hi Mateusz,
> 
> On Monday 23 of September 2013 12:14:49 Mateusz Krawczuk wrote:
> > It prevents from executing platform code, when booting from device tree.
> >
> > Signed-off-by: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
> > Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> > ---
> >  arch/arm/plat-samsung/init.c | 3 +++
> >  1 file changed, 3 insertions(+)
> >
> > diff --git a/arch/arm/plat-samsung/init.c b/arch/arm/plat-samsung/init.c
> > index aa9511b..0ace02d 100644
> > --- a/arch/arm/plat-samsung/init.c
> > +++ b/arch/arm/plat-samsung/init.c
> > @@ -20,6 +20,7 @@
> >  #include <linux/module.h>
> >  #include <linux/interrupt.h>
> >  #include <linux/ioport.h>
> > +#include <linux/of.h>
> >  #include <linux/serial_core.h>
> >  #include <linux/platform_device.h>
> >  #include <linux/of.h>
> > @@ -152,6 +153,8 @@ static int __init s3c_arch_init(void)
> >  {
> >  	int ret;
> >
> > +	if (of_have_populated_dt())
> > +		return 0;
> 
> I'm not sure if this is the correct thing to do here (note platforms that
> still want this initialization to be handled, even when booting with DT).
> 
> The DT case is already handled several lines below in if (cpu == NULL)
> check and if your platform requires this initialization not to happen you
> should assure it has cpu == NULL.
> 
Yeah, I agree and I think this is not needed at this moment we could cleanup
the init functions later for Samsung SoCs though.

Thanks,
Kukjin

