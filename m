Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753418Ab3BOGhx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 01:37:53 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:51273 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751357Ab3BOGhv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 01:37:51 -0500
X-AuditID: cbfee691-b7f556d000001a24-a0-511dd7bda943
Date: Fri, 15 Feb 2013 06:37:49 +0000 (GMT)
From: Jingoo Han <jg1.han@samsung.com>
Subject: Re: [PATCH 03/11] rtc: rtc-efi: use pr_err()/pr_warn() instead of
 printk()
To: Venu Byravarasu <vbyravarasu@nvidia.com>,
        "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "'Alessandro Zummo'" <a.zummo@towertech.it>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>,
        Jingoo Han <jg1.han@samsung.com>
Reply-to: jg1.han@samsung.com
MIME-version: 1.0
X-MTR: 20130215063714533@jg1.han
Msgkey: 20130215063714533@jg1.han
X-EPLocale: en_US.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20130215063714533@jg1.han
X-ParentMTR: 
X-ArchiveUser: EV
X-CPGSPASS: Y
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <5139267.654181360910268438.JavaMail.weblogic@epml24>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMJsWRmVeSWpSXmKPExsVy+t8zfd2912UDDdp/qltc3jWHzYHR4/Mm
	uQDGqAZGm8Si5IzMslSF1Lzk/JTMvHRbpdAQN10LJYWM/OISW6VoIwNjPSNTEz0jE3M9S4NY
	KyNTJYW8xNxUW6UKXaheJYWi5AKg2tzKYqABOal6UHG94tS8FIes/FKQS/SKE3OLS/PS9ZLz
	c5UUyhJzSoFGKOknTGXMeLY7sOCHaEXn1LXsDYxrRLsYOTmEBJQkJp3cywhiSwiYSNxffp4J
	whaTuHBvPVsXIxdQzTJGiSUv/jLDFPW+mA2VmM8osWHiX7AOFgFViRnzGlhBbDYBdYkJv5tZ
	QGxhgWCJsydeATVwcIgIxEvcvhYE0ssscJlRovP+B1aIK2Ql7k2eDbaAV0BQ4uTMJywQyxQk
	utZ9YYKIK0qsXbIP6ggJiTv397NC2LwSM9qfQtXLSUz7ugaqRlri/KwNjDDfLP7+GCrOL3Hs
	9g4mkHtAep/cD4YZs3vzFzYIW0Bi6pmDUK2qEneXnoey+STWLHwLtUpQ4vS1bmaY3oaNv9lB
	bGagM6d0P4SytSS+/NjHhu4tXgFHiW9bZjNOYFSehSQ1C0n7LCTtyGoWMLKsYhRNLUguKE5K
	LzJFjuxNjJA0OHEH4/0D1ocY9zMC42Qis5Rocj4wkeaVxBsaG5uYmZiamFuamptSIGxuZGoA
	TKkGhtQRVhLnlb8kEygkkJ5YkpqdmlqQWhRfVJqTWnyIkYmDU6qBcV+S26Zw61WLntVL6Bg8
	3aqTtGROmYtwGNv9eOsvlyTmb5wR/++262Mb5diEPacfXLi+tXDdi+jnHhcPrefc7XwvY+NR
	wei0ZTz7VC6zdciofF6Zydn124p3N2/ry1uz354zur7b7fwTjwcarnxRDR80BJ6qzb/Izfyu
	LXTpzg/VF/WNEx7tmaLEUpyRaKjFXFScCAAFEp7u9gMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpkk+LIzCtJLcpLzFFi42I5/e/2DN2912UDDZa0qlhc3jWHzYHR4/Mm
	uQDGqAybjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKCh
	SgpliTmlQKGAxOJiJX07m6L80pJUhYz84hJbpWgjA2M9I1MTPSNjAz1jy1grQwMDI1OgqoSM
	jGe7Awt+iFZ0Tl3L3sC4RrSLkZNDSEBJYtLJvYwgtoSAiUTvi9lsELaYxIV764FsLqCa+YwS
	Gyb+ZQJJsAioSsyY18AKYrMJqEtM+N3MAmILCwRLnD3xCqiBg0NEIF7i9rUgkF5mgcuMEp33
	P7BCLJOVuDd5NjOIzSsgKHFy5hMWiGUKEl3rvjBBxBUl1i7ZxwwRl5C4c38/K4TNKzGj/SlU
	vZzEtK9roGqkJc7P2sAIc/Ti74+h4vwSx27vYAK5B6T3yf1gmDG7N3+B+lFAYuqZg1CtqhJ3
	l56Hsvkk1ix8C7VKUOL0tW5mmN6Gjb/ZQWxmoDOndD+EsrUkvvzYx4buLV4BR4lvW2YzTmCU
	m4UkNQtJ+ywk7chqFjCyrGIUTS1ILihOSk811CtOzC0uzUvXS87P3cQITlDPuHcwzmqwOMQo
	wMGoxMMrICEbKMSaWFZcmXuIUYKDWUmEd00IUIg3JbGyKrUoP76oNCe1+BBjMjACJzJLiSbn
	A5NnXkm8obGxiZmJqbmBhYGlOWnCSuK8ChXTA4QE0hNLUrNTUwtSi2C2MHFwSjUwLr5z/ZuN
	wCTVwDuzreVnh62zvRcb+7T2V/jE3kXhspPbHy/k/ne2+9ua3t+vYqpKf2dnHFGfOUFo3YST
	t7bNap15I/eGdVHs27OPt+xtPv5qc8ZLgbTMqTUHp+nElF+9fy+QwVTKrsbK1OWXzoE6jvlN
	vr0Pior0450+nVrPckNYJz7bSMnqmRJLcUaioRZzUXEiADHgZ/+UAwAA
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r1F6bptN008743

