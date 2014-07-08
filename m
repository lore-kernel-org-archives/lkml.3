Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754716AbaGHMnP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 08:43:15 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:40996 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750867AbaGHMnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 08:43:12 -0400
X-AuditID: cbfee68f-b7fef6d000003970-ba-53bbe75ae51d
From: Jingoo Han <jg1.han@samsung.com>
To: "'Murali Karicheri'" <m-karicheri2@ti.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc: "'Santosh Shilimkar'" <santosh.shilimkar@ti.com>,
        "'Russell King'" <linux@arm.linux.org.uk>,
        "'Grant Likely'" <grant.likely@linaro.org>,
        "'Rob Herring'" <robh+dt@kernel.org>,
        "'Mohit Kumar'" <mohit.kumar@st.com>,
        "'Bjorn Helgaas'" <bhelgaas@google.com>,
        "'Pratyush Anand'" <pratyush.anand@st.com>,
        "'Richard Zhu'" <r65037@freescale.com>,
        "'Kishon Vijay Abraham I'" <kishon@ti.com>,
        "'Marek Vasut'" <marex@denx.de>, "'Arnd Bergmann'" <arnd@arndb.de>,
        "'Pawel Moll'" <pawel.moll@arm.com>,
        "'Mark Rutland'" <mark.rutland@arm.com>,
        "'Ian Campbell'" <ijc+devicetree@hellion.org.uk>,
        "'Kumar Gala'" <galak@codeaurora.org>,
        "'Randy Dunlap'" <rdunlap@infradead.org>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <1404164720-11066-1-git-send-email-m-karicheri2@ti.com>
 <1404164720-11066-6-git-send-email-m-karicheri2@ti.com>
In-reply-to: <1404164720-11066-6-git-send-email-m-karicheri2@ti.com>
Subject: Re: [PATCH v3 5/5] PCI: add PCI controller for Keystone PCIe h/w
Date: Tue, 08 Jul 2014 21:43:06 +0900
Message-id: <000f01cf9aaa$2a59a6b0$7f0cf410$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac+UrMGTfM67rmaCS3qgbKDGYzS6lAF/AiIw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA5WSa0hTYRjHe885O5uKdPLWm1SCkuLA69TeLC2kDyeoSPsQ2AebdnSizrHN
	siLQzGvqvFDaFG9dvCdO0akZc17L1OUqzWyRYWlqEZmZt3IeAr/27fc8z+/l/7zw8HCLCY4t
	L1IsZ6RiYbQ9aUoMbnxycwn+3HHWfeQuH63n9XHR/RsiNKt1RqU9wxykmC/nIM2aGqDhL9UA
	6ctHOUg3nUkifXsxiYZK+kn0Vm+OsrM0JJpPSQTowdgLDDXeXgEop6CeQKmjDuij0hItTBYQ
	KLmzh4vmsuvwYzZ0XUkdoG8mZZL06koeoPXZWRhdohwg6I1uBUaXqeLo6spFkm6q4tOqmnSS
	nnz9mKSzm2sAPb3cidP9460Y/UO1/8zOYNMjF5noyEuM1M3/gqkocamWlLTA+BZ1H5kA0iwz
	gAkPUl6wYqiIw7IN1BkayAxgyrOgHgI4PpvI+SdN/lRw2EEBgJX5cxhbrAK4lpuyZZGUI1xc
	7OYaB1ZUEoA6fftWgVMNHPjyUQJptCyo63DiXgJhZBPqOFzuyN9iS+oETJ3QcY1MUAdg+dhv
	3MjmlB/szTJwWd4Fl/MNWz5O8WFDWz/Gsh1sqlvY9HmbuzrBqXUXY9uK8oTp8604q1jBJzNf
	gXEfSBWZwMa5WwSbRcGlfC3Bvt0HVRqc/fIe2FU1TuQAqNyWrNyWrNyWrNwWUQaIGmDNSMIk
	stAIqcBVJoyRxYkjXMNiY1SAvSuFGrzTHNaCsM34XNzWOix28+7E8hAPgY8n8vbyFngePOTz
	f2373ebvP4QGWVARQjkTxTASRhoijYtmZFqA8UxsE0BQc6HgzyxQ+MmOyrUzbaX959RzXbbf
	rPlmWqXol7r+qhobkcAl//gdhg7Rc1mVY4x3YOZJfWWg+JrmdIBZssOdVzXTor1KJ+/eqYpn
	Anff8ME3/CRDwahKqgswz/vuE5Ll/DSzNm34VFphjm/xFQc7ckYVdXlALh8OOY9NhdsTMpHQ
	g49LZcK/DV+prW0DAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupkk+LIzCtJLcpLzFFi42I5/e+xoG7U893BBrt+Klv8nXSM3WJJU4bF
	y0OaFvOPnGO16H+zkNXiwJ8djBbnXq1ktLi88BKrxYWnPWwWl3fNYbM4O+84m8Xty7wWfb0H
	2CzetDUyWiy9fpHJYuPUX4wWE6avZbFov6Rs8XiWsMXbO9NZLFr3HmG3eN23htlBzGPNvDWM
	Hi3NPWwev39NYvS43NfL5DFv1gkWj3+H+5k8Fmwq9Vi5/Aubx+YVWh6bVnWyedy5tofNo2/L
	KkaPpz/2Mnscv7GdyePzJrkA/qgGRpuM1MSU1CKF1Lzk/JTMvHRbJe/geOd4UzMDQ11DSwtz
	JYW8xNxUWyUXnwBdt8wcoO+VFMoSc0qBQgGJxcVK+naYJoSGuOlawDRG6PqGBMH1GBmggYR1
	jBmN31azFWyTqNi24xhbA2OHcBcjJ4eEgInEna/9rBC2mMSFe+vZuhi5OIQEpjNKLJ/8mgnC
	+c0o8WdiG1gVm4CaxJcvh9lBEiICzYwSFy7vAnOYBdazSlxZ18AGUiUkUCtxa3EDC4jNKeAi
	8WP3ZDBbWMBTov3WBXYQm0VAVWLh9Z/MIDavgK3E0d577BC2oMSPyffA6pkFtCTW7zzOBGHL
	S2xe8xaongPoVnWJR391QcIiAkYSnW+2M0OUiEjse/GOcQKj0Cwkk2YhmTQLyaRZSFoWMLKs
	YhRNLUguKE5KzzXSK07MLS7NS9dLzs/dxAhOhs+kdzCuarA4xCjAwajEw7vi4K5gIdbEsuLK
	3EOMEhzMSiK8X07tDhbiTUmsrEotyo8vKs1JLT7EaAr06ERmKdHkfGCiziuJNzQ2MTOyNDKz
	MDIxN1cS5z3Yah0oJJCeWJKanZpakFoE08fEwSnVwDjD2+ntfs9LMxPrZHRLG28pi+nNn6Qr
	GfOpQfzDsU9Fbqvmbc2cFeb/uqXYnvn77ngNf+PPf65tzbC69K6gyET0pj6r1BN+hovH1t41
	098easb66jlbwxf2eI0iJp4pDdFLLu28LKUVtK3/5IW7vmwmDBnZNiecBWd7vpOVeK3JbCk1
	/eLrl0osxRmJhlrMRcWJAO83eN2cAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, July 01, 2014 6:45 AM, Murali Karicheri wrote:
