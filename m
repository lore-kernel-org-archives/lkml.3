Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756705Ab3FUEqE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 00:46:04 -0400
Received: from eu1sys200aog115.obsmtp.com ([207.126.144.139]:41677 "EHLO
	eu1sys200aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755832Ab3FUEqB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 00:46:01 -0400
Message-ID: <51C3D517.1080301@st.com>
Date: Fri, 21 Jun 2013 09:52:47 +0530
From: Pratyush Anand <pratyush.anand@st.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Bjorn Helgaas'" <bhelgaas@google.com>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "'Grant Likely'" <grant.likely@secretlab.ca>,
        "'Andrew Murray'" <andrew.murray@arm.com>,
        "'Thomas Petazzoni'" <thomas.petazzoni@free-electrons.com>,
        "'Thierry Reding'" <thierry.reding@avionic-design.de>,
        "'Jason Gunthorpe'" <jgunthorpe@obsidianresearch.com>,
        "'Arnd Bergmann'" <arnd@arndb.de>,
        "'Surendranath Gurivireddy Balla'" <suren.reddy@samsung.com>,
        "'Siva Reddy Kallam'" <siva.kallam@samsung.com>,
        "'Thomas Abraham'" <thomas.abraham@linaro.org>,
        "'Tomasz Figa'" <t.figa@samsung.com>, Mohit KUMAR <Mohit.KUMAR@st.com>
Subject: Re: [PATCH V9 1/4] pci: Add PCIe driver for Samsung Exynos
References: <002001ce6e2e$623d7970$26b86c50$@samsung.com>
In-Reply-To: <002001ce6e2e$623d7970$26b86c50$@samsung.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/21/2013 8:51 AM, Jingoo Han wrote:
> diff --git a/drivers/pci/host/pci-designware.c b/drivers/pci/host/pci-designware.c
> new file mode 100644
> index 0000000..f8558ff
> --- /dev/null
> +++ b/drivers/pci/host/pci-designware.c

If you plan to send next version, then I would suggest to rename it as 
pcie-designware.c, because synopsis pcie and pci controllers are different.

Regards
Pratyush




