Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933856Ab3HHHPA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 03:15:00 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:21682 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751033Ab3HHHO6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 03:14:58 -0400
X-AuditID: cbfee68f-b7f436d000000f81-2e-520345708f56
From: Jingoo Han <jg1.han@samsung.com>
To: "'Bjorn Helgaas'" <bhelgaas@google.com>
Cc: linux-pci@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Pratyush Anand'" <pratyush.anand@st.com>,
        "'Mohit KUMAR'" <Mohit.KUMAR@st.com>,
        "'Arnd Bergmann'" <arnd@arndb.de>, "'Sean Cross'" <xobs@kosagi.com>,
        "'Kishon Vijay Abraham I'" <kishon@ti.com>,
        "'Thierry Reding'" <thierry.reding@gmail.com>,
        "'SRIKANTH TUMKUR SHIVANAND'" <ts.srikanth@samsung.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Jingoo Han <jg1.han@samsung.com>
References: <002501ce9324$8066f5a0$8134e0e0$@samsung.com>
 <CAErSpo4YuSEsUp6wyXEJyySvqUwOisdq7BURL-eVmzWL+qSgHw@mail.gmail.com>
In-reply-to: <CAErSpo4YuSEsUp6wyXEJyySvqUwOisdq7BURL-eVmzWL+qSgHw@mail.gmail.com>
Subject: Re: [PATCH V5] pci: exynos: split into two parts such as Synopsys part
 and Exynos part
Date: Thu, 08 Aug 2013 16:14:56 +0900
Message-id: <005101ce9406$fc649d50$f52dd7f0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQIk6IcNfCPbK6AAbqXC+2uAIBCzuQF9Z8I6mNJRMpA=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprGKsWRmVeSWpSXmKPExsVy+t8zI90CV+Ygg9e7DC3+TjrGbrGkKcPi
	5SFNi/lHzrFaXF54idWid8FVNosLT3vYLC7vmsNmcXbecTaLGef3MVlsnPqL0aL9krLFz13z
	WCwajz5gtWh98oDRgd/j969JjB47Z91l91iwqdTj+8L57B59W1Yxejz9sZfZ4/iN7UwenzfJ
	BXBEcdmkpOZklqUW6dslcGV09L9jKmjnr1jTMJ2xgXE5dxcjJ4eEgInE92XzmSFsMYkL99az
	dTFycQgJLGOUmDRxE2sXIwdY0e/VTBDx6YwSC+9Nh3J+MUqsXXWGDaSbTUBN4suXw+wgtoiA
	psTsFVvAipgF3jNLrF61iB2io4FRYvufP4wgVZwCwRKfZn1nBbGFBRIlJi7+wgSyjkVAVeJZ
	IxNImFfAUmLOxilsELagxI/J91hAbGYBLYn1O48zQdjyEpvXvIV6QUFix9nXjBBHWEm8PvwN
	qkZEYt+Ld4wgN0gI7OGQaO6cD7aXRUBA4tvkQywQb8pKbDoANUdS4uCKGywTGCVmIVk9C8nq
	WUhWz0KyYgEjyypG0dSC5ILipPQiY73ixNzi0rx0veT83E2MkDTRv4Px7gHrQ4zJQOsnMkuJ
	JucD00xeSbyhsZmRhamJqbGRuaUZacJK4rxqLdaBQgLpiSWp2ampBalF8UWlOanFhxiZODil
	GhiT65faeyjIalXesDD0/sz5buNf05C8H/PWi1yeW/IsvOlOv1Cc3uV/K4zSQvZoK81bdLz5
	yEJbZlG7LydPl831k4iaYJczn9dFTz1i+op3d+s9r52vYnBoVHw4zTWUJTmi8JYUC9ctPy9Z
	fjluFvW64N8TnUW2r1zF/bat2k8m6VOf4Okts5VYijMSDbWYi4oTAV4uCGcpAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMKsWRmVeSWpSXmKPExsVy+t9jQd0CV+Ygg9cntS3+TjrGbrGkKcPi
	5SFNi/lHzrFaXF54idWid8FVNosLT3vYLC7vmsNmcXbecTaLGef3MVlsnPqL0aL9krLFz13z
	WCwajz5gtWh98oDRgd/j969JjB47Z91l91iwqdTj+8L57B59W1Yxejz9sZfZ4/iN7UwenzfJ
	BXBENTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl5gCd
	rqRQlphTChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGPM6Oh/x1TQzl+xpmE6YwPj
	cu4uRg4OCQETid+rmboYOYFMMYkL99azdTFycQgJTGeUWHhvOhOE84tRYu2qM2wgVWwCahJf
	vhxmB7FFBDQlZq/YAlbELPCeWWL1qkXsEB0NjBLb//xhBKniFAiW+DTrOyuILSyQKDFx8Rcm
	kNUsAqoSzxrBVvMKWErM2TiFDcIWlPgx+R4LiM0soCWxfudxJghbXmLzmrfMEKcqSOw4+5oR
	4ggrideHv0HViEjse/GOcQKj0Cwko2YhGTULyahZSFoWMLKsYhRNLUguKE5KzzXUK07MLS7N
	S9dLzs/dxAhOQs+kdjCubLA4xCjAwajEw9sRwBQkxJpYVlyZe4hRgoNZSYT3YjFQiDclsbIq
	tSg/vqg0J7X4EGMy0KMTmaVEk/OBCTKvJN7Q2MTMyNLIzMLIxNycNGElcd4DrdaBQgLpiSWp
	2ampBalFMFuYODilGhj1hJ6Y7J6oG2OwKzHw3QGd2OoDS2wmmzNmfSrfm5z4ZPqjlg//9FXv
	u27VmL7eeunHdg/7Wxv2l6v9OjPhUj/TF7fGE88e+ZxYx9qxn73XX2HG51qu8zV9X/YpTDXr
	niWd87+yiKvROVc7Nn/1SY6K9lBHayXBdBvRx3fVbX3jXJfsixXrOazEUpyRaKjFXFScCAC7
	FL1FhgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, August 08, 2013 2:05 AM, Bjorn Helgaas wrote:
