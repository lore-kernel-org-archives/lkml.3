Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934471AbaGREZN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 00:25:13 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:50983 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751385AbaGREZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 00:25:07 -0400
X-AuditID: cbfee690-b7fb56d000003439-0d-53c8a1a0c168
Date: Fri, 18 Jul 2014 04:25:04 +0000 (GMT)
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: Re: RE: [PATCH 2/4] power_supply: Introduce generic psy charging driver
To: "Tc, Jenny" <jenny.tc@intel.com>, Sebastian Reichel <sre@kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Pavel Machek <pavel@ucw.cz>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        David Woodhouse <dwmw2@infradead.org>,
        David Cohen <david.a.cohen@linux.intel.com>,
        "Pallala, Ramakrishna" <ramakrishna.pallala@intel.com>,
        =?euc-kr?Q?=BF=EC=BB=F3=C1=A4?= <sangjung.woo@samsung.com>,
        =?euc-kr?Q?=C3=D6=C2=F9=BF=EC?= <cw00.choi@samsung.com>,
        =?euc-kr?Q?=C0=CC=C1=BE=C8=AD?= <jonghwa3.lee@samsung.com>
Reply-to: myungjoo.ham@samsung.com
MIME-version: 1.0
X-MTR: 20140718041549950@myungjoo.ham
Msgkey: 20140718041549950@myungjoo.ham
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20140718041549950@myungjoo.ham
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <14201933.134251405657503728.JavaMail.weblogic@epv6ml06>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjleLIzCtJLcpLzFFi42JZI2JSqLtw4YlggzOLGC0u75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfGsiV/WAuOqVd8uHWDqYHxgFoXIyeHkIC6xKIlJ9lAbAkBE4nO
	9jusELaYxIV764HiXEA1Sxklvr36ytzFyAFWtOyIF0R8DqPEuT9HmUEaWARUJa49PApWwyag
	JzHzczJIWFggQKJv2ixGEFtEwEfi4MeNYDOZBWazSGz+dJoR4ggliTX7XrGA2LwCghInZz5h
	gThCVeL08/9MEHE1ic1TP0AdKiExa/oFqEN5JWa0P4Wql5OY9nUNM4QtLXF+1gZGmGcWf38M
	FeeXOHZ7BxPEL7wST+4Hw4zZvfkL1HgBialnDkK1akk8OPaCHcLmk1iz8C0LzJhdp5Yzw/Te
	3zIX7ExmAUWJKd0P2SFsLYkvP/axoXuLV8BFYveJW4wTGJVnIUnNQtI+C0k7spoFjCyrGEVT
	C5ILipPSi0z0ihNzi0vz0vWS83M3MQLTwul/zybsYLx3wPoQYzIwSiYyS4km5wPTSl5JvKGx
	mZGFqYmpsZG5pRlpwkrivGqPkoKEBNITS1KzU1MLUovii0pzUosPMTJxcEo1MM6YfiVyygn2
	mmWWL3lVTrAcTbiUzTRP1OIdX07jlGSN3XYOJdxNIpMUPxzcJ+bgGPxN3lW86L2r4cItKgvZ
	mWJL3n0993/RcudFr18djN9j9cyV+5/dV07+q1rp927MT/ixxObCnebdsx++Uahdsmpn6H6l
	32J1vIap1vFFWldKuqLv+/7RZ1JiKc5INNRiLipOBAAKKymEIQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPKsWRmVeSWpSXmKPExsVy+t/tXt0FC08EG2xZYGpxedccNgdGj8+b
	5AIYo9JsMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4CG
	KimUJeaUAoUCEouLlfTtbIryS0tSFTLyi0tslaINzY30jAz0TI30DI1jrQwNDIxMgWoS0jKW
	LfnDWnBMveLDrRtMDYwH1LoYOTmEBNQlFi05ydbFyMEhIWAiseyIF0hYQkBM4sK99UBhLqCS
	OYwS5/4cZQZJsAioSlx7CGJzcLAJ6EnM/JwMEhYWCJDomzaLEcQWEfCROPhxI1gvs8BsFonN
	n04zQuxSkliz7xULiM0rIChxcuYTFohlqhKnn/9ngoirSWye+oENIi4hMWv6BVYIm1diRvtT
	qHo5iWlf1zBD2NIS52dtYIQ5evH3x1Bxfoljt3cwQfzFK/HkfjDMmN2bv0CNF5CYeuYgVKuW
	xINjL9ghbD6JNQvfssCM2XVqOTNM7/0tc8HOZBZQlJjS/ZAdwtaS+PJjHxu6t3gFXCR2n7jF
	OIFRbhaS1Cwk7bOQtCOrWcDIsopRNLUguaA4Kb3CSK84Mbe4NC9dLzk/dxMjODk9W7SD8d95
	60OMAhyMSjy8D64dDxZiTSwrrsw9xCjBwawkwpt9HyjEm5JYWZValB9fVJqTWnyIMRkYgROZ
	pUST84GJM68k3tDY2MTMxNTSxMLA1Jw0YSVxXvlbSUFCAumJJanZqakFqUUwW5g4OKUaGB85
	CjN9buQJzz+hraqgF3tyb+dR58cuQX+bQzNXfIhwC2oOeTjhZMFOnsaXr/65OrF5REtm75Pc
	o3VTVquva8r0xlNs4ne962Xibwaq7SlvXrHkWaDIE87Nyv9b9nPsOX7G4drs3OOa+tmcXgKf
	T1x+/ldceqVC47cuzl9ixi5zv64OD9m4X4mlOCPRUIu5qDgRAEn767+SAwAA
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s6I4PH9g010409

