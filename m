Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751722AbaLSCOr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 21:14:47 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:50852 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751158AbaLSCOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 21:14:45 -0500
X-AuditID: cbfee68e-f79b46d000002b74-6d-54938a13e98c
Date: Fri, 19 Dec 2014 02:11:31 +0000 (GMT)
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: Re: Re: [PATCHv4 1/8] devfreq: event: Add new devfreq_event class to
 provide basic data for devfreq governor
To: =?utf-8?Q?=EC=B5=9C=EC=B0=AC=EC=9A=B0?= <cw00.choi@samsung.com>
Cc: =?utf-8?Q?=EA=B9=80=EA=B5=AD=EC=A7=84?= <kgene.kim@samsung.com>,
        =?utf-8?Q?=EB=B0=95=EA=B2=BD=EB=AF=BC?= <kyungmin.park@samsung.com>,
        "rafael.j.wysocki@intel.com" <rafael.j.wysocki@intel.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        ABHILASH KESAVAN <a.kesavan@samsung.com>,
        "tomasz.figa@gmail.com" <tomasz.figa@gmail.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        =?utf-8?Q?=EB=8C=80=EC=9D=B8=EA=B8=B0?= <inki.dae@samsung.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>
Reply-to: myungjoo.ham@samsung.com
MIME-version: 1.0
X-MTR: 20141219003531060@myungjoo.ham
Msgkey: 20141219003531060@myungjoo.ham
X-EPLocale: ko_KR.utf-8
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-MLAttribute: 
X-RootMTR: 20141219003531060@myungjoo.ham
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
X-ConfirmMail: N,general
Content-type: text/plain; charset=utf-8
MIME-version: 1.0
Message-id: <1107836838.16761418955089663.JavaMail.weblogic@epmlwas08d>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMIsWRmVeSWpSXmKPExsWyRsSkQFe4a3KIQetaSYvLu+awOTB6fN4k
	F8AYxWWTkpqTWZZapG+XwJWxaMoSloJ1GhUXVneyNzAuUe9i5OQQElCXWLTkJBuILSFgIjG/
	8SszhC0mceHeeqA4F1DNUkaJf3NWwBVNnf6eESIxh1Giq2kRC0iCRUBV4v7Hz0BFHBxsAnoS
	Mz8ng4SFBUolnh6+DtYrIuAqsXItSDkXB7PAcjaJh9OfMENcoSSxZt8rsDm8AoISJ2c+YQGZ
	IwE0c+oZa4iwmsSj5ndQN4hLXJh7iR3C5pWY0f6UBcKWk5j2dQ3UA9IS52dtYIR5ZvH3x1Bx
	foljt3cwQdgCQOMPQtVoSfxaMQXK5pNYs/AtC0z9rlPLmWF23d8yF6pXQmJryxNWEJtZQFFi
	SvdDdpCTmQU0Jdbv0kf1CYjtLnHh11JweEoITOSQePjiGuMERqVZSOpmIRk1C2EUspIFjCyr
	GEVTC5ILipPSi4z0ihNzi0vz0vWS83M3MQLTwul/z/p2MN48YH2IUYCDUYmHt6NwcogQa2JZ
	cWXuIUZTYCRNZJYSTc4HJp+8knhDYzMjC1MTU2Mjc0szJXHeBKmfwUIC6YklqdmpqQWpRfFF
	pTmpxYcYmTg4pRoYI60SribyC92q57l5vGZu6LaIFW2GTIqTXucFifj8vMPKHMOjVvFROv3x
	+3cca4ImW+5Z6bZ4om/vKtNfzN+DT3N+XdN8Y33GHtZ50WWzRKdp9y+pvRPmqBz6N3BdilPU
	nqYnvLIX22pN60QCtY0vsaR87QriMsmVOFW5+8JDljUrX+xkSYpTYinOSDTUYi4qTgQAEXLZ
	XgYDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCKsWRmVeSWpSXmKPExsVy+t/tXt3gzskhBvs+Gllc3jWHzYHR4/Mm
	uQDGqDSbjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKCh
	SgpliTmlQKGAxOJiJX07m6L80pJUhYz84hJbpWhDcyM9IwM9UyM9Q+NYK0MDAyNToJqEtIxF
	U5awFKzTqLiwupO9gXGJehcjJ4eQgLrEoiUn2UBsCQETianT3zNC2GISF+6tB4pzAdXMYZTo
	alrEApJgEVCVuP/xM1CCg4NNQE9i5udkkLCwQKnE08PXweaICLhKrFwLUs7FwSywnE3i4fQn
	zBDLlCTW7HsFNodXQFDi5MwnLCBzJIBmTj1jDRFWk3jU/A7qHnGJC3MvsUPYvBIz2p+yQNhy
	EtO+rmGGsKUlzs/aAHfz4u+PoeL8Esdu72CCsAWAxh+EqtGS+LViCpTNJ7Fm4VsWmPpdp5Yz
	w+y6v2UuVK+ExNaWJ6wgNrOAosSU7ofsICczC2hKrN+lj+oTENtd4sKvpWwTGGVnIUnNQtI9
	C6EbWckCRpZVjKKpBckFxUnpFYZ6xYm5xaV56XrJ+bmbGMEp6NnCHYxfzlsfYhTgYFTi4X1Y
	PDlEiDWxrLgy9xCjBAezkgiveSZQiDclsbIqtSg/vqg0J7X4EKMpMMomMkuJJucD02NeSbyh
	sbGJmYmppYmFgam5kjjv/3O5IUIC6YklqdmpqQWpRTB9TBycUg2MrYKs7PrrZl3/tuKGsxPb
	9PVqJdp22bW992bdX6y/8o1tROWv26ePnn1TquQkGn+ld831oKsqRZtnmH4vnjuN28bm4dx5
	zx65er92DXHeUde27tAWtbLW0BA1BWEf52vLTB8xv564dP7k9uuLGw6c39aQ0BDt7Kmxaqd+
	WPRyj+s7X6fLyE5mUWIpzkg01GIuKk4EADvXH5xXAwAA
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id sBJ2Et88019721

