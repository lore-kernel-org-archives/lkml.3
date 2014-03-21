Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753983AbaCUEtP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 00:49:15 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:30425 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751756AbaCUEtL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 00:49:11 -0400
X-AuditID: cbfee68d-b7fcd6d00000315b-e5-532bc4bc536b
Date: Fri, 21 Mar 2014 13:49:00 +0900
From: Cho KyongHo <pullip.cho@samsung.com>
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: Tomasz Figa <t.figa@samsung.com>,
        Linux DeviceTree <devicetree@vger.kernel.org>,
        Linux Samsung SOC <linux-samsung-soc@vger.kernel.org>,
        Prathyush <prathyush.k@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>, Joerg Roedel <joro@8bytes.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Grant Grundler <grundler@chromium.org>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Varun Sethi <Varun.Sethi@freescale.com>,
        Antonios Motakis <a.motakis@virtualopensystems.com>,
        Linux ARM Kernel <linux-arm-kernel@lists.infradead.org>,
        Rahul Sharma <rahul.sharma@samsung.com>
Subject: Re: [PATCH v11 10/27] iommu/exynos: use managed device helper functions
Message-id: <20140321134900.ef9b7ac83443ae2e0bc5565b@samsung.com>
In-reply-to: <532AC6A2.9070307@gmail.com>
References: <20140314140542.f4ded6c50dbd8a1d937bf354@samsung.com>
 <CAK9yfHw7zYaX9EYFE+m3Mh-u8Uiyubx-cS0EwPmfW+0weLiBKw@mail.gmail.com>
 <20140318200915.7dd833ce0fddbbd6ecd8dac9@samsung.com>
 <532862ED.8040809@samsung.com>
 <20140319175927.a3feadcacbffe80eca1d3421@samsung.com>
 <CAK9yfHxxo2eFh38gPZkpYf1ueBWySWqPzgLV_tSSykzHhNzN8g@mail.gmail.com>
 <532988CA.4000008@samsung.com>
 <20140320190333.9c3555b097e97d593faddbdd@samsung.com>
 <532AC6A2.9070307@gmail.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.10.14; i686-pc-mingw32)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmphleLIzCtJLcpLzFFi42I5/e+Zge7eI9rBBht1LO7cPcdqMf8IkHh1
	5AeTxYL91hadszewW/QuuMpmsenxNVaLy7vmsFnMOL+PyeLCio3sFlMWHWa1OPymndXi5J9e
	Rov1M16zWKza9YfRYuatNSwOAh5PDs5j8pjdcJHF49/hfiaPnbPusnvcubaHzWPzknqPyTeW
	M3r0bVnF6PF5k5zHlaNnmAK4orhsUlJzMstSi/TtErgyztw/yVYwQ6zi766tTA2M6wS7GDk5
	JARMJHY9+8EMYYtJXLi3nq2LkYtDSGAZo0R72zpWuKKdJ1ghEosYJRp+PGaCcCYzSTydf5Ed
	pIpFQFViyddDYDabgJbE6rnHGUFsEQF1iW9T+tlBGpgFlrJKXFy5kQUkISwQIPHiZAOYzSvg
	KLHl/HE2EJtTQFOib20P1IYbzBKnzh1kg7jDQuJCUwc7RIOgxI/J98CamYG2bd7WxAphy0ts
	XvOWGaRZQmALh8T/lnZWiPMEJL5NPgTUwAGUkJXYdADqaUmJgytusExgFJuFZOwsJGNnIRm7
	gJF5FaNoakFyQXFSepGhXnFibnFpXrpecn7uJkZICujdwXj7gPUhxmSglROZpUST84EpJK8k
	3tDYzMjC1MTU2Mjc0ow0YSVx3qSHSUFCAumJJanZqakFqUXxRaU5qcWHGJk4OKUaGBdIf/e2
	s0pS/FqyZvpqh+NetyYv75i74niH9M7VS0vrRH/WvY77+zrtJ7eksu6NZAbP2xfNG1RLW94V
	2d/4+3J6aIr9+cUpK4quHHFYvu+ixq07h14a30i0nfYqV+/bdW0hpnrpN9dXr3w7w3713H//
	Jt4IbO8oecp7+Mud5RKLPq5L84hQO7xZiaU4I9FQi7moOBEAspT7qRcDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrEKsWRmVeSWpSXmKPExsVy+t9jAd09R7SDDZYfN7e4c/ccq8X8I0Di
	1ZEfTBYL9ltbdM7ewG7Ru+Aqm8Wmx9dYLS7vmsNmMeP8PiaLCys2sltMWXSY1eLwm3ZWi5N/
	ehkt1s94zWKxatcfRouZt9awOAh4PDk4j8ljdsNFFo9/h/uZPHbOusvucefaHjaPzUvqPSbf
	WM7o0bdlFaPH501yHleOnmEK4IpqYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQw
	V1LIS8xNtVVy8QnQdcvMAfpFSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5vSBBcj5EBGkhY
	x5hx5v5JtoIZYhV/d21lamBcJ9jFyMkhIWAisWvnCVYIW0ziwr31bF2MXBxCAosYJRp+PGaC
	cCYzSTydf5EdpIpFQFViyddDYDabgJbE6rnHGUFsEQF1iW9T+tlBGpgFlrJKXFy5kQUkISwQ
	IPHiZAOYzSvgKLHl/HE2EJtTQFOib20P1IYbzBKnzh1kg7jDQuJCUwc7RIOgxI/J98CamYG2
	bd7WxAphy0tsXvOWeQKjwCwkZbOQlM1CUraAkXkVo2hqQXJBcVJ6rpFecWJucWleul5yfu4m
	RnCKeSa9g3FVg8UhRgEORiUe3gpO7WAh1sSy4srcQ4wSHMxKIryvu4FCvCmJlVWpRfnxRaU5
	qcWHGJOB4TGRWUo0OR+Y/vJK4g2NTcyMLI3MLIxMzM1JE1YS5z3Yah0oJJCeWJKanZpakFoE
	s4WJg1OqgTHq/wMOQ17HfBdNG06eOw++BNdobhTIXZe7bErUfvlFheoC2lF/fp5a2pnl52aX
	dU/399yQzZ2Lg1Y4hP+1eGz4akvEnsXiKz+ftVH2W3tT0Of4PoZwxwM/Xh6s8maRy/K5u7Da
	c7vc7gADWaVDVk92V2itnDs127g3eNmxw0f5uO2PSadEaSmxFGckGmoxFxUnAgCBrc6LdQMA	AA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Mar 2014 11:44:50 +0100, Tomasz Figa wrote:
