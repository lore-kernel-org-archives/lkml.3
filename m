Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754833AbaDPHyj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 03:54:39 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:33793 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751475AbaDPHyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 03:54:38 -0400
X-AuditID: cbfee68d-b7fcd6d00000315b-d9-534e373b96c9
From: Jingoo Han <jg1.han@samsung.com>
To: "'Dan Carpenter'" <dan.carpenter@oracle.com>,
        "'Thomas Tanaka'" <thomas.tanaka@gmail.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        bernat.ada@gmail.com, keescook@chromium.org,
        peter.p.waskiewicz.jr@intel.com, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, "'Jingoo Han'" <jg1.han@samsung.com>
References: <1397609680-10321-1-git-send-email-thomas.tanaka@gmail.com>
 <20140416074410.GO26890@mwanda>
In-reply-to: <20140416074410.GO26890@mwanda>
Subject: Re: [PATCH] staging: dgrp: Fixed coding style
Date: Wed, 16 Apr 2014 16:54:35 +0900
Message-id: <002d01cf5949$1c273550$54759ff0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac9ZR7WFd8kUwvFeRSK0D4I5yUw3cgAARIeQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpileLIzCtJLcpLzFFi42I5/e+Zvq61uV+wweJlFhZz1q9hszh65ieb
	xet/01ks9pz5xW7RvHg9m8XlhZdYLc5051pc3jWHzeLNvp0sFhtnTWBx4PKY3XCRxePevsMs
	Hjtn3WX3WLznJZPHiRm/WTz2z13D7vHx6S0Wj74tqxg9Pm+SC+CM4rJJSc3JLEst0rdL4Mr4
	fvY6e0EDV8Xk/acZGxi7OLoYOTkkBEwkfp3eywZhi0lcuLceyObiEBJYxijxamUfI0xR78Zm
	JhBbSGA6o8SNBjGIot+MEmcm3wHrZhNQk/jy5TB7FyMHh4hAtMSHphqQGmaB14wSl/unQDVn
	Suz4fxmsnlNAR+Lks13sILawgJnEq+3nmUB6WQRUJfbNjAIJ8wrYSqy608oOYQtK/Jh8jwXE
	ZhbQkli/8zgThC0vsXnNW2aQVgkBdYlHf3VBwiICRhL9SycwQpSISOx78Y4R5BwJgYUcEn9a
	F4AlWAQEJL5NPsQC0SsrsekAM8S7khIHV9xgmcAoMQvJ5llINs9CsnkWkhULGFlWMYqmFiQX
	FCelFxnqFSfmFpfmpesl5+duYoTEf+8OxtsHrA8xJgOtn8gsJZqcD0wfeSXxhsZmRhamJqbG
	RuaWZqQJK4nzJj1MChISSE8sSc1OTS1ILYovKs1JLT7EyMTBKdXAWBn212vD/R8LxSq2uM5q
	25zKq31e4vbmI7pP7d8YWT7fkD7h8ca8ryVOTvPtezV3S9p/aWJP0/J3nbOlPdOgSKlC8YfQ
	1SaPbEadc9ETHrH7yZ3IY+R/oag3g+XCQebKqnSVML2DDy7+eyFpGe5QuWaLjIHuqdD/Dkxt
	WXrv+bwvMF0JDrVRYinOSDTUYi4qTgQADAXvphUDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPKsWRmVeSWpSXmKPExsVy+t9jQV1rc79ggzUvjCzmrF/DZnH0zE82
	i9f/prNY7Dnzi92iefF6NovLCy+xWpzpzrW4vGsOm8WbfTtZLDbOmsDiwOUxu+Eii8e9fYdZ
	PHbOusvusXjPSyaPEzN+s3jsn7uG3ePj01ssHn1bVjF6fN4kF8AZ1cBok5GamJJapJCal5yf
	kpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQN0qZJCWWJOKVAoILG4WEnfDtOE
	0BA3XQuYxghd35AguB4jAzSQsI4x4/vZ6+wFDVwVk/efZmxg7OLoYuTkkBAwkejd2MwEYYtJ
	XLi3ng3EFhKYzihxo0Gsi5ELyP7NKHFm8h2wBJuAmsSXL4fZuxg5OEQEoiU+NNWA1DALvGaU
	uNw/hQmiOVNix//LYPWcAjoSJ5/tYgexhQXMJF5tP88E0ssioCqxb2YUSJhXwFZi1Z1Wdghb
	UOLH5HssIDazgJbE+p3HmSBseYnNa94yg7RKCKhLPPqrCxIWETCS6F86gRGiRERi34t3jBMY
	hWYhmTQLyaRZSCbNQtKygJFlFaNoakFyQXFSeq6hXnFibnFpXrpecn7uJkZwcnkmtYNxZYPF
	IUYBDkYlHt4ZOb7BQqyJZcWVuYcYJTiYlUR4FYz8goV4UxIrq1KL8uOLSnNSiw8xJgP9OZFZ
	SjQ5H5j48kriDY1NzIwsjcwsjEzMzUkTVhLnPdBqHSgkkJ5YkpqdmlqQWgSzhYmDU6qBscg+
	X0jl9PETH9c8vf9+aequf8duR3/96sn6+raIwgImoRklSRrdrCyW35r82zenmDjITPdZ7u6o
	HrXR3u/5lIkTPmkcDd70okhWSfrBvMbeUxa+JhHFkj2N1a0/LvrOFTn1SWxb8C7Neq1Hs9f0
	X7yZ723feMfy077nAalrrunkPug10eHTUGIpzkg01GIuKk4EAJs+z29yAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, April 16, 2014 4:44 PM, Dan Carpenter wrote:
> On Tue, Apr 15, 2014 at 05:54:39PM -0700, Thomas Tanaka wrote:
> > Fixed line width > 80
> >
> > Signed-off-by: Thomas Tanaka <thomas.tanaka@gmail.com>
> > ---
> >  drivers/staging/dgrp/dgrp_sysfs.c |    4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/staging/dgrp/dgrp_sysfs.c b/drivers/staging/dgrp/dgrp_sysfs.c
> > index 2f9345f..93803e0c 100644
> > --- a/drivers/staging/dgrp/dgrp_sysfs.c
> > +++ b/drivers/staging/dgrp/dgrp_sysfs.c
> > @@ -108,8 +108,8 @@ int dgrp_create_class_sysfs_files(void)
> >  	ret = sysfs_create_group(&dgrp_class_global_settings_dev->kobj,
> >  		&dgrp_global_settings_attribute_group);
> >  	if (ret) {
> > -		pr_alert("%s: failed to create sysfs global settings device attributes.\n",
> > -			__func__);
> > +		pr_alert("%s: failed to create sysfs global settings device
> > +			 attributes.\n", __func__);
> 
> The original was fine.  It doesn't cause a checkpatch.pl warning.  The
> new one is buggy and won't print the correct text.

Yes, right. In this case, it prints some tabs between 'device'
and 'attributes.' So, this patch should be NAKed.

Best regards,
Jingoo Han

> 
> regards,
> dan carpenter


