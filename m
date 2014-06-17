Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932286AbaFQDvp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 23:51:45 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:16933 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754926AbaFQDvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 23:51:43 -0400
X-AuditID: cbfee690-b7fb56d000003439-a9-539fbb4d16e0
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: "'Tomasz Figa'" <t.figa@samsung.com>, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: kgene.kim@samsung.com, arnd@arndb.de
References: <1399706287-13919-1-git-send-email-y@samsung.com>
 <1399706419-13976-1-git-send-email-pankaj.dubey@samsung.com>
 <1399706419-13976-5-git-send-email-pankaj.dubey@samsung.com>
 <53970E8E.5030408@samsung.com>
In-reply-to: <53970E8E.5030408@samsung.com>
Subject: RE: [PATCH v3 4/6] ARM:  EXYNOS: Remove unused header inclusion from
 hotplug.c
Date: Tue, 17 Jun 2014 09:22:20 +0530
Message-id: <000201cf89df$8dbd9d00$a938d700$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQFGFxwhMBc3rJ51QTN4z3RDiHZXkQKOC0AUAmIYkcICKwQctZxOtwFw
Content-language: en-us
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJIsWRmVeSWpSXmKPExsWyRsSkWtd39/xggxk/OC3+TjrGbtG74Cqb
	xabH11gtLu+aw2Yx4/w+Jov1M16zOLB5/P41idFj85J6j74tqxg9Pm+SC2CJ4rJJSc3JLEst
	0rdL4Mo4d+wfS8E+9oruhRtZGhjfsnYxcnJICJhInHrXwQhhi0lcuLeerYuRi0NIYCmjxIuH
	85lgij72fGSCSExnlFjWcIIRwvnLKNG65BQLSBWbgK7Ek/dzmUESIgL9jBIvt/4A2sHBwSyg
	IXH1lT9Ewx1GiZUL/oI1cApoS0y63MAOYgsLREpc/7wRLM4ioCoxZddOsPt4BSwlPj46ygRh
	C0r8mHwPrIZZQEti/c7jTBC2vMTmNW+ZIU5VkNhx9jXYPyICbhJPFv9kg6gRl5j04CE7yBES
	AvfYJRoefoZaJiDxbfIhFpBDJQRkJTYdgJojKXFwxQ2WCYwSs5CsnoVk9Swkq2chWbGAkWUV
	o2hqQXJBcVJ6kYlecWJucWleul5yfu4mRmC0nv73bMIOxnsHrA8xJgOtn8gsJZqcD4z2vJJ4
	Q2MzIwtTE1NjI3NLM9KElcR51R4lBQkJpCeWpGanphakFsUXleakFh9iZOLglGpgLJLYx1ec
	6pd9uaop13/5fl6BC1NMVottzy86c/tT149JM9e5zdrw70WmTu3swk/O6lPPbd/GPHn2ltjn
	awrPeuz7KqQ861PMQm33sisKLzd+yF822+fkSz6Gy3v3JjPLrvYX9RZ/kBSq9TB222o+tuyQ
	7Vyznl+4IcSXvTBh+6GaksxLzT13ViixFGckGmoxFxUnAgDFGPqv7AIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGKsWRmVeSWpSXmKPExsVy+t9jQV3f3fODDT7fZLT4O+kYu0Xvgqts
	FpseX2O1uLxrDpvFjPP7mCzWz3jN4sDm8fvXJEaPzUvqPfq2rGL0+LxJLoAlqoHRJiM1MSW1
	SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwdouZJCWWJOKVAoILG4
	WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsIYx49yxfywF+9gruhduZGlgfMvaxcjJISFgIvGx
	5yMThC0mceHeerYuRi4OIYHpjBLLGk4wQjh/GSVal5xiAaliE9CVePJ+LjNIQkSgn1Hi5dYf
	QKM4OJgFNCSuvvKHaLjDKLFywV+wBk4BbYlJlxvYQWxhgUiJ6583gsVZBFQlpuzaCXYGr4Cl
	xMdHR5kgbEGJH5PvgdUwC2hJrN95nAnClpfYvOYtM8SpChI7zr5mBLFFBNwkniz+yQZRIy4x
	6cFD9gmMQrOQjJqFZNQsJKNmIWlZwMiyilE0tSC5oDgpPddQrzgxt7g0L10vOT93EyM4FTyT
	2sG4ssHiEKMAB6MSD+9D2fnBQqyJZcWVuYcYJTiYlUR4ucyBQrwpiZVVqUX58UWlOanFhxiT
	gT6dyCwlmpwPTFN5JfGGxibmpsamliYWJmaWpAkrifMeaLUOFBJITyxJzU5NLUgtgtnCxMEp
	1cCYy6+6/yLTnCMb8i3WmYgxe6S/2Hdm2t5bf0on2jpU3WKRDc9PPzNVPyH1pgXjynaZpH+N
	XzxWWClvvp+60bFzpb7vRu+njjz++WuUl3+a8yjoetvHsz/WHPxfo/O2c419/4r020fWbTsr
	/lfn+slJe4wPBp9cPd1JesrsTp/wO58c1tyY/ozZRomlOCPRUIu5qDgRALnHq6hJAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomasz,


> -----Original Message-----
> 
> Hi Pankaj,
> 
> On 10.05.2014 09:20, Pankaj Dubey wrote:
> > This patch removed "plat/cpu.h" inclusion from hotplug.c as it is not
> > required.
> >
> > Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
> > ---
> >  arch/arm/mach-exynos/hotplug.c |    2 --
> >  1 file changed, 2 deletions(-)
> >
> > diff --git a/arch/arm/mach-exynos/hotplug.c
> > b/arch/arm/mach-exynos/hotplug.c index 0243ef3..5e19601 100644
> > --- a/arch/arm/mach-exynos/hotplug.c
> > +++ b/arch/arm/mach-exynos/hotplug.c
> > @@ -19,8 +19,6 @@
> >  #include <asm/cp15.h>
> >  #include <asm/smp_plat.h>
> >
> > -#include <plat/cpu.h>
> > -
> >  #include "common.h"
> >  #include "regs-pmu.h"
> >
> >
> 
> I don't see this header being included in current linux-next.
> 

OK, if it's already taken care, I will drop this change in next version.

> Best regards,
> Tomasz

Thanks,
Pankaj Dubey

