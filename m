Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753408AbaGQDcu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 23:32:50 -0400
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:58421 "EHLO
	mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752507AbaGQDcr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 23:32:47 -0400
Date: Thu, 17 Jul 2014 09:01:32 +0530
From: Pratyush Anand <pratyush.anand@st.com>
To: Murali Karicheri <m-karicheri2@ti.com>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Richard Zhu <r65037@freescale.com>,
        Kishon Vijay Abraham I <kishon@ti.com>, Marek Vasut <marex@denx.de>,
        Arnd Bergmann <arnd@arndb.de>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH v5 2/5] PCI: designware: refactor MSI code to work with
 v3.65 dw hardware
Message-ID: <20140717033132.GH12278@pratyush-vbox>
References: <1405528686-16539-1-git-send-email-m-karicheri2@ti.com>
 <1405528686-16539-3-git-send-email-m-karicheri2@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1405528686-16539-3-git-send-email-m-karicheri2@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.14,0.0.0000
 definitions=2014-07-17_01:2014-07-16,2014-07-17,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2014 at 12:38:03AM +0800, Murali Karicheri wrote:
> Keystone PCI controller is based on v3.65 version of the DW
> PCI h/w that implements MSI controller registers in application
> space compared to the newer version. This requires updates to
> the DW core API to support the PCI controller driver based on
> this old DW hardware. Add msi_irq_set()/clear() API functions to
> allow Set/Clear MSI IRQ enable bit in the application register.
> Also the old h/w uses MSI_IRQ register in application register
> space to raise MSI IRQ to the RC from EP. Current code uses the
> standard mechanism as per PCI spec. So add another API get_msi_data()
> to get the address of this register so that common code can be
> re-used on old h/w.
> 
> Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
> Acked-by: Mohit Kumar <mohit.kumar@st.com>
> Acked-by: Jingoo Han <jg1.han@samsung.com>
> Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
> 

Reviewed-by: Pratyush Anand <pratyush.anand@st.com>
