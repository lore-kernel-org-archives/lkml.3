Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751340AbaDXEyU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 00:54:20 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:32689 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751244AbaDXEx4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 00:53:56 -0400
X-AuditID: cbfee690-b7fcd6d0000026e0-c3-535898e1b8cb
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Arnd Bergmann'" <arnd@arndb.de>, "'Liviu Dudau'" <Liviu.Dudau@arm.com>
Cc: linaro-kernel@lists.linaro.org, "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Byungho An'" <bh74.an@samsung.com>,
        "'linux-pci'" <linux-pci@vger.kernel.org>,
        linux-kernel@vger.kernel.org, ilho215.lee@samsung.com,
        "'Bjorn Helgaas'" <bhelgaas@google.com>,
        linux-arm-kernel@lists.infradead.org
References: <000801cf592e$30b7bff0$92273fd0$%han@samsung.com>
 <4565008.ZECF3eWqge@wuerfel>
 <20140423142315.GO865@e106497-lin.cambridge.arm.com>
 <14215032.8jhN17iHj5@wuerfel>
In-reply-to: <14215032.8jhN17iHj5@wuerfel>
Subject: RE: [RFC PATCH 2/2] PCI: exynos: Add PCIe support for Samsung GH7 SoC
Date: Thu, 24 Apr 2014 13:53:47 +0900
Message-id: <01ff01cf5f79$30f926b0$92eb7410$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQE7j5vEO2bPBvFlE8X5JkO9YLQfLwIWEmlZAa3ehnABfFxYRZwdyDFw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrFIsWRmVeSWpSXmKPExsVy+t8zQ92HMyKCDaa91LP4O+kYu8XVc8cY
	LZY0ZVgc/beQ0eLywkusFu8PPWO22PT4GqvF5V1z2CzOzjvOZnFgaTuLA5fHmnlrGD1+/5rE
	6LFgU6nH5iX1Hrf/PWb26NuyitHj8ya5APYoLpuU1JzMstQifbsEroxZO8+yFrRJVUx7MY+x
	gXGRSBcjJ4eEgInEyo8PGCFsMYkL99azdTFycQgJLGOU2PxxGxtM0e1jd5ggEtMZJU7sesoK
	4fxllPjavZMFpIpNQEPi8Ptn7CC2iICHxI8Hy9lBipgF5jJJrNu7ngkkISSwmVFiTVs6iM0p
	oCWx5/FXsLiwgJ/EkgUnwdaxCKhK/N73FyzOK2ApsfjXG0YIW1Dix+R7YMuYgXrX7zzOBGHL
	S2xe85YZ4lQFiR1nXzNCHOEmsfHSTWaIGhGJfS/eMYIcJCHQyyHxafIFJohlAhLfJh8CGsoB
	lJCV2HQAao6kxMEVN1gmMErMQrJ6FpLVs5CsnoVkxQJGllWMoqkFyQXFSelFJnrFibnFpXnp
	esn5uZsYIfE+YQfjvQPWhxiTgdZPZJYSTc4Hpou8knhDYzMjC1MTU2Mjc0sz0oSVxHnVHiUF
	CQmkJ5akZqemFqQWxReV5qQWH2Jk4uCUamCU4Eo5HikqYnUsW11sj7ce44bDLc8CmTbeEi/I
	c6s5m8rz1sVsxvNTLmISBUuevvzTujdlWXGN6mEPlS97xHSrLxzPaSj0YXRM2Fsk+GN5z5QT
	XDcfL/R5tmv+N/FP2vrJBwuy7nofe72lUv6CfqV82mbBSxYrP7rPSE7d+XRz5+GQ2ckfD6xQ
	YinOSDTUYi4qTgQAmt/0vA0DAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOKsWRmVeSWpSXmKPExsVy+t9jQd2HMyKCDVbu07T4O+kYu8XVc8cY
	LZY0ZVgc/beQ0eLywkusFu8PPWO22PT4GqvF5V1z2CzOzjvOZnFgaTuLA5fHmnlrGD1+/5rE
	6LFgU6nH5iX1Hrf/PWb26NuyitHj8ya5APaoBkabjNTElNQihdS85PyUzLx0WyXv4HjneFMz
	A0NdQ0sLcyWFvMTcVFslF58AXbfMHKDrlBTKEnNKgUIBicXFSvp2mCaEhrjpWsA0Ruj6hgTB
	9RgZoIGEdYwZs3aeZS1ok6qY9mIeYwPjIpEuRk4OCQETidvH7jBB2GISF+6tZ+ti5OIQEpjO
	KHFi11NWCOcvo8TX7p0sIFVsAhoSh98/YwexRQQ8JH48WM4OUsQsMJdJYt3e9WCjhAQ2M0qs
	aUsHsTkFtCT2PP4KFhcW8JNYsuAkG4jNIqAq8XvfX7A4r4ClxOJfbxghbEGJH5PvgS1jBupd
	v/M4E4QtL7F5zVtmiFMVJHacfc0IcYSbxMZLN5khakQk9r14xziBUWgWklGzkIyahWTULCQt
	CxhZVjGKphYkFxQnpeca6hUn5haX5qXrJefnbmIEJ5NnUjsYVzZYHGIU4GBU4uE9cCE8WIg1
	say4MvcQowQHs5II78GaiGAh3pTEyqrUovz4otKc1OJDjMlAn05klhJNzgcmurySeENjEzMj
	SyMzCyMTc3PShJXEeQ+0WgcKCaQnlqRmp6YWpBbBbGHi4JRqYNyx/oyrXdhEL+uTRfp/js2N
	VLh6teetovg9cTuhzU5ctp9N1Y8tKfpq+9isZ9XbQqNd+smPH8bM14/UuWCQaRZ2927S0y2y
	G7iXyCqs+O7dcPznxDTR2vwoKdf+BT98k7cG7wxg1n+zYiZLgs3pxm0PLJlaSuIexP7+6Lp6
	ofPrntMM95pyWJVYijMSDbWYi4oTAQEjX1NqAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> 
