Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752795Ab3CFGhI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 01:37:08 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:30305 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752736Ab3CFGhC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 01:37:02 -0500
X-AuditID: cbfee690-b7f6b6d000004563-ff-5136e40c2987
From: Jingoo Han <jg1.han@samsung.com>
To: "'Venu Byravarasu'" <vbyravarasu@nvidia.com>
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, "'Tejun Heo'" <tj@kernel.org>,
        "'Greg KH'" <greg@kroah.com>,
        "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com
References: <12429277.417351362550362880.JavaMail.weblogic@epml07>
 <D958900912E20642BCBC71664EFECE3E6E4F721A62@BGMAIL02.nvidia.com>
In-reply-to: <D958900912E20642BCBC71664EFECE3E6E4F721A62@BGMAIL02.nvidia.com>
Subject: Re: [PATCH v3] rtc: add devm_rtc_device_{register,unregister}()
Date: Wed, 06 Mar 2013 15:36:59 +0900
Message-id: <006701ce1a35$016024b0$04206e10$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4aMaaTVvxe8MZBTaW0W/+zFuhrCgAABSdAAACHAdA=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrFIsWRmVeSWpSXmKPExsVy+t8zY12eJ2aBBrdm8lksuXiV3WLO+jVs
	FucWzGC0uLxrDpvF/s4ORotfy48yWjw6NJHZgd1jz8STbB6bVnWyebx9GOBxYsZvFo/e5nds
	HtPn/WTy+LxJLoA9issmJTUnsyy1SN8ugSvjxqtnjAUvhCr2X5zO2MB4lreLkZNDQsBE4l33
	fnYIW0ziwr31bF2MXBxCAssYJfbPvcbSxcgBVvRvKw9EfDqjxJHDr5khnF+MEi/nvAPrZhNQ
	k/jy5TA7SIOIgJ7E+eZKkBpmgYtANX0NrCA1QgKtjBKH+lxBbE4BX4ljDYeZQWxhAQ+Jg+c6
	GEFsFgFViT2zb4PZvAK2EgcbvzND2IISPybfYwGxmQW0JNbvPM4EYctLbF7zlhniUHWJR391
	QcIiAlYSt0/tZoQoEZHY9+IdI8g9EgKNHBLLb/6G2iUg8W3yIagnZSU2HWCGBISkxMEVN1gm
	MErMQrJ5FpLNs5BsnoVkxQJGllWMoqkFyQXFSelFJnrFibnFpXnpesn5uZsYIfE8YQfjvQPW
	hxiTgdZPZJYSTc4HpoO8knhDY2MTMxNTE3NLU3NT0oSVxHnlL8kECgmkJ5akZqemFqQWxReV
	5qQWH2Jk4uCUamCstfrTd0PMi6tqdaKfdkZnZrLqE4309uw8m/ma/7k5yyP2JGlUrpL8JXB7
	ir7+dsYpN8Kl83s7jmfwlMzk5ulvaEh16HhybvfJCv4vn6df+Vgevfq/777D/9qnL7hyW0pQ
	6sUrf9uDmdeXFeS9UjjZdaet6ZZOb5/vws9/WMOFzxZmJn9xWKrEUpyRaKjFXFScCAAV0/vG
	/QIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOKsWRmVeSWpSXmKPExsVy+t9jQV2eJ2aBBjNOcVgsuXiV3WLO+jVs
	FucWzGC0uLxrDpvF/s4ORotfy48yWjw6NJHZgd1jz8STbB6bVnWyebx9GOBxYsZvFo/e5nds
	HtPn/WTy+LxJLoA9qoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VW
	ycUnQNctMwfoICWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYR1jxo1XzxgL
	XghV7L84nbGB8SxvFyMHh4SAicS/rTxdjJxAppjEhXvr2boYuTiEBKYzShw5/JoZwvnFKPFy
	zjt2kCo2ATWJL18Os4M0iwjoSZxvrgSpYRa4CFTT18AKUiMk0MoocajPFcTmFPCVONZwmBnE
	FhbwkDh4roMRxGYRUJXYM/s2mM0rYCtxsPE7M4QtKPFj8j0WEJtZQEti/c7jTBC2vMTmNW+Z
	IY5Wl3j0VxckLCJgJXH71G5GiBIRiX0v3jFOYBSahWTSLCSTZiGZNAtJywJGllWMoqkFyQXF
	Sem5RnrFibnFpXnpesn5uZsYwcnimfQOxlUNFocYBTgYlXh4J6iYBQqxJpYVV+YeYpTgYFYS
	4eU6AxTiTUmsrEotyo8vKs1JLT7EmAz06ERmKdHkfGAiyyuJNzQ2MTOyNDKzMDIxNydNWEmc
	l/HUkwAhgfTEktTs1NSC1CKYLUwcnFINjFOsb15d6BvqOL84qPpSWbLEwpvTJ4qV/7L3rCw8
	dP47jwWf5tz5atGn3m9iFva9K/AnxX12lPpFt1vmD6f9Oa2i1CfEev/GtO6KG/ZJa6cIm/k/
	PLbKMmiKzt0rRXZCxfP+MLiJK6/gVJ6R6fp4+ZXdwQW1ze8mPRUV1Ln+Oe77m5sXa1POaCqx
	FGckGmoxFxUnAgBDir1JWgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

