Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161140Ab3FUEWQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 00:22:16 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:63244 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753883Ab3FUEWN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 00:22:13 -0400
X-AuditID: cbfee68d-b7f096d0000043fc-a2-51c3d4f34971
From: Jingoo Han <jg1.han@samsung.com>
To: "'Sachin Kamat'" <sachin.kamat@linaro.org>
Cc: "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Bjorn Helgaas'" <bhelgaas@google.com>,
        linux-samsung-soc@vger.kernel.org, linux-pci@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        "'Grant Likely'" <grant.likely@secretlab.ca>,
        "'Andrew Murray'" <andrew.murray@arm.com>,
        "'Thomas Petazzoni'" <thomas.petazzoni@free-electrons.com>,
        "'Thierry Reding'" <thierry.reding@avionic-design.de>,
        "'Jason Gunthorpe'" <jgunthorpe@obsidianresearch.com>,
        "'Arnd Bergmann'" <arnd@arndb.de>,
        "'Surendranath Gurivireddy Balla'" <suren.reddy@samsung.com>,
        "'Siva Reddy Kallam'" <siva.kallam@samsung.com>,
        "'Thomas Abraham'" <thomas.abraham@linaro.org>,
        "'Tomasz Figa'" <t.figa@samsung.com>,
        "'Pratyush Anand'" <pratyush.anand@st.com>,
        "'Mohit KUMAR'" <Mohit.KUMAR@st.com>, Jingoo Han <jg1.han@samsung.com>
References: <002001ce6e2e$623d7970$26b86c50$@samsung.com>
 <CAK9yfHxCy0JcvsFHo8gERefdiZhxi1J8MNALe5-g6ooTGR-QjA@mail.gmail.com>
In-reply-to: <CAK9yfHxCy0JcvsFHo8gERefdiZhxi1J8MNALe5-g6ooTGR-QjA@mail.gmail.com>
Subject: Re: [PATCH V9 1/4] pci: Add PCIe driver for Samsung Exynos
Date: Fri, 21 Jun 2013 13:22:10 +0900
Message-id: <002f01ce6e36$e61cf5b0$b256e110$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQHEv9aFH+pKaZxyX6AneK9Zg3eF6wJhDLvzmT/lofA=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA5WSa0iTURjHO3vfvW6D0ettHe2mhkLiLK8dM0Uo6P1WJvShL7bm27R0rm1W
	H6KGKZI2zUs4l4iuZUsUcaZ5HTpDMzPvZhdMsYkX0sShTtPa3AK/9u13nud/zu858LAwl0Gm
	JytJLKelYkGyD8HB+3Zmg/mro12xJ9WlHPTwzxsm2i7odkLa9EQ0bzyOOp5NM9HChzoCjVQM
	M9H6RBhSlo8RSD8zzkQjLaUE6i/rIZBqwMBAdU83AcoaPoZ6fysB0qU3APR86CWGalWLOGp9
	pcVRt0oLkGkqnRHDo6rLqgG1tVkAqNyiMYL6oR8CVLk+jfo23kZQ9doH1ICqAlDrTUpr4HUV
	oCzzAZRpox2jVvVHLnKvcM4k0MlJt2npieirnETDW39JodtdTUUepgCj+7MBmwXJUDix1IDZ
	mQcHJ2uJbMBhuZCVABaYLYx/IUv9MG5vFAOo0quB/bAJ4HvDMmFLEaQfNJu7nGzsRgZAXUsN
	wxbCyM8ErCzOxOw3FACuFNmFbDIOrrxow23sSp6FWzVmpo1x0hfqRip361wyAn5qnHOwM9wo
	nNxljPSHtc09DDsfhfXVPx2f8IJN/YvAPsVp+GtS58i7QcPc0u7YkMxhw9aSZYeMhGuFRmuI
	ZW0chvoOxzsesFM3gT8BUL1Hrd6jVu9Rq/coygFeBdxpiVAiuyaSBgXKBCmyNLEoUJiaogf2
	bVI2ga8dkUYgtOrzMU93Yap128Ty+KCQ8GAUFhoWEnwqIvz/yj4HuH4ZkbEupEggp2/StISW
	xkvTkmmZETBYbE8FyNfwpBUSi6itWJHHj3OdPueli1qMX0iILr11XiRnDiYqYrQiKZtVpPX2
	/miCykM7M20l2bMNS1n3cm7su9xa6twrL/LI1PgwUy/w8ntzJpwlzaapzXfFqgxfTQD3+v3v
	a43Z+juPo76IDvK2+fKdvL7eR5Xt/M7cSxptTWOfDy5LFAT5Y1KZ4C9Eq5f6YwMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrLJsWRmVeSWpSXmKPExsVy+t9jQd3PVw4HGuyax2zR/H87q8XfScfY
	LZY0ZVi8PKRpcWD2Q1aLV2c2sllcXniJ1eL7DVOL3gVX2Sw2Pb7GanF51xw2i7PzjrNZzDi/
	j8li49RfjBbtl5QtTv7pZbRY0bSV0WLxxeXMFutnvGax2L1yCYvFsRlLGC2ePmhichDzWDNv
	DaPH71+TGD36plxl83iy6SKjx4JNpR53ru1h89i8pN7j/IyFjB7fd/QCFWxZxejx86WOx9Mf
	e5k9Pm+SC+CNamC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ
	0HXLzAH6WUmhLDGnFCgUkFhcrKRvh2lCaIibrgVMY4Sub0gQXI+RARpIWMeYse+IVsFkkYpF
	C/uZGxiv8HcxcnJICJhI/Nx8iQXCFpO4cG89WxcjF4eQwHRGiRmbZjFCOL8YJU7te88GUsUm
	oCbx5cthdhBbREBHYsWutUwgRcwCN9kklk1vZYboaGCU+DhlKzNIFadAsMTHpXvAdggLOEv8
	XvuFFcRmEVCVWHF5GVicV8BS4vq2F1C2oMSPyffAbGYBLYn1O48zQdjyEpvXvGWGuFVBYsfZ
	14wQV1hJfLi3AqpeRGLfi3eMExiFZiEZNQvJqFlIRs1C0rKAkWUVo2hqQXJBcVJ6rpFecWJu
	cWleul5yfu4mRnDieya9g3FVg8UhRgEORiUe3gClw4FCrIllxZW5hxglOJiVRHjFJgKFeFMS
	K6tSi/Lji0pzUosPMSYDfTqRWUo0OR+YlPNK4g2NTcyMLI3MLIxMzM1JE1YS5z3Yah0oJJCe
	WJKanZpakFoEs4WJg1OqgZH9/LuJFixFC0zTfmspd7RmiyTGbi9sUxfYVnbgLa/HgXOqeSoN
	wtfdPmzLV/m71flD8FfZay+D92p0rp/2SOvw06/PdrKZXFhSyHB5alSunPqxpt4HD+89ld8y
	W2za8RVymfnrJvbOtRJr4FirzHbx8rT9JR7nEusf53LaCr3Q64pYP/nCmgolluKMREMt5qLi
	RADg5O1JwAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, June 21, 2013 1:11 PM, Sachin Kamat wrote:
