Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753526Ab3CFGhq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 01:37:46 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:37522 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752536Ab3CFGhn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 01:37:43 -0500
X-AuditID: cbfee68d-b7f636d0000009be-cf-5136e42a3f1c
Date: Wed, 06 Mar 2013 06:37:30 +0000 (GMT)
From: Jingoo Han <jg1.han@samsung.com>
Subject: Re: [PATCH v3] rtc: add devm_rtc_device_{register,unregister}()
To: Venu Byravarasu <vbyravarasu@nvidia.com>
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "'Tejun Heo'" <tj@kernel.org>, "'Greg KH'" <greg@kroah.com>,
        Jingoo Han <jg1.han@samsung.com>,
        "'Alessandro Zummo'" <a.zummo@towertech.it>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>
Reply-to: jg1.han@samsung.com
MIME-version: 1.0
X-MTR: 20130306063639922@jg1.han
Msgkey: 20130306063639922@jg1.han
X-EPLocale: en_US.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20130306063639922@jg1.han
X-ParentMTR: 
X-ArchiveUser: EV
X-CPGSPASS: Y
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <29641598.418931362551849471.JavaMail.weblogic@epml07>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCJsWRmVeSWpSXmKPExsVy+t8zA12tJ2aBBssbNC0u75rD5sDo8XmT
	XABjVAOjTWJRckZmWapCal5yfkpmXrqtUmiIm66FkkJGfnGJrVK0kYGxnpGpiZ6RibmepUGs
	lZGpkkJeYm6qrVKFLlSvkkJRcgFQbW5lMdCAnFQ9qLhecWpeikNWfinIJXrFibnFpXnpesn5
	uUoKZYk5pUAjlPQTpjJmfH2/irngkWTF1E8nWBoYOyS7GDk5hASUJCad3MsIYksImEi8n/2f
	CcIWk7hwbz1bFyMXUM0yRoml8xewwBT9O7WKGSIxn1Hi85zVYAkWARWJVy/es4PYbALqEhN+
	N4PFhQU8JA6e6wDbICKgJ7Ho5SkWkGZmgaNMEofXHWOFOENW4t7k2cwgNq+AoMTJmU+gtilI
	nDv6hBEiriixZMsaqFMlJO7c388KYfNKzGh/ClUvJzHt6xpmCFta4vysDYww7yz+/hgqzi9x
	7PYOoDc5wHqf3A+GGbN78xc2CFtAYuqZg4wQJaoSx48JQ4T5JNYsfAu1SVDi9LVuZpjWho2/
	wV5nBrpySvdDKFtL4suPfWzovuIVcJI48OUm4wRG5VlIUrOQtM9C0o6sZgEjyypG0dSC5ILi
	pPQiQ+TY3sQISYS9OxhvH7A+xLifERgnE5mlRJPzgak0ryTe0NjYxMzE1MTc0tTclAJhcyNT
	A2BSNTCkjrCSOK/cJZlAIYH0xJLU7NTUgtSi+KLSnNTiQ4xMHJxSDYzLpkaq1IcGPDiUmNR9
	Uuh/UpPE77Ve/1fxtbgHf3ntvPjBNWe/a1928Kf+FbtXsnYWj+YcxzNqigcCmvbNLH4SdvXL
	j+2POQ/8izmy8FXV8ai+hTtuLf5ZonQ8zU4o7/LkCuu1D06nhj2ftLGg00DgkHOhaKWSuvyz
	zLaIVXfMbTY7Z5foXpBSYinOSDTUYi4qTgQAMmQc/vcDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpik+LIzCtJLcpLzFFi42I5/e/2DF2tJ2aBBgt2qVhc3jWHzYHR4/Mm
	uQDGqAybjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKCh
	SgpliTmlQKGAxOJiJX07m6L80pJUhYz84hJbpWgjA2M9I1MTPSNjAz1jy1grQwMDI1OgqoSM
	jK/vVzEXPJKsmPrpBEsDY4dkFyMnh5CAksSkk3sZQWwJAROJf6dWMUPYYhIX7q1n62LkAqqZ
	zyjxec5qFpAEi4CKxKsX79lBbDYBdYkJv5vB4sICHhIHz3WADRIR0JNY9PIUC0gzs8BRJonD
	646xQmyTlbg3eTbYBl4BQYmTM5+wQGxTkDh39AkjRFxRYsmWNVAXSUjcub+fFcLmlZjR/hSq
	Xk5i2tc1UJdKS5yftYER5urF3x9Dxfkljt3ewdTFyAHW++R+MMyY3Zu/sEHYAhJTzxxkhChR
	lTh+TBgizCexZuFbqE2CEqevdTPDtDZs/A32OjPQlVO6H0LZWhJffuxjQ/cVr4CTxIEvNxkn
	MMrNQpKahaR9FpJ2ZDULGFlWMYqmFiQXFCelVxjqFSfmFpfmpesl5+duYgSnqGcLdzB+OW99
	iFGAg1GJh9dCySxQiDWxrLgy9xCjBAezkggv1xmgEG9KYmVValF+fFFpTmrxIcZkYAROZJYS
	Tc4Hps+8knhDY2MTMxNTcwMLA0tz0oSVxHmPm6sHCgmkJ5akZqemFqQWwWxh4uCUamD04z0r
	8CF8tcr52QUeaQJPGzObLovl1V6P22AyUef9+YVLrMurj3OLlGh5We46p5BdcyTnJ0fesgN2
	b23E5/3ZqLHfenqienbCL6+3Nx+H5svc7Y/+4fChy/NB76EkDfH/uq3205m+u7w5qOPyQ6rA
	oprbqvGdyOrn3RIs6pndtZ9mJc0M/KXEUpyRaKjFXFScCAB79qg3lQMAAA==
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r266bmZc011939