> On 20.03.2014 11:03, Cho KyongHo wrote:
> > On Wed, 19 Mar 2014 13:08:42 +0100, Tomasz Figa wrote:
> >> On 19.03.2014 10:01, Sachin Kamat wrote:
> >>> On 19 March 2014 14:29, Cho KyongHo <pullip.cho@samsung.com> wrote:
> >>>> On Tue, 18 Mar 2014 16:14:53 +0100, Tomasz Figa wrote:
> >>>>> On 18.03.2014 12:09, Cho KyongHo wrote:
> >>>>>> On Fri, 14 Mar 2014 20:52:43 +0530, Sachin Kamat wrote:
> >>>>>>> Hi KyongHo,
> >>>>>>>
> >>>>>>> On 14 March 2014 10:35, Cho KyongHo <pullip.cho@samsung.com> wrote:
> >>>>>>>> This patch uses managed device helper functions in the probe().
> >>>>>>>>
> >>>>>>>> Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
> >>>>>>>> ---
> >>>>>>> [snip]
> >>>>>>>
> >>>>>>>> +       data->clk = devm_clk_get(dev, "sysmmu");
> >>>>>>>> +       if (IS_ERR(data->clk)) {
> >>>>>>>> +               dev_info(dev, "No gate clock found!\n");
> >>>>>>>> +               data->clk = NULL;
> >>>>>>>> +       }
> >>>>>>>
> >>>>>>> Why aren't you returning from here upon error?
> >>>>>>
> >>>>>> It is for the case of a System MMU which does not need clock gating.
> >>>>>>
> >>>>>
> >>>>> Are there really such cases?
> >>>>>
> >>>>
> >>>> Yes.
> >>>> Especially in the case of initial stage of new SoC development.
> >>>>
> >>>> I have experianced some software workaround for H/W restriction
> >>>> needs prevention of clock gating for some devices.
> >>>
> >>> So aren't these basically some exceptions/hacks rather than the usual way
> >>> of functioning of the device?
> >>>
> >>
> >> This actually raises a good question, whether we really need to support
> >> such early development SoC versions in mainline.
> >>
> >> Another thing is that if you need to assure that a clock is ungated, you
> >> must acquire it and prepare_enable explicitly, so I don't think this
> >> kind of handling is correct.
> >>
> > On early development step of a new SoC, clock related stuffs and
> > some device drivers like display controller are usually developed in parallel.
> >
> > In that case, -ENOENT from clk_get() must not treated as an error.
> > "[PATCH v11 20/17] iommu/exynos: allow having multiple System MMUs for a master H/W"
> > patch distinguishes -ENOENT from other error values returned by devm_clk_get().
> 
> I still don't think upstream is right place for such development hacks 
> and such assumption will mask potential errors caused by clocks 
> unspecified in DT.
> 
> If such thing is needed for development, an extra patch might be kept in 
> development tree, until clock driver is implemented or a dummy 
> fixed-rate clock might be specified in DT.
> 

Ok.

Now I understand.

Error from clk_get() will be failure of probe in the next patch series.

Thanks.

KyongHo

