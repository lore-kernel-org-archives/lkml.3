Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751673Ab3IZEnq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 00:43:46 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:54244 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751471Ab3IZEno (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 00:43:44 -0400
MIME-Version: 1.0
In-Reply-To: <001b01ceba71$62ca02c0$285e0840$%han@samsung.com>
References: <001a01ceaace$013ec980$03bc5c80$%han@samsung.com> <001b01ceba71$62ca02c0$285e0840$%han@samsung.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 25 Sep 2013 22:43:23 -0600
Message-ID: <CAErSpo4ECRheinv_BAG6MMKeftDS-TBD2kTfkTnTo6P_EfOH4g@mail.gmail.com>
Subject: Re: [PATCH V3] PCI: exynos: add support for MSI
To: Jingoo Han <jg1.han@samsung.com>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        linux-samsung-soc@vger.kernel.org, Kukjin Kim <kgene.kim@samsung.com>,
        Pratyush Anand <pratyush.anand@st.com>,
        Mohit KUMAR <Mohit.KUMAR@st.com>,
        Siva Reddy Kallam <siva.kallam@samsung.com>,
        SRIKANTH TUMKUR SHIVANAND <ts.srikanth@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>, Sean Cross <xobs@kosagi.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        devicetree@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 25, 2013 at 10:32 PM, Jingoo Han <jg1.han@samsung.com> wrote:
> On Friday, September 06, 2013 3:55 PM, Jingoo Han wrote:
>>
>> This patch adds support for Message Signaled Interrupt in the
>> Exynos PCIe diver using Synopsys designware PCIe core IP.
>>
>> Signed-off-by: Siva Reddy Kallam <siva.kallam@samsung.com>
>> Signed-off-by: Srikanth T Shivanand <ts.srikanth@samsung.com>
>> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
>> Cc: Pratyush Anand <pratyush.anand@st.com>
>> Cc: Mohit KUMAR <Mohit.KUMAR@st.com>
>
> Hi Bjorn Helgaas,
>
> There is no comment for last 3 weeks.
> Would you merge this patch to your tree?

I worked on merging your patches today, which is what prompted my
message about how to manage the exynos, mvebu, tegra, etc., host
drivers.  Assuming we come to a consensus about that, they should
appear in -next by the end of this week.

Bjorn
