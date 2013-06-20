Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757567Ab3FTJ7v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 05:59:51 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:41278 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754512Ab3FTJ7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 05:59:49 -0400
X-AuditID: cbfee690-b7f6f6d00000740c-1a-51c2d2936799
From: Jingoo Han <jg1.han@samsung.com>
To: "'Bjorn Helgaas'" <bhelgaas@google.com>
Cc: "'Kukjin Kim'" <kgene.kim@samsung.com>, linux-samsung-soc@vger.kernel.org,
        linux-pci@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
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
        Jingoo Han <jg1.han@samsung.com>
References: <00cb01ce6d99$0e932030$2bb96090$@samsung.com>
In-reply-to: <00cb01ce6d99$0e932030$2bb96090$@samsung.com>
Subject: Re: [PATCH V7 1/4] pci: Add PCIe driver for Samsung Exynos
Date: Thu, 20 Jun 2013 18:59:46 +0900
Message-id: <00cf01ce6d9c$e5870540$b0950fc0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQHH8DhMhUHCUm48RAHsHiKm0uiKWJlLVwtg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrAKsWRmVeSWpSXmKPExsVy+t8zfd3Jlw4FGhw5rW7R/H87q8XfScfY
	LZY0ZVgcmP2Q1eLVmY1sFpcXXmK1+H7D1KJ3wVU2i02Pr7FaXN41h83i7LzjbBYzzu9jsljR
	tJXRYvHF5cwWu1cuYbE4NmMJo8XTB01MDoIea+atYfT4/WsSo0fflKtsHk82XWT0WLCp1OPO
	tT1sHpuX1Hucn7GQ0eP7jl6ggi2rGD1+vtTx+LxJLoAnissmJTUnsyy1SN8ugStjxmzugiUc
	FTumP2VpYFzE1sXIySEhYCJxo62XCcIWk7hwbz1QnItDSGAZo8SMRWdZYYouvz3MDJFYxCjR
	9f4CO0hCSOAXo8TW5ykgNpuAmsSXL4fB4iICmhKzV2xhAmlgFtjFKnHtfANQggOowVLiwZRs
	EJNTwEpi1wN1kHJhAWeJV8c/gx3EIqAqcevuSrCDeIGq1/XNZIWwBSV+TL7HAmIzC2hJrN95
	nAnClpfYvOYtM8SdChI7zr5mhDjBSGLd191QNSIS+168YwQ5R0LgAYfEhYOXWSCWCUh8m3yI
	BeQeCQFZiU0HoOZIShxccYNlAqPELCSrZyFZPQvJ6llIVixgZFnFKJpakFxQnJReZKJXnJhb
	XJqXrpecn7uJEZJaJuxgvHfA+hBjMtD6icxSosn5wNSUVxJvaGxmZGFqYmpsZG5pRpqwkjiv
	eot1oJBAemJJanZqakFqUXxRaU5q8SFGJg5OqQbGjqmF4n+VnExCe2/oWixQF5uy0uS9usVa
	/uaaU+3ijVWe9ce+HZ6zY9vK+2+TLM47uzWvDplz+eXymbcbnDrDf69+uZQhM+3Js98lKyaU
	uRmsD/6wWdJZPYqxZFuhyIpX7SdvnVdwX3X900oBMZ1PqttsfgbOqH69L85Vfrp4x7T4hdxl
	bP2blFiKMxINtZiLihMBzkRKhUMDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplk+LIzCtJLcpLzFFi42I5/e+xgO7kS4cCDVa9UbRo/r+d1eLvpGPs
	FkuaMiwOzH7IavHqzEY2i8sLL7FafL9hatG74CqbxabH11gtLu+aw2Zxdt5xNosZ5/cxWaxo
	2sposfjicmaL3SuXsFgcm7GE0eLpgyYmB0GPNfPWMHr8/jWJ0aNvylU2jyebLjJ6LNhU6nHn
	2h42j81L6j3Oz1jI6PF9Ry9QwZZVjB4/X+p4fN4kF8AT1cBok5GamJJapJCal5yfkpmXbqvk
	HRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQP0l5JCWWJOKVAoILG4WEnfDtOE0BA3XQuY
	xghd35AguB4jAzSQsI4xY8Zs7oIlHBU7pj9laWBcxNbFyMkhIWAicfntYWYIW0ziwr31QHEu
	DiGBRYwSXe8vsIMkhAR+MUpsfZ4CYrMJqEl8+XIYLC4ioCkxe8UWJpAGZoFdrBLXzjcAJTiA
	GiwlHkzJBjE5Bawkdj1QBykXFnCWeHX8M9heFgFViVt3VzKB2LxA1ev6ZrJC2IISPybfYwGx
	mQW0JNbvPM4EYctLbF7zFupOBYkdZ18zQpxgJLHu626oGhGJfS/eMU5gFJqFZNQsJKNmIRk1
	C0nLAkaWVYyiqQXJBcVJ6bmGesWJucWleel6yfm5mxjBieuZ1A7GlQ0WhxgFOBiVeHg1Lh8M
	FGJNLCuuzD3EKMHBrCTCmzrnUKAQb0piZVVqUX58UWlOavEhxmSgTycyS4km5wOTal5JvKGx
	iZmRpZGZhZGJuTlpwkrivAdarQOFBNITS1KzU1MLUotgtjBxcEo1MAp/665TbT8hsp5L8lbX
	UyeDKU9yLrw++b+Nc4NY1grurorKCJ1Z1/Osp33nNlDRDZ91sOTljPPJ0/3XT1LJUDebuG3C
	3FO9DzKsP32qs0lNFzBd9DvP+529y5nt17h/xbbOf3/l8lmB00l+U2oniOowcDeqf/GPPvH5
	Xu+my6VZD33i/HfssFViKc5INNRiLipOBAAZPwWboAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, June 20, 2013 6:32 PM, Jingoo Han wrote:
> 
> Exynos5440 has a PCIe controller which can be used as Root Complex.
> This driver supports a PCIe controller as Root Complex mode.
> 
> Signed-off-by: Surendranath Gurivireddy Balla <suren.reddy@samsung.com>
> Signed-off-by: Siva Reddy Kallam <siva.kallam@samsung.com>
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> ---
>  .../devicetree/bindings/pci/exynos-pcie.txt        |   71 ++
>  drivers/pci/host/Kconfig                           |    5 +
>  drivers/pci/host/Makefile                          |    1 +
>  drivers/pci/host/pci-exynos.c                      | 1057 ++++++++++++++++++++
>  4 files changed, 1134 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/pci/exynos-pcie.txt
>  create mode 100644 drivers/pci/host/pci-exynos.c

Dear Bjorn Helgass,

Would you review this patch?
I have posted the Exynos PCIe patch for about 4 months.
But, I have not received your reply.
I need your feedback. :)
Thank you.

Best regards,
Jingoo Han