From: Tc, Jenny<jenny.tc@intel.com>
>  
> > From: Sebastian Reichel [mailto:sre@kernel.org]
> > Sent: Friday, July 18, 2014 7:49 AM
> > To: Tc, Jenny
> > Cc: linux-kernel@vger.kernel.org; Dmitry Eremin-Solenikov; Pavel Machek; Anton
> > Vorontsov; David Woodhouse; David Cohen; Pallala, Ramakrishna;
> > myungjoo.ham@samsung.com
> > Subject: Re: [PATCH 2/4] power_supply: Introduce generic psy charging driver
> > 
> > Hi Jenny,
> > 
> > On Tue, Jul 08, 2014 at 11:34:19AM +0530, Jenny TC wrote:
> > > The Power Supply charging driver connects multiple subsystems to do
> > > charging in a generic way. The subsystems involves power_supply,
> > > thermal and battery communication subsystems (1wire). With this the
> > > charging is handled in a generic way.
> > >
> > > The driver makes use of different new features - Battery
> > > Identification interfaces, pluggable charging algorithms, charger cable arbitrations
> > etc.
> > > The patch also introduces generic interface for charger cable notifications.
> > > Charger cable events and capabilities can be notified using the
> > > generic power_supply_notifier chain.
> > >
> > > Overall this driver removes the charging logic out of the charger chip
> > > driver and the charger chip driver can just listen to the request from
> > > the power supply charging driver to set the charger properties. This
> > > can be implemented by exposing get_property and set property callbacks.
> > 
> > this seems to be a superset of charger-manager, which is already in the kernel. I
> > would prefer not to have two different charger mangement frameworks in the kernel.
> > 
> > I suggest to add features supported by charger-manager to power supply charging
> > driver and convert users of charger-manager to the improved driver.
> > 
> > I CC'd MyungJoo Ham, who wrote the charger-manager, so that he can also give
> > feedback.
> 
> We are back to the initial discussions we had in the list. The initial proposal
> was for the charger manager. The charger manager is more aligned to
> regulator framework, use private notification
> mechanisms(cm_notify_event,fullbatt_vchk etc) and relies more on
> platform data (struct charger_desc). This doesn't seems to be good to support plug in
> charger drivers, charging algorithms, battery identification drivers at runtime.

Then, the additional requirement is
- Online or runtime modification or probe of the platform data (use .ko?) for "plugin chargers & battery identification)
- Externally implement charging algorithms. (allow charger-manager to have an external funtion pointer?)

> Power supply charger driver is introduced to meet all these requirements by
> extending the existing power_supply subsystem features like
> power_supply_changed event, power_supply_register, power supply thermal
> throttling mechanism so that plugging new driver would be
> easy. Also the user interfaces would remain the same as power_supply subsystem.

- Replace (rewrite) charger-manager's private event handlers with power supply changed work?

For identifying plugin (external) chargers and feeding such information to
charger-manager, extcon might be a good interconnection, which is initially
designed for devices supporting differernt external chargers. (USB charger,
1.5A OEM charger, 1.0A 3rd party "popular" charger, ...)

> 
> Able to locate link on the discussion. 
> http://www.gossamer-threads.com/lists/linux/kernel/1562180.


Cheers,
MyungJoo


ps. CC'd related collegues as well. (Sangjung, Chanwoo, Jonghwa)

--
MyungJoo Ham («‘∏Ì¡÷), PHD
Frontier CS Lab, Software Center
Samsung Electronics
Cell: +82-10-6714-2858ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
