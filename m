Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753506Ab3A3Gyd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 01:54:33 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:34973 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751408Ab3A3Gyb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 01:54:31 -0500
X-AuditID: cbfee61b-b7fb06d000000f28-51-5108c3a595d7
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Vivek Gautam'" <gautamvivek1987@gmail.com>,
        "'Tomasz Figa'" <tomasz.figa@gmail.com>
Cc: "'Vivek Gautam'" <gautam.vivek@samsung.com>, jg1.han@samsung.com,
        devicetree-discuss@lists.ozlabs.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org
References: <1358257112-19595-1-git-send-email-gautam.vivek@samsung.com>
 <1358257112-19595-4-git-send-email-gautam.vivek@samsung.com>
 <3963234.Gb249i4a6U@flatron>
 <CAFp+6iHd66_dvj_M5zOpJZ7sEy-pYa-CdWKUZBYc3Dfn3JHtfg@mail.gmail.com>
 <CAFp+6iE+WvQz_rbKY2L4N2KoUeTTZYhwc3v3wU5iua_bEPN1ng@mail.gmail.com>
In-reply-to: <CAFp+6iE+WvQz_rbKY2L4N2KoUeTTZYhwc3v3wU5iua_bEPN1ng@mail.gmail.com>
Subject: RE: [PATCH v4 3/4] ARM: Exynos5250: Add clock information for
 dwc3-exynos
Date: Tue, 29 Jan 2013 22:54:23 -0800
Message-id: <079201cdfeb6$a4a96400$edfc2c00$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQJEIxpz/CmB/m1IOaI9mgyw8JBKXgMGUbHmAoDMNPsB9MibzQGE6fj+ly0c/KA=
Content-language: en-us
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrJIsWRmVeSWpSXmKPExsVy+t8zfd2lhzkCDe5fNbO4vGsOm8WM8/uY
	LBYta2V2YPb4vEkugDGKyyYlNSezLLVI3y6BK2Pa5DtMBZM4KuZ/nMvcwDiZrYuRk0NCwETi
	W8NZVghbTOLCvfVgcSGBZYwS6x/XwNTc+vuMsYuRCyg+nVHi+dFtLBDOX0aJN80LmUCq2AQ0
	JA6/f8YOYosIhEtMvD2NHaSIWeA4o8Tpd7eg2rcwSfx618UIUsUpECxxuOMHC4gtLBAisfTW
	bmYQm0VAVeLjqwlgN/EKWEr8W90BZQtK/Jh8D6yeWUBLYv3O40wQtrzE5jVvmSFuVZDYcfY1
	I8QVfhIbJ79lh6gRl5j04CE7RM0mdonPF2IhdglIfJt8CGgmB1BcVmLTAagxkhIHV9xgmcAo
	MQvJ5llINs9CsnkWkg0LGFlWMYqmFiQXFCel5xrpFSfmFpfmpesl5+duYoREnPQOxlUNFocY
	BTgYlXh4F7xgDxRiTSwrrsw9xCjBwawkwqugxhEoxJuSWFmVWpQfX1Sak1p8iDEZ6NiJzFKi
	yfnAZJBXEm9obGxiZmJqYm5pam5KmrCSOC/jqScBQgLpiSWp2ampBalFMFuYODilGhjFRLbE
	FPy7dcnrqaPpi7ft1uIGXe/k1mX2bX5ZeeWO0UVZvxNPfW9GHe4+Hf9HiU8tI1/1RWN9bdsP
	yZOOves35O6Knm3CdmmWZ9Qv73CvSOWGKeUL3lftj7kSs+KgaKdDtlKjRVvnVOW/wlI2Rs8j
	JdQN4lw2Bqu9+8J9/uPD61lG63a+PqHEUpyRaKjFXFScCACTd9IP/AIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprFKsWRmVeSWpSXmKPExsVy+t9jQd2lhzkCDVavMbK4vGsOm8WM8/uY
	LBYta2V2YPb4vEkugDGqgdEmIzUxJbVIITUvOT8lMy/dVsk7ON453tTMwFDX0NLCXEkhLzE3
	1VbJxSdA1y0zB2i+kkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3fkCC4HiMDNJCwjjFj2uQ7
	TAWTOCrmf5zL3MA4ma2LkZNDQsBE4tbfZ4wQtpjEhXvrgeJcHEIC0xklnh/dxgLh/GWUeNO8
	kAmkik1AQ+Lw+2fsILaIQLjExNvT2EGKmAWOM0qcfneLEaJjC5PEr3ddYHM5BYIlDnf8YAGx
	hQVCJJbe2s0MYrMIqEp8fDWBFcTmFbCU+Le6A8oWlPgx+R5YPbOAlsT6nceZIGx5ic1r3jJD
	3KogsePsa0aIK/wkNk5+yw5RIy4x6cFD9gmMQrOQjJqFZNQsJKNmIWlZwMiyilE0tSC5oDgp
	PddIrzgxt7g0L10vOT93EyM4pp9J72Bc1WBxiFGAg1GJh3fBC/ZAIdbEsuLK3EOMEhzMSiK8
	CmocgUK8KYmVValF+fFFpTmpxYcYk4E+ncgsJZqcD0w3eSXxhsYmZkaWRmYWRibm5qQJK4nz
	Mp56EiAkkJ5YkpqdmlqQWgSzhYmDU6qBke2KiHH5rJzP39jzle3Eo1eKZZ1ov30w4datfLfG
	8GtdHo3L57t6OnkefbYrnTd+zV6XuwuNa4Snei0K+5OkvvzBtSblaccnTJFc7mQjELrxQ/GK
	IHW+g6Zrf3bKNrS+imQx/VVxsaFArGj9U0GuEvkriz9pMls01DG9mJCedNr1S8PV9buvKLEU
	ZyQaajEXFScCABp5WmctAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Gautam wrote:
> 
> Hi Tomasz,
> 
> 
> On Wed, Jan 16, 2013 at 8:35 PM, Vivek Gautam
> <gautamvivek1987@gmail.com> wrote:
> > Hi Tomasz,
> >
> >
> > On Wed, Jan 16, 2013 at 1:19 PM, Tomasz Figa <tomasz.figa@gmail.com>
> wrote:
> >> Hi Vivek,
> >>
> >> Don't you need also some clkdev lookup entry to make the clock
available
> >> in the driver?
> >>
> >
> > This clock source we added with a motive of completion, however it's
> > not being used as of now.
> > As far as i could see the lookup structure contains clocks for devices
> > having multiple instances.
> > Do you feel that i should be adding an entry in clk_lookup structure ?
> > May be i am missing here something. Can you please elaborate on the
> > use-case of clk_lookup
> > entries.
> >
> 
> Any suggestions on this please ?
> 
Just note, I think you can do it based on Samsung common clock is for all of
exynos stuff which will be done in a couple of days. Sorry for late it,
because there were some problems.

Thanks.

- Kukjin