On Wednesday, March 06, 2013 3:19 PM, Venu Byravarasu wrote:
> On Wednesday, March 06, 2013 11:43 AM, Jingoo Han wrote:
> >
> > On Wednesday, March 06, 2013 3:03 PM, Venu Byravarasu wrote:
> > >
> > > > --- a/drivers/rtc/class.c
> > > > +++ b/drivers/rtc/class.c
> > >
> > > > +/**
> > > > + * devm_rtc_device_register - resource managed rtc_device_register()
> > > > + * @name: the name of the device
> > > > + * @dev: the device to register
> > > > + * @ops: the rtc operations structure
> > > > + * @owner: the module owner
> > > > + *
> > > > + * @return a struct rtc on success, or an ERR_PTR on error
> > > > + *
> > > > + * Managed rtc_device_register(). The rtc_device returned from this
> > > > function
> > > > + * are automatically freed on driver detach. See rtc_device_register()
> > > > + * for more information.
> > > > + */
> > > > +
> > > > +struct rtc_device *devm_rtc_device_register(const char *name,
> > > > +					struct device *dev,
> > >
> > > As most of devm_* functions use  " struct device *dev" as their first param,
> > > why not this function also modified to be in sync with them?
> >
> > Yes, but, I want to sync with the form of rtc_device_register().
> > This function already uses 'struct device *dev' as second argument as below.
> >
> 
> IMO any kernel driver developer using devm_* API, expects struct device* as first argument.
> Breaking this policy for one module (RTC here) & making this API special, might not be a good idea.
> Anyhow, maintainers may add their comments on this.

OK, I see.

I just look at other devm_* API. All devm_* APIs use 'struct device*'
as first argument.

To prevent the confusion, I will send the patch that uses
'struct device*' as first argument as below.

 struct rtc_device *devm_rtc_device_register(struct device *dev,
                                         const char *name,

Thanks for your comment

Best regards,
Jingoo Han

> 
> Thanks,
> Venu
> 
> >  struct rtc_device *rtc_device_register(const char *name, struct device *dev,
> >                                          const struct rtc_class_ops *ops,
> >                                          struct module *owner)
> >
> > Best regards,
> > Jingoo Han
> >
> > >
> > > > +					const struct rtc_class_ops *ops,
> > > > +					struct module *owner)
> > > > +{
> > > > +	struct rtc_device **ptr, *rtc;
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
