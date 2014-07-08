Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754215AbaGHLSU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 07:18:20 -0400
Received: from dns-bn1lp0143.outbound.protection.outlook.com ([207.46.163.143]:18376
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753139AbaGHLSS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 07:18:18 -0400
Date: Tue, 8 Jul 2014 13:18:02 +0200
From: Michal Simek <michal.simek@xilinx.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Olof Johansson <olof@lixom.net>,
        =?UTF-8?B?QW5kcmVhcyBGw6RyYmVy?= <afaerber@suse.de>
CC: Michal Simek <michal.simek@xilinx.com>,
        Andreas Olofsson <andreas@adapteva.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH 1/1] ARM: dts: zynq: Add Parallella device tree
References: <1404075022-28745-1-git-send-email-afaerber@suse.de>
	<1404075022-28745-2-git-send-email-afaerber@suse.de>
 <CAOesGMhKY1Lb+o8AbtFXS5c7SLg2uGt4-oosdro2FMj_+bB6Tw@mail.gmail.com>
In-Reply-To: <CAOesGMhKY1Lb+o8AbtFXS5c7SLg2uGt4-oosdro2FMj_+bB6Tw@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-RCIS-Action: ALLOW
Message-ID: <61d660b7-17a9-4817-ba34-40a5c1674d28@BY2FFO11FD032.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:62.221.5.235;CTRY:GB;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(438002)(164054003)(51444003)(377454003)(479174003)(51704005)(199002)(189002)(24454002)(64706001)(83506001)(76176999)(54356999)(50986999)(20776003)(92566001)(4396001)(102836001)(64126003)(50466002)(74316001)(92726001)(65956001)(83072002)(33646001)(86362001)(76482001)(87936001)(79102001)(74662001)(575784001)(65806001)(47776003)(31696002)(46102001)(85852003)(74502001)(80022001)(19580405001)(21056001)(6806004)(23676002)(85306003)(1496007)(99396002)(81342001)(31966008)(107046002)(70736001)(44976005)(19580395003)(77982001)(83322001)(106466001)(81542001)(104016002)(95666004)(65826006)(2004002)(107986001);DIR:OUT;SFP:;SCL:1;SRVR:BY2FFO11HUB010;H:xir-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-62-221-5-235.ipspace.xilinx.com;A:1;MX:1;LANG:en;
X-OriginatorOrg: xilinx.onmicrosoft.com
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 0266491E90
Authentication-Results: spf=pass (sender IP is 62.221.5.235)
 smtp.mailfrom=michal.simek@xilinx.com; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/30/2014 07:15 AM, Olof Johansson wrote:
> Hi,
> 
> On Sun, Jun 29, 2014 at 1:50 PM, Andreas Färber <afaerber@suse.de> wrote:
>> This allows to boot the Adapteva Parallella board to serial console.
>>
>> Cc: Andreas Olofsson <andreas@adapteva.com>
>> Signed-off-by: Andreas Färber <afaerber@suse.de>
> 
> Nice and clean DTS, just a couple of comments below.
> 
>> diff --git a/arch/arm/boot/dts/zynq-parallella.dts b/arch/arm/boot/dts/zynq-parallella.dts
>> new file mode 100644
>> index 0000000..98df66c
>> --- /dev/null
>> +++ b/arch/arm/boot/dts/zynq-parallella.dts
>> @@ -0,0 +1,63 @@
>> +/*
>> + * Copyright (c) 2014 SUSE LINUX Products GmbH
>> + *
>> + * Derived from zynq-zed.dts:
>> + *
>> + *  Copyright (C) 2011 Xilinx
>> + *  Copyright (C) 2012 National Instruments Corp.
>> + *  Copyright (C) 2013 Xilinx
>> + *
>> + * This software is licensed under the terms of the GNU General Public
>> + * License version 2, as published by the Free Software Foundation, and
>> + * may be copied, distributed, and modified under those terms.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + */
>> +/dts-v1/;
>> +/include/ "zynq-7000.dtsi"
>> +
>> +/ {
>> +       model = "Parallella Board";
>> +       compatible = "xlnx,zynq-7000";
> 
> This should have a more specific compatible as the first one. Probably
> something like:
>    compatible = "adapteva,parallella", "xlnx,zynq-7000";

We were using these compatible properties but later there is no reason
to create them because they will be unused.
It is easy to add it when you need it which is not this case.

> 
>> +
>> +       memory {
>> +               device_type = "memory";
>> +               reg = <0 0x20000000>;
> 
> Does the bootloader update this entry, or is it truly static? If it's
> updated then it's become recent habit to leave the memory size empty
> in the static file.

Depends on your bootloader. I think it is good to have it here.
Also this file can be used by u-boot for example and u-boot can be configured
from it that's why I think that make sense to keep this here.


>> +       };
>> +
>> +       chosen {
>> +               bootargs = "console=ttyPS0,115200 earlyprintk root=/dev/mmcblk0p2 rootfstype=ext4 rw rootwait";
>> +       };
>> +};
> 
> A bit more torn on this one, I'm OK with it staying in even if
> firmware overrides for all practical purposes since it's good to keep
> around for reference w.r.t. console. Note that we're starting to move
> over to using /chosen/stdout-path, so you might want to add that now
> instead of later.

No problem from me too.

Thanks,
Michal