> On Wednesday 23 April 2014 15:23:16 Liviu Dudau wrote:
> > > Unfortunately we are in a tricky situation on arm64 because we have
> > > to support both server-type SoCs and embedded-type SoCs. In an
> > > embedded system, you can't trust the boot loader to do a proper
> > > setup of all the hardware, so the kernel needs full control over
> > > all the initialization. In a server, the initialization is the
> > > responsibility of the firmware, and we don't want the kernel to
> > > even know about those registers.

BTW, actually we can trust boot-loader to do required things in mobile also ;-)

> > >
> > > My hope is that all server chips use an SBSA compliant PCIe
> > > implementation, but we already have X-Gene, which is doing server
> > > workloads with a nonstandard PCIe, and it's possible that there
> > > will also be server-like systems with a DesignWare PCIe block
> > > instead of an SBSA compliant one. We can still support those, but
> > > I don't want to see more than one implementation of dw-pcie
> > > on servers. Just like we have the generic PCIe support that Will
> > > is doing for virtual machines and SBSA compliant systems, we
> > > would do one dw-pcie variant for all systems that come with a
> > > host firmware and rely on it being set up already.

OK and I think, just one device driver would be nice for whatever embedded or
server.

> >
> > There is nothing in the SBSA that mandates firmware setup. All it requires

Yeah, I couldn't look at that in the SBSA...

> > is that hardware is setup in a way that is not specific to a board
> > or a particular OEM. Surely if the setup being done for GH7 is always
> > the same it should fit the bill?
> 
But Arnd's comments are about firmware based on each SoC not board?...

> GH7 is already not SBSA compliant because it uses a nonstandard config
> space access method, and it uses its own MSI controller rather than GIC.
> This means it violates at least two out of the four clauses in SBSA
> describing PCIe.
> 
OK, I see. Honestly, we just focused on how to support PCI on both exynos5440
and GH7 SoCs.

> Regardless of this, the level of detail describing config space and
> MSI handling in SBSA can only make sense if the purpose is to handle
> all compliant implementations without platform specific code. If you
> require platform specific setup code in the OS, this underlying assumption
> no longer holds true and there is no point in having a spec in the
> first place.
> 
OK, your assumption makes sense to us.

> I think we should treat DW-PCIe in the same way if anyone attempts
> to use that in a server, e.g. in SBSA level 0. As you can see here,

Agreed. BTW, how about GICv2m for level 1? It can be supported with the same
way in one DW-PCIe driver?

> even when reusing hardware between Exynos and GH7, you can't just
> use the same init code, so it has to be in firmware to be any good.
> On a real server platform, you can't require a kernel upgrade every
> time a new SoC comes out, any basic functionality like PCI just has to
> work with existing OS images.
> 
OK, when Will's driver is ready, we will test it on GH7 with the setup for PCIe
included in firmware. Anyway I hope we can use the driver in 3.16 :-)

Thanks,
Kukjin

