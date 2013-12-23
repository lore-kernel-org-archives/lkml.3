Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757172Ab3LWJDX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 04:03:23 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:25764 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751504Ab3LWJDT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 04:03:19 -0500
X-AuditID: cbfee691-b7efc6d0000039d3-23-52b7fc557760
Date: Mon, 23 Dec 2013 09:02:51 +0000 (GMT)
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: Re: Re: [PATCH 1/1] extcon: gpio: Add power resume support
To: =?euc-kr?Q?=C3=D6=C2=F9=BF=EC?= <cw00.choi@samsung.com>,
        Barry Song <21cnbao@gmail.com>
Cc: rjying <rjying@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        RongJun Ying <Rongjun.Ying@csr.com>,
        Binghua Duan <Binghua.Duan@csr.com>
Reply-to: myungjoo.ham@samsung.com
MIME-version: 1.0
X-MTR: 20131223082751036@myungjoo.ham
Msgkey: 20131223082751036@myungjoo.ham
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20131223082751036@myungjoo.ham
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <2741731.123321387789370147.JavaMail.weblogic@epml01>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnleLIzCtJLcpLzFFi42JZI2JSpBv6Z3uQwcO5ohaXd81hc2D0+LxJ
	LoAxissmJTUnsyy1SN8ugSvj8923TAU/FCvu/XzD1MDYotjFyMkhJKAusWjJSTYQW0LARGLZ
	yj4mCFtM4sK99UBxLqCapYwSF36vZYYp6vv4nhEiMZ9R4lLPBRaQBIuAqsS7fU+Bujk42AT0
	JGZ+TgYJCws4S+yc+48dxBYRSJSYs2MOWC+zwCxGiUWvN7BBXKEksWbfK7A5vAKCEidnPmGB
	WKYqcePgBiaIuJrE63XroI6QkJg1/QIrhM0rMaP9KVS9nMS0r2ugaqQlzs/awAjzzeLvj6Hi
	/BLHbu8AuxOk98n9YJgxuzd/gQaEgMTUMwehWrUk7j3rhBrPJ7Fm4VsWmDG7Ti1nhum9v2Uu
	2JnMAooSU7ofskPYWhJffuxjQ/cWr4CjxO3PrawTGJVnIUnNQtI+C0k7spoFjCyrGEVTC5IL
	ipPSi0z1ihNzi0vz0vWS83M3MQITw+l/zybuYLx/wPoQYzIwSiYyS4km5wMTS15JvKGxmZGF
	qYmpsZG5pRlpwkrivOmPkoKEBNITS1KzU1MLUovii0pzUosPMTJxcEo1MK6P3XBZecUvftWr
	oleKlgkb955lF9G12tEYyK38qyo1753zgR324unxUxWWNzgH3e/zmbvt71Kx5xyXSiXfnnwZ
	LRSzjd/+xLflN7XKZ1w4whu0NKLiF0u+AEtnc2/5egWG+6yW996dLj+k4ZO+dZ/49iUmfYK7
	a5QNRXTzw/dNzX2tZqdXr8RSnJFoqMVcVJwIAIuEOyQiAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgk+LIzCtJLcpLzFFi42I5/e/2TN3QP9uDDN7957W4vGsOmwOjx+dN
	cgGMUWk2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUBD
	lRTKEnNKgUIBicXFSvp2NkX5pSWpChn5xSW2StGG5kZ6RgZ6pkZ6hsaxVoYGBkamQDUJaRmf
	775lKvihWHHv5xumBsYWxS5GTg4hAXWJRUtOsoHYEgImEn0f3zNC2GISF+6tB4pzAdXMZ5S4
	1HOBBSTBIqAq8W7fU6YuRg4ONgE9iZmfk0HCwgLOEjvn/mMHsUUEEiXm7JjDCNLLLDCLUWLR
	6w1sEMuUJNbsewU2h1dAUOLkzCcsEMtUJW4c3MAEEVeTeL1uHTNEXEJi1vQLrBA2r8SM9qdQ
	9XIS076ugaqRljg/awPc0Yu/P4aK80scu70D7E6Q3if3g2HG7N78BepfAYmpZw5CtWpJ3HvW
	CTWeT2LNwrcsMGN2nVrODNN7f8tcsDOZBRQlpnQ/ZIewtSS+/NjHhu4tXgFHidufW1knMMrN
	QpKahaR9FpJ2ZDULGFlWMYqmFiQXFCelVxjqFSfmFpfmpesl5+duYgSnp2cLdzB+OW99iFGA
	g1GJh5ejZXuQEGtiWXFl7iFGCQ5mJRHe6B/bgoR4UxIrq1KL8uOLSnNSiw8xJgMjcCKzlGhy
	PjB15pXEGxobm5iZmFqaWBiYmpMmrCTOe/dmUpCQQHpiSWp2ampBahHMFiYOTqkGxnmnHU8t
	Np+XuOHsYZca3hOp3L5S/087KczeILr5yfSIM+/MH4tMO7miU+Sjk8njWw53lXoOb1Xjv3h2
	m3N6d+W8iiNstxqqnkg6p7hEmq7NrFjxO9nh9Oyyf19Cr8c0ykwSTYx7ONHvwv+7azZ0P3rz
	M7dqywP9GdHbHpnM4T6y+WYOX/Wsh5uUWIozEg21mIuKEwFEAU1VkwMAAA==
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id rBN93UGC024856