> 
> Hi Jingoo,
> 
> Some small corrections inline.
> 
> On 21 June 2013 08:51, Jingoo Han <jg1.han@samsung.com> wrote:
> > Exynos5440 has a PCIe controller which can be used as Root Complex.
> > This driver supports a PCIe controller as Root Complex mode.
> >
> > Signed-off-by: Surendranath Gurivireddy Balla <suren.reddy@samsung.com>
> > Signed-off-by: Siva Reddy Kallam <siva.kallam@samsung.com>
> > Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> > Acked-by: Arnd Bergmann <arnd@arndb.de>
> > ---
> >  .../devicetree/bindings/pci/designware-pcie.txt    |   73 ++
> >  drivers/pci/host/Kconfig                           |    9 +
> >  drivers/pci/host/Makefile                          |    1 +
> >  drivers/pci/host/pci-designware.c                  | 1057 ++++++++++++++++++++
> >  4 files changed, 1140 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/pci/designware-pcie.txt
> >  create mode 100644 drivers/pci/host/pci-designware.c
> >
> > diff --git a/Documentation/devicetree/bindings/pci/designware-pcie.txt
> b/Documentation/devicetree/bindings/pci/designware-pcie.txt
> > new file mode 100644
> > index 0000000..e4681e6
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/pci/designware-pcie.txt
> > @@ -0,0 +1,73 @@
> > +* Synopsis Designware PCIe interface
> > +
> > +Required properties:
> > +-compatible: should contain "snps,dw-pcie" to identify the
> > +       core, plus an identifier for the specific instance, such
> > +       as "samsung,exynos5440-pcie".
> > +-reg: base addresses and lengths of the pcie conteroller,
> 
> s/conteroller/controller

OK, I will fix it.

> 
> > +       the phy controller, additional register for the phy controller.
> > +- interrupts: interrupt values for level interrupt,
> > +       pulse interrupt, special interrupt.
> > +- clocks: from common clock binding: handle to pci clock.
> > +- clock-names: from common clock binding: Shall be "pcie", "pcie_bus".
> 
> s/Shall be .../should be "pcie" and "pcie_bus".

OK, I will fix it.

> 
> [snip]
> 
> > +
> > +MODULE_AUTHOR("Jingoo Han <jg1.han@samsung.com>");
> > +MODULE_DESCRIPTION("Samsung PCIe host controller driver");
> > +MODULE_LICENSE("GPLv2");
> 
> I think this should be "GPL v2"  (with a space between GPL and v2).

OK, I will fix it.

Thank you for your caring and comment. :)
I will fix the typo and send PATCH v10 soon.


Best regards,
Jingoo Han

> 
> 
> --
> With warm regards,
> Sachin

