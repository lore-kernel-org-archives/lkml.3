Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762192AbaGRUak (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 16:30:40 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:49215 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755035AbaGRUaj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 16:30:39 -0400
Message-ID: <53C9839C.5090604@ti.com>
Date: Fri, 18 Jul 2014 16:29:16 -0400
From: Murali Karicheri <m-karicheri2@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Rob Herring <robherring2@gmail.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Mohit Kumar <mohit.kumar@st.com>,
        Jingoo Han <jg1.han@samsung.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Pratyush Anand <pratyush.anand@st.com>,
        Richard Zhu <r65037@freescale.com>,
        Kishon Vijay Abraham I <kishon@ti.com>, Marek Vasut <marex@denx.de>,
        Arnd Bergmann <arnd@arndb.de>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH v6 4/5] PCI: add PCI controller for keystone PCIe h/w
References: <1405696469-7172-1-git-send-email-m-karicheri2@ti.com> <1405696469-7172-5-git-send-email-m-karicheri2@ti.com> <CAL_JsqKheoWrSGtxPO=AE8g9iOAqfwRa=81Ku=Cfx8_gpDysOg@mail.gmail.com>
In-Reply-To: <CAL_JsqKheoWrSGtxPO=AE8g9iOAqfwRa=81Ku=Cfx8_gpDysOg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rob,

On 07/18/2014 03:31 PM, Rob Herring wrote:
> On Fri, Jul 18, 2014 at 10:14 AM, Murali Karicheri<m-karicheri2@ti.com>  wrote:
--- Cut ---
>> +
>> +Optional properties:-
>> +       phys: phandle to Generic Keystone SerDes phy for PCI
>> +       phy-names: name of the Generic Keystine SerDes phy for PCI
>> +         - If boot loader already does PCI link establishment, then phys and
>> +           phy-names shouldn't be present.
>> +       ti,enable-linktrain - Enable Link training.
>> +         - If boot loader already does PCI link establishment, then this
>> +           shouldn't be present.
>
> Can't you read from the h/w if the link is trained?

Yes.

There are customers who use this driver with PCI Link setup done in the 
boot loader. This property tells the driver to bypass Link setup 
procedure in that case. Is this undesirable and if so. how other 
platforms handle it? Check first if link is trained or start the link 
setup procedure? Let me know. If this is fine, please provide your Ack.

Thanks.

Murali
>
> Rob

