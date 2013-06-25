Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752479Ab3FYDXH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 23:23:07 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:41439 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752122Ab3FYDXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 23:23:04 -0400
X-AuditID: cbfee68f-b7f436d000000f81-cb-51c90d163ca8
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Bjorn Helgaas'" <bhelgaas@google.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Cc: linux-samsung-soc@vger.kernel.org, linux-pci@vger.kernel.org,
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
        "'Mohit KUMAR'" <Mohit.KUMAR@st.com>
References: <003a01ce6e50$6d5418b0$47fc4a10$@samsung.com>
 <20130625021102.GA13310@google.com>
In-reply-to: <20130625021102.GA13310@google.com>
Subject: RE: [PATCH V10 1/4] pci: Add PCIe driver for Samsung Exynos
Date: Tue, 25 Jun 2013 12:23:03 +0900
Message-id: <007e01ce7153$4d4b0730$e7e11590$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac5xSUHATlQeDKJCSNuwU/zw9T5AAgACYJ0A
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCKsWRmVeSWpSXmKPExsVy+t8zY10x3pOBBuub2Sya/29ntfg76Ri7
	xZKmDIuXhzQtDsx+yGrx6sxGNovLCy+xWny/YWqx6fE1VovLu+awWZydd5zNYsb5fUwWG6f+
	YrRov6RssaJpK6PF4ovLmS3Wz3jNYrF75RIWi2MzljBaPH3QxOQg4rFm3hpGj9+/JjF69E25
	yubxZNNFRo8Fm0o97lzbw+axeUm9x/kZCxk9vu/oBSrYsorR4+dLHY+nP/Yye3zeJBfAG8Vl
	k5Kak1mWWqRvl8CVMff0CcaC16wVbYvfszQw3mHpYuTkkBAwkXi+6zM7hC0mceHeerYuRi4O
	IYFljBKNu7cwwhS96vjACpGYzijx/mg/O4Tzl1Fi/f9PbCBVbAIaEoffPwMbJSLgKzHnzRew
	DmaBZ6wS9w9/AEsICcRLrG2czwRicwoYSKxqfAV2h7CAi8T56f9ZQWwWAVWJD5Pug9XzCthK
	NG/bxQJhC0r8mHwPzGYW0JJYv/M4E4QtL7F5zVvmLkYOoFPVJR791YW4wUji8VmI15gFRCT2
	vXgH9c1/DonOTm2IVQIS3yYfYoFolZXYdIAZokRS4uCKGywTGCVmIVk8C8niWUgWz0KyYQEj
	yypG0dSC5ILipPQiY73ixNzi0rx0veT83E2MkBTUv4Px7gHrQ4zJQOsnMkuJJucDU1heSbyh
	sZmRhamJqbGRuaUZacJK4rxqLdaBQgLpiSWp2ampBalF8UWlOanFhxiZODilGhhnPU6R5TrJ
	9VTg3rUXYbMtyzjy59uX+KvtMbi7w/7q/HNVJtdf7hU/KMoiZf34bNATNpV9t5b45jDb9+fe
	lWducjuvq8BcnsT0sb/+WvjUyK+f/pzYstfTvbUlc6X1haKeV89i1/aUbJJR2rVfarOI/eR6
	Y9Eg22NB73xWPPepPRA7KXj14u1KLMUZiYZazEXFiQDEZlWbVwMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrEJsWRmVeSWpSXmKPExsVy+t9jQV1R3pOBBmsP2lg0/9/OavF30jF2
	iyVNGRYvD2laHJj9kNXi1ZmNbBaXF15itfh+w9Ri0+NrrBaXd81hszg77zibxYzz+5gsNk79
	xWjRfknZYkXTVkaLxReXM1usn/GaxWL3yiUsFsdmLGG0ePqgiclBxGPNvDWMHr9/TWL06Jty
	lc3jyaaLjB4LNpV63Lm2h81j85J6j/MzFjJ6fN/RC1SwZRWjx8+XOh5Pf+xl9vi8SS6AN6qB
	0SYjNTEltUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMH6FMlhbLE
	nFKgUEBicbGSvh2mCaEhbroWMI0Rur4hQXA9RgZoIGEdY8bc0ycYC16zVrQtfs/SwHiHpYuR
	k0NCwETiVccHVghbTOLCvfVsXYxcHEIC0xkl3h/tZ4dw/jJKrP//iQ2kik1AQ+Lw+2fsILaI
	gK/EnDdfWEGKmAWesUrcP/wBLCEkEC+xtnE+E4jNKWAgsarxFdg6YQEXifPT/4OtYxFQlfgw
	6T5YPa+ArUTztl0sELagxI/J98BsZgEtifU7jzNB2PISm9e8Ze5i5AA6VV3i0V9diBuMJB6f
	/cwOUSIise/FO8YJjEKzkEyahWTSLCSTZiFpWcDIsopRNLUguaA4KT3XSK84Mbe4NC9dLzk/
	dxMjOMU9k97BuKrB4hCjAAejEg/vh7gTgUKsiWXFlbmHGCU4mJVEeENFgEK8KYmVValF+fFF
	pTmpxYcYk4EencgsJZqcD0y/eSXxhsYmZkaWRmYWRibm5qQJK4nzHmy1DhQSSE8sSc1OTS1I
	LYLZwsTBKdXA6KDJpGbi/G7HBt09BXHvef7y3DCu6pWZNTf1/flVJbs2Vp94r2aqfM9itaEW
	V9HMrb+WzVywx5PVTfSBffwJrejsIJuVgl+kb/6NeXXdJU6YWdPwk9Sxjac6sq1/fvy6QZn/
	rkix1DWDiDIG/rgQxu+rcl5ue9m8cuNnrRVR/78su7FUUshrkxJLcUaioRZzUXEiAL6sg7O1	AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bjorn Helgaas wrote:
> 
> On Fri, Jun 21, 2013 at 04:24:54PM +0900, Jingoo Han wrote:
> > Exynos5440 has a PCIe controller which can be used as Root Complex.
> > This driver supports a PCIe controller as Root Complex mode.
> >
> > Signed-off-by: Surendranath Gurivireddy Balla <suren.reddy@samsung.com>
> > Signed-off-by: Siva Reddy Kallam <siva.kallam@samsung.com>
> > Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> > Acked-by: Arnd Bergmann <arnd@arndb.de>
> 
> Acked-by: Bjorn Helgaas <bhelgaas@google.com>
> 
> Please merge this through arm-soc as you discussed.
> 
Sounds great.

Arnd, please take this series into arm-soc tree directly by yourself with my
ack on arch/exynos stuff if you want ;)

Thanks,
- Kukjin

