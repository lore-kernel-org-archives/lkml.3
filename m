Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753818AbaIALe0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 07:34:26 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:16860 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753536AbaIALeW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 07:34:22 -0400
X-AuditID: cbfee68d-f79c46d000000b84-99-540459bb972a
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: "'Arnd Bergmann'" <arnd@arndb.de>, "'Lee Jones'" <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, kgene.kim@samsung.com,
        linux@arm.linux.org.uk, vikas.sajjan@samsung.com, joshi@samsung.com,
        naushad@samsung.com, thomas.ab@samsung.com, chow.kim@samsung.com,
        "'Tomasz Figa'" <t.figa@samsung.com>, broonie@kernel.org
References: <1408694991-21615-1-git-send-email-pankaj.dubey@samsung.com>
 <20140901074918.GB6226@lee--X1> <4121644.3haxjiIdIo@wuerfel>
In-reply-to: <4121644.3haxjiIdIo@wuerfel>
Subject: RE: [PATCH] mfd: syscon: Decouple syscon interface from syscon devices
Date: Mon, 01 Sep 2014 17:05:33 +0530
Message-id: <000c01cfc5d9$03866c30$0a934490$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQHpa/2m/d4/OY0ITARCUM8RI+G5jQGj941vAnXmlLmbmAms0A==
Content-language: en-us
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrPIsWRmVeSWpSXmKPExsWyRsSkSnd3JEuIwbJpVhZ/Jx1jt5j68Amb
	xbJJd9ksvu/6wm7Ru+Aqm8X9r0cZLTY9vsZqcXnXHDaLGef3MVncvsxr8enof1aL9TNes1h0
	LGO0uPlsO5MDn0dLcw+bx+9fkxg9Nq3qZPO4c20Pm8fmJfUefVtWMXp83iQXwB7FZZOSmpNZ
	llqkb5fAlXFmnV5Bv1jF1c5fTA2MPwW7GDk4JARMJJ521nUxcgKZYhIX7q1nA7GFBJYySpw5
	rgERN5F49+glK0R8OqPE1CVBXYxcQPZfRomzR/pYQBJsAroST97PZQaxRQTcJS603WMCKWIW
	OM4ksez1f3aI7nZGie69HCA2p4CmxPavexhBbGEBf4kv9xaDNbMIqErsOtYHto1XwFLi8cnn
	jBC2oMSPyffAljELaEms33mcCcKWl9i85i0zxKUKEjvOvmaEOMJJ4trHP8wQNeISkx48ZAc5
	SEJgKYfE1e/ToZYJSHybfIgFEhKyEpsOQM2RlDi44gbLBEaJWUhWz0KyehaS1bOQrFjAyLKK
	UTS1ILmgOCm9yFCvODG3uDQvXS85P3cTIzAdnP73rHcH4+0D1ocYBTgYlXh4H8xiDhFiTSwr
	rsw9xGgKdNFEZinR5Hxg0skriTc0NjOyMDUxNTYytzRTEudVlPoZLCSQnliSmp2aWpBaFF9U
	mpNafIiRiYNTqoFx1qucd37f1oSVbrEqePJvx9GQNb8i94sGf1p9fC/L5NlNt/i3326o+v/T
	/HrVzGyvf9Vcggd+igs9NuTtPVWiX+DBEDbHi+2G0vpv6dwvfsXcYVmb57IoYKHmottndOyX
	dKsprP4wn1d95mN1lyX/J7DfWzCF1a+Oi1tMh2/f0y9Lfx/bXeu7Q4mlOCPRUIu5qDgRAOkV
	7FsCAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNKsWRmVeSWpSXmKPExsVy+t9jQd3dkSwhBpuuG1j8nXSM3WLqwyds
	Fssm3WWz+L7rC7tF74KrbBb3vx5ltNj0+BqrxeVdc9gsZpzfx2Rx+zKvxaej/1kt1s94zWLR
	sYzR4uaz7UwOfB4tzT1sHr9/TWL02LSqk83jzrU9bB6bl9R79G1ZxejxeZNcAHtUA6NNRmpi
	SmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtDFSgpliTmlQKGA
	xOJiJX07TBNCQ9x0LWAaI3R9Q4LgeowM0EDCGsaMM+v0CvrFKq52/mJqYPwp2MXIySEhYCLx
	7tFLVghbTOLCvfVsILaQwHRGialLgroYuYDsv4wSZ4/0sYAk2AR0JZ68n8sMYosIuEtcaLvH
	BFLELHCcSWLZ6//sEN3tjBLdezlAbE4BTYntX/cwgtjCAv4SX+4tBmtmEVCV2HWsD2wzr4Cl
	xOOTzxkhbEGJH5PvgS1jFtCSWL/zOBOELS+xec1bZohLFSR2nH3NCHGEk8S1j3+YIWrEJSY9
	eMg+gVFoFpJRs5CMmoVk1CwkLQsYWVYxiqYWJBcUJ6XnGuoVJ+YWl+al6yXn525iBCecZ1I7
	GFc2WBxiFOBgVOLhfTCLOUSINbGsuDL3EKMEB7OSCO/0UJYQId6UxMqq1KL8+KLSnNTiQ4ym
	QJ9OZJYSTc4HJsO8knhDYxNzU2NTSxMLEzNLJXHeA63WgUIC6YklqdmpqQWpRTB9TBycUg2M
	Rtv5hb9N18s6b/d9ieOkzOPl6n5NNfd/LE4QfXpFxV5wWo+Mx6YdwQs+bKspmf+77YT1EsmF
	fbs2+rAwx3lZKk8zuzjZNseZqywzK4qhJe3BSRM3w2qtD5U7Q6fJHXM8rd6rKD257fqEwAOC
	Plr3vr3b93HarJlyJ3fpvH95otw47axOpQWLEktxRqKhFnNRcSIAH/D+7k4DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

