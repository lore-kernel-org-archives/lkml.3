Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753366AbaKZSgE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 13:36:04 -0500
Received: from mail-bn1on0133.outbound.protection.outlook.com ([157.56.110.133]:36381
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751183AbaKZSgB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 13:36:01 -0500
Message-ID: <54761D85.7080500@freescale.com>
Date: Wed, 26 Nov 2014 12:35:49 -0600
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
Subject: Re: [PATCH 1/3 v4] drivers/bus: Added Freescale Management Complex
 APIs
References: <1415901246-24131-1-git-send-email-German.Rivera@freescale.com> <1415901246-24131-2-git-send-email-German.Rivera@freescale.com> <5475A85E.1080204@suse.de>
In-Reply-To: <5475A85E.1080204@suse.de>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.88.168.50]
X-ClientProxiedBy: BN1PR02CA0050.namprd02.prod.outlook.com (10.141.56.50) To
 BY1PR0301MB1303.namprd03.prod.outlook.com (25.161.206.152)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY1PR0301MB1303;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY1PR0301MB1303;
X-Forefront-PRVS: 04073E895A
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(6009001)(6049001)(24454002)(51704005)(377454003)(479174003)(189002)(164054003)(199003)(40100003)(87266999)(122386002)(54356999)(64706001)(66066001)(20776003)(65806001)(65956001)(107046002)(47776003)(76176999)(50986999)(19580395003)(105586002)(65816999)(99136001)(46102003)(106356001)(80316001)(19580405001)(95666004)(21056001)(23746002)(77156002)(83506001)(62966003)(77096003)(4396001)(42186005)(31966008)(97736003)(101416001)(50466002)(102836001)(99396003)(92566001)(86362001)(33656002)(2201001)(59896002)(87976001)(92726001)(120916001)(36756003);DIR:OUT;SFP:1102;SCL:1;SRVR:BY1PR0301MB1303;H:[10.81.33.65];FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY1PR0301MB1303;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26/2014 04:15 AM, Alexander Graf wrote:
>
>
> On 13.11.14 18:54, J. German Rivera wrote:
>> APIs to access the Management Complex (MC) hardware
>> module of Freescale LS2 SoCs. This patch includes
>> APIs to check the MC firmware version and to manipulate
>> DPRC objects in the MC.
>>
>> Signed-off-by: J. German Rivera <German.Rivera@freescale.com>
>> Signed-off-by: Stuart Yoder <stuart.yoder@freescale.com>
>
> [...]
>
[]
>> +
>> +int dprc_get_container_id(struct fsl_mc_io *mc_io, int *container_id)
>
> This one is definitely a misnomer. It's a command that operates on the
> MC object, not a DPRC object. Also it doesn't fetch a random
> "container_id", it fetches the root container id.
>
> Please move it and its definition to the files that operate on the MC
> management interface.
>
Ok, I will make this change in respin v5.

Thanks,

German
>
> Alex
>
