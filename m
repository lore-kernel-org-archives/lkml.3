Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752133AbaJVNgw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 09:36:52 -0400
Received: from mail-bn1bon0093.outbound.protection.outlook.com ([157.56.111.93]:63740
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751004AbaJVNgv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 09:36:51 -0400
Date: Wed, 22 Oct 2014 15:22:16 +0200
From: Michal Simek <michal.simek@xilinx.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Olof Johansson <olof@lixom.net>,
        =?UTF-8?B?QW5kcmVhcyBGw6RyYmVy?= <afaerber@suse.de>
CC: =?UTF-8?B?U8O2cmVuIEJyaW5rbWFubg==?= <soren.brinkmann@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Andreas Olofsson <andreas@adapteva.com>,
        Matteo Vit <matteo.vit@starwaredesign.com>,
        Sean Rickerd <srickerd@suse.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Punnaiah Choudary Kalluri <punnaia@xilinx.com>,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: Re: [PATCH v2 00/11] ARM: dts: zynq: Prepare Parallella
References: <1406242820-20140-1-git-send-email-afaerber@suse.de>
	<CAOesGMjAb5oXjauhbqjDhJXWct7qoXxy3XpA1=DioK7vPTwetA@mail.gmail.com>
	<5446C775.3030707@suse.de>
	<CAOesGMhSuvbWpM5CC_5Hy6BskM6sbrw0SCR90aKHvfk1Qm1_Ng@mail.gmail.com>
	<5446CB2E.4080503@suse.de>
 <CAOesGMjQvkPyNQJ1cgxhBrw6ASwWK9jVAYkaraC1cwce9WEO=g@mail.gmail.com>
In-Reply-To: <CAOesGMjQvkPyNQJ1cgxhBrw6ASwWK9jVAYkaraC1cwce9WEO=g@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-21042.001
X-TM-AS-User-Approved-Sender: Yes
Message-ID: <184e81f64c364675bac53dfb10c52552@BN1AFFO11FD022.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:62.221.5.235;CTRY:GB;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(164054003)(24454002)(199003)(377454003)(479174003)(51704005)(189002)(64126003)(54356999)(76176999)(6806004)(107046002)(95666004)(31966008)(20776003)(64706001)(47776003)(19580405001)(44976005)(65806001)(65956001)(19580395003)(4396001)(21056001)(86362001)(85852003)(575784001)(87936001)(23676002)(50986999)(83506001)(85306004)(108616004)(80022003)(46102003)(99396003)(102836001)(106466001)(92566001)(33646002)(104016003)(120916001)(50466002)(76482002)(93886004)(74316001)(65826006)(107986001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1AFFO11HUB023;H:xir-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-62-221-5-235.ipspace.xilinx.com;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1AFFO11HUB023;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 037291602B
Authentication-Results: spf=pass (sender IP is 62.221.5.235)
 smtp.mailfrom=michal.simek@xilinx.com; 
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/21/2014 11:18 PM, Olof Johansson wrote:
> On Tue, Oct 21, 2014 at 2:07 PM, Andreas Färber <afaerber@suse.de> wrote:
>> Am 21.10.2014 um 23:01 schrieb Olof Johansson:
>>> On Tue, Oct 21, 2014 at 1:52 PM, Andreas Färber <afaerber@suse.de> wrote:
>>>> Am 18.10.2014 um 06:28 schrieb Olof Johansson:
>>>>> I did a test run with yesterday's -next It looks like networking isn't
>>>>> working there at the moment, clock related. Same happens with 3.17 and
>>>>> latest mainline, config multi_v7_defconfig:
>>>>>
>>>>> [WARN] [    7.943648] macb e000b000.ethernet eth0: unable to generate
>>>>> target frequency: 125000000 Hz
>>>>> [WARN] [   10.948681] macb e000b000.ethernet eth0: unable to generate
>>>>> target frequency: 125000000 Hz
>>>>
>>>> I am unable to reproduce this in my setup - at Linus' tip
>>>> c2661b806092d8ea2dccb7b02b65776555e0ee47 (v3.18-rc1-68-gc2661b8), make
>>>> oldconfig'ing my /proc/config.gz.
>>>>
>>>> Sören, in light of your explanations, should I be expecting problems
>>>> with 1GbE or with 100MbE? My board is connected to a 1GbE switch.
>>>
>>> My board might have old firmware/bitstream on it? It reports as:
>>>
>>> U-Boot 2012.10-00003-g792c31c (Jan 03 2014 - 12:24:08)
>>
>> Mine reports the same version.
>>
>> sha512sum of non-headless bitstream:
>> decb37222a7da0de39b1c1eb95714500cc006506cc86d85ed9c6c7b30c7cd7b91ef3592b886311f4285b5ce0079b4ffcd83f91ae275435ac15cefefe7db00b08
>>  /mnt/parallella.bit.bin
> 
> Mine is booting with whatever bitstream is flashed, and i'm not sure
> how to actually look at what that is.
> 
> 'fpga dump 0 0x10000000 0x1000000' doesn't do what I expect it to
> (target memory isn't modified).

Dumping bitstream is not supported in u-boot that's why it won't work.

I have tested the board I have here and no problem to run at 100 or 1000Mbit/s.

[  188.898563] macb e000b000.ethernet eth0: link down
[  192.898600] macb e000b000.ethernet eth0: link up (1000/Full)
[  708.898556] macb e000b000.ethernet eth0: link down
[  715.898696] macb e000b000.ethernet eth0: link up (100/Full)
[  749.909764] macb e000b000.ethernet eth0: link down
[  761.915769] macb e000b000.ethernet eth0: link up (1000/Full)

I will send you my boot.bin in private email which you can try.

Thanks,
Michal