> -----Original Message-----
> From: Arnd Bergmann [mailto:arnd@arndb.de]
> Sent: Monday, September 01, 2014 4:07 PM
> To: Lee Jones
> Cc: Pankaj Dubey; linux-arm-kernel@lists.infradead.org; linux-samsung-
> soc@vger.kernel.org; linux-kernel@vger.kernel.org; kgene.kim@samsung.com;
> linux@arm.linux.org.uk; vikas.sajjan@samsung.com; joshi@samsung.com;
> naushad@samsung.com; thomas.ab@samsung.com; chow.kim@samsung.com;
> Tomasz Figa; broonie@kernel.org
> Subject: Re: [PATCH] mfd: syscon: Decouple syscon interface from syscon
devices
> 
> On Monday 01 September 2014 08:49:18 Lee Jones wrote:
> > On Fri, 22 Aug 2014, Pankaj Dubey wrote:
> >
> > > From: Tomasz Figa <t.figa@samsung.com>
> > >
> > > Currently a syscon entity can be only registered directly through a
> > > platform device that binds to a dedicated driver. However in certain
> > > use cases it is desirable to make a device used with another driver
> > > a syscon interface provider. For example, certain SoCs (e.g. Exynos)
> > > contain system controller blocks which perform various functions
> > > such as power domain control, CPU power management, low power mode
> > > control, but in addition contain certain IP integration glue, such
> > > as various signal masks, coprocessor power control, etc. In such
> > > case, there is a need to have a dedicated driver for such system
> > > controller but also share registers with other drivers. The latter
> > > is where the syscon interface is helpful.
> > >
> > > This patch decouples syscon object from syscon driver, so that it
> > > can be registered from any driver in addition to the original
> > > "syscon" platform driver.
> > >
> > > Signed-off-by: Tomasz Figa <t.figa@samsung.com>
> > > Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
> > > ---
> > >
> > > RFC patch [1] was posted by Tomasz Figa. This patch addresses some
> > > of comments given by Arnd to RFC patch, and further decouples syscon
> > > from device model. It also gives flexibility of registering with
> > > syscon at early stage using device_node object.
> >
> > It would be helpful if Arnd gave this revision his blessing (Ack).
> 
> I never saw a reason why we don't take this all the way as discussed a few
times:
> Completely remove the dependency of syscon on having a platform driver for
it, and
> make it possible to just call
> syscon_regmap_lookup_by_phandle() without having to register it first.
> 

Please have a look at this thread [1], where we discussed the need of syscon
as platform device.
Looks like still there are users of syscon_regmap_lookup_by_pdevname
(clps711x.c).
So we can't make it completely independent of platform_device. 

[1]
https://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg35708.html


> 	Arnd