> On Tue, Aug 6, 2013 at 10:13 PM, Jingoo Han <jg1.han@samsung.com> wrote:
> > On Wednesday, July 31, 2013 5:14 PM, Jingoo Han <jg1.han@samsung.com> wrote:
> >> Exynos PCIe IP consists of Synopsys specific part and Exynos
> >> specific part. Only core block is a Synopsys designware part;
> >> other parts are Exynos specific.
> >> Also, the Synopsys designware part can be shared with other
> >> platforms; thus, it can be split two parts such as Synopsys
> >> designware part and Exynos specific part.
> >>
> >> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> >> Cc: Pratyush Anand <pratyush.anand@st.com>
> >> Cc: Mohit KUMAR <Mohit.KUMAR@st.com>
> >
> > Hi Bjorn Helgaas,
> >
> > There is no comment for last 2 weeks.
> > Will you accept this patch?
> 
> I don't have any problem with this, since it's really arch code.  Do
> you want me to merge it, or do you have a standard path for merging
> Exynos and/or Designware changes?

Hi Bjorn,

I want you to merge it. :)
Thank you.

Best regards,
Jingoo Han

> 
> Bjorn
> 
> In case you need it:
> 
> Acked-by: Bjorn Helgaas <bhelgaas@google.com>
> 
> >> ---
> >> Changes since v4:
> >> - fixed section mismatch warnings
> >> - fixed sparse warnings
> >>
> >>  .../devicetree/bindings/pci/designware-pcie.txt    |    3 +
> >>  arch/arm/boot/dts/exynos5440.dtsi                  |    2 +
> >>  drivers/pci/host/Makefile                          |    3 +-
> >>  drivers/pci/host/pci-exynos.c                      |  530 ++++++++++
> >>  drivers/pci/host/pcie-designware.c                 | 1011 ++++++--------------
> >>  drivers/pci/host/pcie-designware.h                 |   65 ++
> >>  6 files changed, 874 insertions(+), 740 deletions(-)
> >>  create mode 100644 drivers/pci/host/pci-exynos.c
> >>  create mode 100644 drivers/pci/host/pcie-designware.h
> >

