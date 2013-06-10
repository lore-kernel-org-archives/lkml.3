Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752675Ab3FJIik (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 04:38:40 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:20087 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751971Ab3FJIig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 04:38:36 -0400
X-AuditID: cbfee68d-b7f096d0000043fc-2e-51b5908a0fe1
From: Jingoo Han <jg1.han@samsung.com>
To: "'Arnd Bergmann'" <arnd@arndb.de>,
        "'Jason Gunthorpe'" <jgunthorpe@obsidianresearch.com>
Cc: linux-arm-kernel@lists.infradead.org,
        "'Thomas Petazzoni'" <thomas.petazzoni@free-electrons.com>,
        linux-samsung-soc@vger.kernel.org,
        "'Siva Reddy Kallam'" <siva.kallam@samsung.com>,
        "'Surendranath Gurivireddy Balla'" <suren.reddy@samsung.com>,
        linux-pci@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        "'Thierry Reding'" <thierry.reding@avionic-design.de>,
        linux-kernel@vger.kernel.org,
        "'Grant Likely'" <grant.likely@secretlab.ca>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Thomas Abraham'" <thomas.abraham@linaro.org>,
        "'Bjorn Helgaas'" <bhelgaas@google.com>,
        "'Andrew Murray'" <andrew.murray@arm.com>,
        Jingoo Han <jg1.han@samsung.com>
References: <00c001ce277b$92b26ab0$b8174010$%han@samsung.com>
 <1880458.2ksb8qtzHh@wuerfel> <20130607162050.GA31895@obsidianresearch.com>
 <201306071943.18407.arnd@arndb.de>
In-reply-to: <201306071943.18407.arnd@arndb.de>
Subject: Re: [PATCH 6/6] ARM: dts: Add pcie controller node for Samsung
 EXYNOS5440 SoC
Date: Mon, 10 Jun 2013 17:38:33 +0900
Message-id: <000001ce65b5$e45477f0$acfd67d0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQFyr6c5AKxr6zs5JXOh3KubdCPksAIm69SGAoi7AaUBxY6qvZmyYZqQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKKsWRmVeSWpSXmKPExsVy+t8zfd2uCVsDDdYd47Zo/r+d1eLvpGPs
	FkuaMiwOzH7IavHqzEY2i8sLL7FafL9hatG74CqbxabH11gtLu+aw2Zxdt5xNosZ5/cxWaxo
	2sposfjicmaL3SuXsFgcm7GE0eLpgyYmB0GPNfPWMHr8/jWJ0aNvylU2jyebLjJ6LNhU6nHn
	2h42j81L6j3Oz1jI6PF9Ry9QwZZVjB4/X+p4fN4kF8ATxWWTkpqTWZZapG+XwJUxacZW9oI7
	ohUbt7QyNTB+F+hi5OSQEDCRuHlyKguELSZx4d56ti5GLg4hgWWMEvebJjDDFF1YvRAqMZ1R
	4vXlt4wQzi9GiZP3TrOCVLEJqEl8+XKYHcQWEYiSWP/hBRNIEbNAN6vEsSN3WSA61jNKnDn/
	jBGkilNAX2LWhudgy4UFIiSuPH/MBGKzCKhKHFi4B2w3r4ClxNPDa9kgbEGJH5PvgdUzC2hJ
	rN95nAnClpfYvOYt1K0KEjvOvmaEuMJN4tqbr2wQNSIS+168AztbQuAJh8TnP3tZIZYJSHyb
	fAhoKAdQQlZi0wGoOZISB1fcYJnAKDELyepZSFbPQrJ6FpIVCxhZVjGKphYkFxQnpRcZ6hUn
	5haX5qXrJefnbmKEJJneHYy3D1gfYkwGWj+RWUo0OR+YpPJK4g2NzYwsTE1MjY3MLc1IE1YS
	51VrsQ4UEkhPLEnNTk0tSC2KLyrNSS0+xMjEwSnVwMgteuBUgvCSs1c7FdxPGbG99ziR+cDO
	VLH8Y4rK8ZeJLRv+NQR2fL+lUL78/4a7ZV/EXKS3fnBZfngrX2aS/9s7Px05nsVfaoi+oqi8
	fd+p2h2xr/cXzU45zm6t4jchd4+qQkbGXumHcm+4TLbOPXZgQ69CxLQu++DwvZZrumRFJDdk
	VjEpuCixFGckGmoxFxUnAgAROTCGSAMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprEJsWRmVeSWpSXmKPExsVy+t9jQd2uCVsDDc6dYLVo/r+d1eLvpGPs
	FkuaMiwOzH7IavHqzEY2i8sLL7FafL9hatG74CqbxabH11gtLu+aw2Zxdt5xNosZ5/cxWaxo
	2sposfjicmaL3SuXsFgcm7GE0eLpgyYmB0GPNfPWMHr8/jWJ0aNvylU2jyebLjJ6LNhU6nHn
	2h42j81L6j3Oz1jI6PF9Ry9QwZZVjB4/X+p4fN4kF8AT1cBok5GamJJapJCal5yfkpmXbqvk
	HRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQP0l5JCWWJOKVAoILG4WEnfDtOE0BA3XQuY
	xghd35AguB4jAzSQsI4xY9KMrewFd0QrNm5pZWpg/C7QxcjJISFgInFh9UI2CFtM4sK99UA2
	F4eQwHRGideX3zJCOL8YJU7eO80KUsUmoCbx5cthdhBbRCBKYv2HF0wgRcwC3awSx47cZYHo
	WM8oceb8M0aQKk4BfYlZG56zgNjCAhESV54/ZgKxWQRUJQ4s3MMMYvMKWEo8PbyWDcIWlPgx
	+R5YPbOAlsT6nceZIGx5ic1r3jJD3KogsePsa0aIK9wkrr35ygZRIyKx78U7xgmMQrOQjJqF
	ZNQsJKNmIWlZwMiyilE0tSC5oDgpPddIrzgxt7g0L10vOT93EyM4hT2T3sG4qsHiEKMAB6MS
	D++DX1sChVgTy4orcw8xSnAwK4nwzmrYGijEm5JYWZValB9fVJqTWnyIMRno04nMUqLJ+cD0
	mlcSb2hsYmZkaWRmYWRibk6asJI478FW60AhgfTEktTs1NSC1CKYLUwcnFINjK1a/SpzzEPL
	J+/SZY2J8DgU8HEXe7rlS0333jl6oUzpa9bcKvu6XnbjFoezKb3GrTee7fPt47vsNT1eb/9W
	T/aszRbLHfm2cLN1BoqtvPyuav3xL5Pkp1SvvKQoqshxMefk1egNtWu8zxiotrLXJvXvmtln
	6M2z7sPLU+4XCq79Onbh5lLGEiWW4oxEQy3mouJEAOzs3VilAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, June 08, 2013 2:43 AM, Arnd Bergmann wrote:
> On Friday 07 June 2013, Jason Gunthorpe wrote:
> > Sounds fair to me.
> >
> > But when we talk about multiple domains we don't mean a disjoint range
> > bus bus numbers, as your other email shows:
> >
> > 00:00.0 PCI bridge: Samsung Electronics Co Ltd Device a549 (rev 01) (prog-if 00 [Normal decode])
> > 10:00.0 PCI bridge: Samsung Electronics Co Ltd Device a549 (rev 01) (prog-if 00 [Normal decode])
> >
> > We mean multiple domains, it should look like this:
> >
> > 0000:00:00.0 PCI bridge: Samsung Electronics Co Ltd Device a549 (rev 01) (prog-if 00 [Normal decode])
> > 0001:00:00.0 PCI bridge: Samsung Electronics Co Ltd Device a549 (rev 01) (prog-if 00 [Normal decode])
> >
> > ie lspci -D.
> >
> > Each domain gets a unique bus number range, config space, io range,
> > etc. This is much clearer to everyone than trying to pretend there is
> > only one domain when the HW is actually multi-domain.
> 
> Yes, absolutely. This means we also don't need a bus-range property in DT, since each
> domain will allow all 255 buses.

After removing a bus-range property in DT, it looks like:

00:00.0 PCI bridge: Samsung Electronics Co Ltd Device a549 (rev 01) (prog-if 00 [Normal decode])
02:00.0 PCI bridge: Samsung Electronics Co Ltd Device a549 (rev 01) (prog-if 00 [Normal decode])

For multiple domains, how can I fix the DT properties?

Current DT properties are as below:

+	pcie0@40000000 {
+		compatible = "samsung,exynos5440-pcie";
+		reg = <0x40000000 0x4000
+			0x290000 0x1000
+			0x270000 0x1000
+			0x271000 0x40>;
+		interrupts = <0 20 0>, <0 21 0>, <0 22 0>;
+		#address-cells = <3>;
+		#size-cells = <2>;
+		device_type = "pci";
+		ranges = <0x00000800 0 0x40000000 0x40000000 0 0x00200000   /* configuration space */
+			  0x81000000 0 0	  0x40200000 0 0x00004000   /* downstream I/O */
+			  0x82000000 0 0	  0x40204000 0 0x10000000>; /* non-prefetchable memory */
+	};
+
+	pcie1@60000000 {
+		compatible = "samsung,exynos5440-pcie";
+		reg = <0x60000000 0x4000
+			0x2a0000 0x1000
+			0x272000 0x1000
+			0x271040 0x40>;
+		interrupts = <0 23 0>, <0 24 0>, <0 25 0>;
+		#address-cells = <3>;
+		#size-cells = <2>;
+		device_type = "pci";
+		ranges = <0x00000800 0 0x60000000 0x60000000 0 0x00200000   /* configuration space */
+			  0x81000000 0 0	  0x60200000 0 0x00004000   /* downstream I/O */
+			  0x82000000 0 0	  0x60204000 0 0x10000000>; /* non-prefetchable memory */
+	};



Best regards,
Jingoo Han

> 
> 	Arnd
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

