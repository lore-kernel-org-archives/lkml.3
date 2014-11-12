Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934482AbaKLCCG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 21:02:06 -0500
Received: from mail-bn1on0146.outbound.protection.outlook.com ([157.56.110.146]:2656
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932917AbaKLCCE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 21:02:04 -0500
Message-ID: <5462BF8D.2090805@freescale.com>
Date: Tue, 11 Nov 2014 20:01:49 -0600
From: German Rivera <German.Rivera@freescale.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Alexander Graf <agraf@suse.de>, <gregkh@linuxfoundation.org>,
        <arnd@arndb.de>, <linux-kernel@vger.kernel.org>
CC: <stuart.yoder@freescale.com>, <Kim.Phillips@freescale.com>,
        <scottwood@freescale.com>, <bhamciu1@freescale.com>,
        <R89243@freescale.com>, <Geoff.Thorpe@freescale.com>,
        <bhupesh.sharma@freescale.com>, <nir.erez@freescale.com>,
        <richard.schmitt@freescale.com>
Subject: Re: [PATCH 2/3 v3] drivers/bus: Freescale Management Complex (fsl-mc)
 bus driver
References: <1412429015-30564-1-git-send-email-German.Rivera@freescale.com> <1412429015-30564-3-git-send-email-German.Rivera@freescale.com> <545B7C9A.8000309@suse.de>
In-Reply-To: <545B7C9A.8000309@suse.de>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.88.168.49]
X-ClientProxiedBy: BY2PR06CA046.namprd06.prod.outlook.com (10.141.250.164) To
 CY1PR0301MB1305.namprd03.prod.outlook.com (25.161.212.15)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB1305;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB1305;
X-Forefront-PRVS: 03932714EB
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(6049001)(6009001)(189002)(51704005)(377454003)(479174003)(199003)(24454002)(50466002)(46102003)(105586002)(20776003)(87976001)(65806001)(66066001)(65956001)(64126003)(95666004)(106356001)(47776003)(122386002)(64706001)(80316001)(36756003)(101416001)(42186005)(23746002)(76176999)(50986999)(87266999)(120916001)(54356999)(65816999)(99396003)(21056001)(4396001)(77096003)(97736003)(92726001)(62966003)(77156002)(86362001)(2201001)(107046002)(92566001)(102836001)(40100003)(33656002)(59896002)(31966008);DIR:OUT;SFP:1102;SCL:1;SRVR:CY1PR0301MB1305;H:[10.214.85.150];FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB1305;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06/2014 07:50 AM, Alexander Graf wrote:
>
[cut]
>> +++ b/drivers/bus/fsl-mc/Kconfig
>> @@ -0,0 +1,13 @@
>> +#
>> +# Freescale Management Complex (MC) bus drivers
>> +#
>> +# Copyright (C) 2014 Freescale Semiconductor, Inc.
>> +#
>> +# This file is released under the GPLv2
>> +#
>> +
>> +config FSL_MC_BUS
>> +	tristate "Freescale Management Complex (MC) bus driver"
>> +	help
>> +	  Driver to enable the bus infrastructure for the Freescale
>> +          QorIQ Management Complex.
>
> Isn't this missing some scope limitations? Should we really have the
> driver enabled on x86 for example?
>
I will add depends on OF && ARM64

> I would also make this slightly more verbose. People don't necessarily
> know what the QorIQ Management Complex is. Give people some idea what
> they're dealing with and preferably tell them hints that guide them from
> "SoC name" to "should I enable this option?".
>
> Also, usually the help text gives some guidance on what to do with the
> option if you're not sure. In this case, I would say advise the user to
> say N.
>
Will do.

>
> Alex
>