On Friday, February 15, 2013 3:04 PM, Venu Byravarasu wrote:
> 
> > -----Original Message-----
> > From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-
> > owner@vger.kernel.org] On Behalf Of Jingoo Han
> > Sent: Friday, February 15, 2013 11:29 AM
> > To: 'Andrew Morton'
> > Cc: linux-kernel@vger.kernel.org; 'Alessandro Zummo'; rtc-
> > linux@googlegroups.com; 'Jingoo Han'
> > Subject: [PATCH 03/11] rtc: rtc-efi: use pr_err()/pr_warn() instead of printk()
> >
> > Fixed the checkpatch warnings as below:
> >
> >   WARNING: Prefer netdev_err(netdev, ... then dev_err(dev, ... then pr_err(...
> > to printk(KERN_ERR ...
> >   WARNING: please, no space before tabs
> >
> > Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> > ---
> >  drivers/rtc/rtc-efi.c |   10 ++++++----
> >  1 files changed, 6 insertions(+), 4 deletions(-)
> >
> >  	eft->timezone	= EFI_UNSPECIFIED_TIMEZONE;
> > @@ -142,7 +144,7 @@ static int efi_set_alarm(struct device *dev, struct
> > rtc_wkalrm *wkalrm)
> >  	 */
> >  	status = efi.set_wakeup_time((efi_bool_t)wkalrm->enabled, &eft);
> >
> > -	printk(KERN_WARNING "write status is %d\n", (int)status);
> > +	pr_warn("write status is %d\n", (int)status);
> 
> Why don't you use dev_warn itself?

OK, I will change it.
Thank you.

Best regards,
Jingoo Han

> 
> >
> >  	return status == EFI_SUCCESS ? 0 : -EINVAL;
> >  }
> > @@ -157,7 +159,7 @@ static int efi_read_time(struct device *dev, struct
> > rtc_time *tm)
> >
> >  	if (status != EFI_SUCCESS) {
> >  		/* should never happen */
> > -		printk(KERN_ERR "efitime: can't read time\n");
> > +		pr_err("can't read time\n");
> 
> Why don't you use dev_err itself?
> 
> >  		return -EINVAL;
> >  	}
> >
> > --
> > 1.7.2.5
> >
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