> On 12/23/2013 05:13 PM, Barry Song wrote:
> > 2013/12/23 Chanwoo Choi <cw00.choi@samsung.com>:
> >> On 12/23/2013 04:36 PM, Barry Song wrote:
> >>> 2013/12/23 Chanwoo Choi <cw00.choi@samsung.com>:
> >>>> On 12/23/2013 03:10 PM, Barry Song wrote:
> >>>>> 2013/12/23 Chanwoo Choi <cw00.choi@samsung.com>:
> >>>>>> On 12/20/2013 05:09 PM, rjying wrote:
> >>>>>>> From: Rongjun Ying <rongjun.ying@csr.com>
> >>>>>>>
> >>>>>>> After system resume, need send extcon uevent to userspace
> >>>>>>
> >>>>>> Why did extcon send uevent after wakeup from suspend?
> >>>>>>
> >>>>>> If extcon cable is attatched or detached on suspend state,
> >>>>>> Kernel can detect the interrupt about changed state of extcon.
> >>>>>
> >>>>> irq controller has lost power in suspend, so there is no pending interrupt.
> >>>>> and HW will not pend any interrupt when we hotplug cable during sleep.
> >>>>
> >>>> No, SoC in suspend state must maintain the minimum power under 1mA
> >>>> if completed the power-optimization on suspend state.
> >>>>
> >>>> If user insert USB cable to target, the external interrupt connected to
> >>>> USB port is happened. And kernel would be waked up from suspend state
> >>>> to operate proper interrupt handler of external interrupt.
> >>>
> >>> no. not every USB supports that. that depends on the power domain design of SoC.
> >>
> >> USB is only example for gpio control in suspend state.
> >>
> >>>
> >>>>
> >>>> Also,
> >>>> Input subsystem used gpio-keys driver for power button..
> >>>> If user press power button in suspend state, target would be waked up from suspend state.
> >>>> It is same case both extcon gpio and gpio-keys of input subsystem.
> >>>
> >>> no. it depends on the SoC design. many SoC only support 1 special key
> >>> which can work as ON-KEY as wakeup source. and this kind of keys might
> >>> not be GPIO at all.
> >>> there is a special power domain which is still open for it.
> >>
> >> many SoC?
> >>
> >> As I knew, most SoC has supported various wakeup source.
> >> As you comment, if specific SoC support only one special key
> >> for wakeup from suspend state, I think it isn't common.
> >>
> >> Also,
> >> This patch isn't necessary on SoCs which support various wakeup source (e.g., external interrupt).
> >> As you comment, this issue has dependecy on specific SoC. Why did you think this common code?
> > 
> > i am not thinking this patch must be common codes but i think the
> > extcon should provide common codes to support all chips. that is what
> > a framework should consider.
> > 
> > if there is no this or things similar with this, how could extcon
> > support the chips which don't support receiving sleep gpio interrupts?
> 
> Sure, subsystem should support all cases related to this issue.
> 
> I'd like to send common patch to support all cases as we discussed.
> If some patch support all case, I would review and apply it.
> 
> Chanwoo Choi

Dear Barry and Chanwoo,


What about having a flag in extcon platform data that describes
whether this extcon-gpio requires status double checking at resume
or not?


Cheers,
MyungJoo

ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
