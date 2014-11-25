Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750942AbaKYJHK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 04:07:10 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:29645 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071AbaKYJHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 04:07:06 -0500
X-AuditID: cbfee68f-f791c6d000004834-f8-547446b7080a
Date: Tue, 25 Nov 2014 09:07:03 +0000 (GMT)
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: Re: Re: [PATCH v2 2/3] PM / devfreq: tegra: add devfreq driver for
 Tegra Activity Monitor
To: Tomeu Vizoso <tomeu.vizoso@collabora.com>
Cc: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        =?utf-8?Q?=EB=B0=95=EA=B2=BD=EB=AF=BC?= <kyungmin.park@samsung.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Alexandre Courbot <gnurou@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Reply-to: myungjoo.ham@samsung.com
MIME-version: 1.0
X-MTR: 20141125090216502@myungjoo.ham
Msgkey: 20141125090216502@myungjoo.ham
X-EPLocale: ko_KR.utf-8
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-MLAttribute: 
X-RootMTR: 20141125090216502@myungjoo.ham
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
X-ConfirmMail: N,general
Content-type: text/plain; charset=utf-8
MIME-version: 1.0
Message-id: <12372901.124221416906419323.JavaMail.weblogic@epmlwas08c>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrCIsWRmVeSWpSXmKPExsWyRsSkRHe7W0mIwbZFGhaXd81hc2D0+LxJ
	LoAxissmJTUnsyy1SN8ugStjzqk+5oIrfBXznx1mbGBcwNfFyMkhJKAusWjJSTYQW0LARGLl
	zgNMELaYxIV764HiXEA1SxklLkzawA5TtP7vBEaIxBxGib1zlzKCJFgEVCX2vTsAZHNwsAno
	Scz8nAwSFhZIkth08BxYr4iAvsSVxc/BepkFrrFINN89yARxhZLEmn2vWEBsXgFBiZMzn7BA
	LFOVaNz/iREiribxdnYbM0RcXOLC3EtQB/FKzGh/ClUvJzHt6xqoGmmJ87M2MMJ8s/j7Y6g4
	v8Sx2zugvhSQmHrmIFSNlsTp+TNYIWw+iTUL37LA1O86tZwZZtf9LXOheiUktrY8AatnFlCU
	mNL9kB3kd2YBTYn1u/TRvcIr4CZxZvYyZpDfJQQmckicOdTPNIFRaRaSullIRs1CGIWsZAEj
	yypG0dSC5ILipPQiY73ixNzi0rx0veT83E2MwMRw+t+z/h2Mdw9YH2IU4GBU4uHtOFscIsSa
	WFZcmXuI0RQYSxOZpUST84HpJ68k3tDYzMjC1MTU2Mjc0kxJnHeh1M9gIYH0xJLU7NTUgtSi
	+KLSnNTiQ4xMHJxSDYw7lKPi1Tuf7v21426l8uu9cTcOBS2f/pirXLCozonZbdJmoax9T+Nn
	zd614WLdzZ7UC7aiG7jr3hqpP1abf33Z3ytZfc6OXTE6LXaX3tQ5+qnv5Pb+ka344VDbxr8c
	Go2iDv9/F3y/Xvs+vSt61aTX1g1v7sf5FqSvDQlwKmdo0vt9YdJWtrtKLMUZiYZazEXFiQAI
	ChzFBwMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKKsWRmVeSWpSXmKPExsVy+t/tPt3tbiUhBl0TFC0u75rD5sDo8XmT
	XABjVJpNRmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtBQ
	JYWyxJxSoFBAYnGxkr6dTVF+aUmqQkZ+cYmtUrShuZGekYGeqZGeoXGslaGBgZEpUE1CWsac
	U33MBVf4KuY/O8zYwLiAr4uRk0NIQF1i0ZKTbCC2hICJxPq/ExghbDGJC/fWA8W5gGrmMErs
	nbsULMEioCqx790BIJuDg01AT2Lm52SQsLBAksSmg+fYQWwRAX2JK4ufM4L0MgtcY5FovnuQ
	CWKZksSafa9YQGxeAUGJkzOfsEAsU5Vo3P+JESKuJvF2dhszRFxc4sLcS+wQNq/EjPanUPVy
	EtO+roGqkZY4P2sD3NGLvz+GivNLHLu9gwnCFpCYeuYgVI2WxOn5M1ghbD6JNQvfssDU7zq1
	nBlm1/0tc6F6JSS2tjwBq2cWUJSY0v2QHeR3ZgFNifW79NG9wivgJnFm9jLmCYyys5CkZiHp
	noXQjaxkASPLKkbR1ILkguKk9ApDveLE3OLSvHS95PzcTYzgJPRs4Q7GL+etDzEKcDAq8fB2
	ni0OEWJNLCuuzD3EKMHBrCTCGzUPKMSbklhZlVqUH19UmpNafIjRFBhnE5mlRJPzgQkyryTe
	0NjYxMzE1NLEwsDUXEmc9/+53BAhgfTEktTs1NSC1CKYPiYOTqkGxqJ0lVVhN24bRSrPCbwb
	Huypv6X0pVJEx/t8u3vn91c7OV7LnPi8veD8R++SeUdu2NXv39HOGrs0b+cJoXo7QwM1TcV7
	3K1PN7v5LH9RGDBl05cj05d+aPdbvujKVz3Ggk1t2yMUlDQKLojOfvXT6KRwd+TMT8YVTa5L
	jt3nOG/yhKGqX+SmuRJLcUaioRZzUXEiACSo5/5YAwAA
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id sAP97H8j004475

> On 25 November 2014 at 08:07, MyungJoo Ham <myungjoo.ham@samsung.com> wrote:
> >> The ACTMON block can monitor several counters, providing averaging and firing
> >> interrupts based on watermarking configuration. This implementation monitors
> >> the MCALL and MCCPU counters to choose an appropriate frequency for the
> >> external memory clock.
> >>
> >> This patch is based on work by Alex Frid <afrid@nvidia.com> and Mikko
> >> Perttunen <mikko.perttunen@kapsi.fi>.
> >>
> >> Signed-off-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>
> >
> > Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
> >
> > How are you going to integrate other two patches?
> 
> I think they should go through the Tegra tree.
> 
> > May I just go ahead with this patch only?
> 
> Yes, I think that would be fine as the other patches aren't actual
> build or runtime dependencies. This driver shouldn't cause problems
> either if it's ran without the EMC and CPUFreq patches (though won't
> be fully functional, of course).

Ok, then, as long as the other two patches (for DT support) get
ACKed (seems fairly straightforward as well) or Signed-off by
corresponding tree maintainers, I feel fine to
send this patch along with the next pull request.

Thank you.

Cheers,
MyungJoo

> 
> Regards,
> 
> Tomeu
> 
> > Cheers,
> > MyungJoo.
> >
> 
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