>   
>  Dear Myungjoo,
> 
> Thanks for your review.
> 
> On 12/18/2014 03:24 PM, MyungJoo Ham wrote:
> > Hi Chanwoo,
> > 
> > I love the idea and I now have a little mechanical issues in your code.
> > 
> >> ---
> >>  drivers/devfreq/Kconfig         |   2 +
> >>  drivers/devfreq/Makefile        |   5 +-
> >>  drivers/devfreq/devfreq-event.c | 449 ++++++++++++++++++++++++++++++++++++++++
> >>  drivers/devfreq/event/Makefile  |   1 +
> >>  include/linux/devfreq.h         | 160 ++++++++++++++
> >>  5 files changed, 616 insertions(+), 1 deletion(-)
> >>  create mode 100644 drivers/devfreq/devfreq-event.c
> >>  create mode 100644 drivers/devfreq/event/Makefile
> >>

[]

> 
> > 
> > 
> > [snip]
> > 
> >> diff --git a/drivers/devfreq/devfreq-event.c b/drivers/devfreq/devfreq-event.c
> >> new file mode 100644
> >> index 0000000..0e1948e
> >> --- /dev/null
> >> +++ b/drivers/devfreq/devfreq-event.c
> >> @@ -0,0 +1,449 @@
> >> +/*
> >> + * devfreq-event: Generic DEVFREQ Event class driver
> > 
> > DEVFREQ is a generic DVFS mechanism (or subsystem).
> > 
> > Plus, I thought devfreq-event is considered to be a "framework"
> > for devfreq event class drivers. Am I mistaken?
> 
> You're right. just "class driver" description is not proper.
> I'll modify the description of devfreq-event.c as following:
> or If you have other opinion, would you please let me know about it?
> 
> 	devfreq-event: DEVFREQ-Event Framework to provide raw data of Non-CPU Devices.

devfreq-event: a framework to provide raw data and events of devfreq devices

should be enough.


[]
> > [snip / reversed maybe.. sorry]
> > 
> >> +/**
> >> + * devfreq_event_is_enabled() - Check whether devfreq-event dev is enabled or
> >> + *                             not.
> >> + * @edev       : the devfreq-event device
> >> + *
> >> + * Note that this function check whether devfreq-event dev is enabled or not.
> >> + * If return true, the devfreq-event dev is enabeld. If return false, the
> >> + * devfreq-event dev is disabled.
> >> + */
> >> +bool devfreq_event_is_enabled(struct devfreq_event_dev *edev)
> >> +{
> >> +       bool enabled = false;
> >> +
> >> +       if (!edev || !edev->desc)
> >> +               return enabled;
> >> +
> >> +       mutex_lock(&edev->lock);
> >> +
> >> +       if (edev->enable_count > 0)
> >> +               enabled = true;
> >> +
> >> +       if (edev->desc->ops && edev->desc->ops->is_enabled)
> >> +               enabled |= edev->desc->ops->is_enabled(edev);
> > 
> > What does it mean when enabled_count > 0 and ops->is_enabled() is false? or..
> > What does it mean when enabled_count = 0 and ops->is_enabled() is true?
> > 
> > If you do enable_count in the subsystem, why would we rely on
> > ops->is_enabled()? Are you assuming that a device MAY turn itself off
> > without any kernel control (ops->disable()) and it is still a correct
> > behabior?
> 
> You're right. devfreq_event_is_enabled() has ambiguous operation according to your comment.
> 
> I'll only control the enable_count in the subsystem without ops->is_enabled()
> and then remove the is_enabled function in the structre devfreq_event_ops.
> 
> Best Regards,
> Chanwoo Choi
> 

[Off-Topic]

The name of devfreq-event may look quite intersecting with irq-driven governors,
which are being proposed these days.

Although they may look intersecting, we can have them independently;
this as a sub-class and that as a governor. And we can consider to
provide a common infrastructure for irq-driven mechanisms in devfreq or
devfreq-event when we irq-driven DVFS become more general, which I
expect in 2 ~ 3 years.

So for now, both can go independently.


Cheers!
MyungJoo
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