> 
> Keystone PCIe controller is based on v3.65 version of the
> designware h/w. Main differences are
> 	1. No ATU support
> 	2. Legacy and MSI irq functions are implemented in
> 	   application register space
> 	3. MSI interrupts are multiplexed over 8 IRQ lines to the Host
> 	   side.
> All of the Application register space handing code are organized into
> pci-keystone-dw.c and the functions are called from pci-keystone.c
> to implement PCI controller driver. Also add necessary DT documentation
> for the driver.
> 
> Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
> 
> CC: Santosh Shilimkar <santosh.shilimkar@ti.com>
> CC: Russell King <linux@arm.linux.org.uk>
> CC: Grant Likely <grant.likely@linaro.org>
> CC: Rob Herring <robh+dt@kernel.org>
> CC: Mohit Kumar <mohit.kumar@st.com>
> CC: Jingoo Han <jg1.han@samsung.com>
> CC: Bjorn Helgaas <bhelgaas@google.com>
> CC: Pratyush Anand <pratyush.anand@st.com>
> CC: Richard Zhu <r65037@freescale.com>
> CC: Kishon Vijay Abraham I <kishon@ti.com>
> CC: Marek Vasut <marex@denx.de>
> CC: Arnd Bergmann <arnd@arndb.de>
> CC: Pawel Moll <pawel.moll@arm.com>
> CC: Mark Rutland <mark.rutland@arm.com>
> CC: Ian Campbell <ijc+devicetree@hellion.org.uk>
> CC: Kumar Gala <galak@codeaurora.org>
> CC: Randy Dunlap <rdunlap@infradead.org>
> CC: Grant Likely <grant.likely@linaro.org>
> ---
>  .../devicetree/bindings/pci/pci-keystone.txt       |   69 +++
>  drivers/pci/host/Kconfig                           |    5 +
>  drivers/pci/host/Makefile                          |    1 +
>  drivers/pci/host/pci-keystone-dw.c                 |  523 ++++++++++++++++++++
>  drivers/pci/host/pci-keystone.c                    |  381 ++++++++++++++
>  drivers/pci/host/pci-keystone.h                    |   56 +++
>  6 files changed, 1035 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/pci/pci-keystone.txt
>  create mode 100644 drivers/pci/host/pci-keystone-dw.c
>  create mode 100644 drivers/pci/host/pci-keystone.c
>  create mode 100644 drivers/pci/host/pci-keystone.h
> 

[.....]

> +
> +static int __init ks_pcie_probe(struct platform_device *pdev)
> +{
> +	struct device_node *np = pdev->dev.of_node;
> +	struct device *dev = &pdev->dev;
> +	struct keystone_pcie *ks_pcie;
> +	struct pcie_port *pp;
> +	struct resource *res;
> +	void __iomem *reg_p;
> +	struct phy *phy;
> +	int ret = 0;
> +	u32 val;
> +
> +	ks_pcie = devm_kzalloc(&pdev->dev, sizeof(*ks_pcie),
> +				GFP_KERNEL);
> +	if (!ks_pcie) {
> +		dev_err(dev, "no memory for keystone pcie\n");
> +		return -ENOMEM;
> +	}
> +	pp = &ks_pcie->pp;
> +
> +	/* initialize SerDes Phy if present */
> +	phy = devm_phy_get(dev, "pcie-phy");
> +	if (phy)
> +		ret = phy_init(phy);

Why don't you check 'ret' value?
How about the following?

+	/* initialize SerDes Phy if present */
+	phy = devm_phy_get(dev, "pcie-phy");
+	if (!IS_ERR_OR_NULL(phy) {
+		ret = phy_init(phy);
+		if (ret <0)
+			return ret;
+	}


Best regards,
Jingoo Han

[....]


