Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755379AbaLWIWY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 03:22:24 -0500
Received: from mail-bn1on0141.outbound.protection.outlook.com ([157.56.110.141]:10092
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755189AbaLWIWW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 03:22:22 -0500
Message-ID: <5499273D.3040900@freescale.com>
Date: Tue, 23 Dec 2014 16:26:37 +0800
From: Liu Ying <Ying.Liu@freescale.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Stefan Wahren <stefan.wahren@i2se.com>, <dri-devel@lists.freedesktop.org>
CC: <kernel@pengutronix.de>, <linux@arm.linux.org.uk>,
        <linux-kernel@vger.kernel.org>, <thierry.reding@gmail.com>,
        <shawn.guo@linaro.org>, <airlied@linux.ie>, <andyshrk@gmail.com>,
        <p.zabel@pengutronix.de>, <mturquette@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>, <devicetree@vger.kernel.org>
Subject: Re: [PATCH RFC v3 02/18] of: Add vendor prefix for Himax Technologies
 Inc.
References: <1419306399-9387-1-git-send-email-Ying.Liu@freescale.com>
 <1419306399-9387-3-git-send-email-Ying.Liu@freescale.com>
 <789433791.920346.1419322152848.JavaMail.open-xchange@oxbaltgw08.schlund.de>
In-Reply-To: <789433791.920346.1419322152848.JavaMail.open-xchange@oxbaltgw08.schlund.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Ying.Liu@freescale.com; 
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(339900001)(199003)(164054003)(189002)(479174004)(24454002)(377454003)(51704005)(104016003)(77156002)(84676001)(106466001)(46102003)(107046002)(50466002)(64126003)(83506001)(23676002)(19580405001)(19580395003)(6806004)(80316001)(20776003)(47776003)(64706001)(97736003)(65956001)(62966003)(92566001)(54356999)(86362001)(50986999)(76176999)(65806001)(77096005)(68736005)(1720100001)(2950100001)(85426001)(87936001)(36756003)(87266999)(21056001)(31966008)(120916001)(4396001)(99396003)(33656002)(15975445007)(59896002)(105606002)(217873001);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR0301MB0627;H:tx30smr01.am.freescale.net;FPR:;SPF:Fail;MLV:sfv;PTR:ErrorRetry;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR0301MB0627;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BN1PR0301MB0627;
X-Forefront-PRVS: 04347F8039
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN1PR0301MB0627;
X-OriginatorOrg: freescale.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Dec 2014 08:22:19.1152
 (UTC)
X-MS-Exchange-CrossTenant-Id: 710a03f5-10f6-4d38-9ff4-a80b81da590d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=710a03f5-10f6-4d38-9ff4-a80b81da590d;Ip=[192.88.168.50]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN1PR0301MB0627
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stefan,

On 12/23/2014 04:09 PM, Stefan Wahren wrote:
> Hi Liu,
>
>> Liu Ying <Ying.Liu@freescale.com> hat am 23. Dezember 2014 um 04:46
>> geschrieben:
>>
>>
>> Signed-off-by: Liu Ying <Ying.Liu@freescale.com>
>> ---
>> v2->v3:
>> * None.
>>
>> v1->v2:
>> * None.
>>
>> Documentation/devicetree/bindings/vendor-prefixes.txt | 1 +
>> 1 file changed, 1 insertion(+)
>>
>> diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt
>> b/Documentation/devicetree/bindings/vendor-prefixes.txt
>> index 78efebb..3cee528 100644
>> --- a/Documentation/devicetree/bindings/vendor-prefixes.txt
>> +++ b/Documentation/devicetree/bindings/vendor-prefixes.txt
>> @@ -69,6 +69,7 @@ hannstar HannStar Display Corporation
>> haoyu Haoyu Microelectronic Co. Ltd.
>> hisilicon Hisilicon Limited.
>> hit Hitachi Ltd.
>> +himax Himax Technologies, Inc.
>
> please fix the ordering. himax comes before hisilicon.

Yes. I'll fix that.

Thanks,
Liu Ying

>
> Thanks
>
> Stefan
>
>> honeywell Honeywell
>> hp Hewlett Packard
>> i2se I2SE GmbH
>> --
>> 2.1.0
>>
>>
>> _______________________________________________
>> linux-arm-kernel mailing list
>> linux-arm-kernel@lists.infradead.org
>> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
