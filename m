Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755594Ab3H2Dph (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 23:45:37 -0400
Received: from eu1sys200aog108.obsmtp.com ([207.126.144.125]:47325 "EHLO
	eu1sys200aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755277Ab3H2Dpf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 23:45:35 -0400
Date: Thu, 29 Aug 2013 09:15:08 +0530
From: Pratyush Anand <pratyush.anand@st.com>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Bjorn Helgaas'" <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        Mohit KUMAR DCG <Mohit.KUMAR@st.com>,
        "'Siva Reddy Kallam'" <siva.kallam@samsung.com>,
        "'SRIKANTH TUMKUR SHIVANAND'" <ts.srikanth@samsung.com>,
        "'Arnd Bergmann'" <arnd@arndb.de>, "'Sean Cross'" <xobs@kosagi.com>,
        "'Kishon Vijay Abraham I'" <kishon@ti.com>,
        "'Thierry Reding'" <thierry.reding@gmail.com>,
        "'Thomas Petazzoni'" <thomas.petazzoni@free-electrons.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH V2] PCI: exynos: add support for MSI
Message-ID: <20130829034508.GA3025@pratyush-vbox>
References: <003d01ce9fc6$9c0f1c20$d42d5460$%han@samsung.com>
 <20130823083539.GB3937@pratyush-vbox>
 <001801cea3c7$06bca9d0$1435fd70$%han@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <001801cea3c7$06bca9d0$1435fd70$%han@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 28, 2013 at 04:17:24PM +0800, Jingoo Han wrote:
> On Friday, August 23, 2013 5:36 PM, Pratyush Anand wrote:
> > On Fri, Aug 23, 2013 at 02:04:20PM +0800, Jingoo Han wrote:
> 

[...]

> > #define MAX_PCIE_PORT_SUPPORTED 3
> > static DECLARE_BITMAP(msi_irq_in_use[MAX_PCIE_PORT_SUPPORTED],
> >                   NUM_MSI_IRQS);
> > static unsigned int *msi_data[MAX_PCIE_PORT_SUPPORTED];
> 
> No, there is no need to do it.
> Without this, we can use 3 RCs by adding a node of 3rd RC to dt file.
> 

Yes, you can use RCs by adding nodes to dt file. But you will need one 
msi_irq_in_use and one msi_data per RC (ie per port in this driver), isn't it? 

Regards
Pratyush

