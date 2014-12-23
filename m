Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754162AbaLWI71 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 03:59:27 -0500
Received: from mail-bn1on0147.outbound.protection.outlook.com ([157.56.110.147]:44192
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750740AbaLWI7Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 03:59:25 -0500
Message-ID: <54992FED.5080908@freescale.com>
Date: Tue, 23 Dec 2014 17:03:41 +0800
From: Liu Ying <Ying.Liu@freescale.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Stefan Wahren <stefan.wahren@i2se.com>, <dri-devel@lists.freedesktop.org>
CC: <kernel@pengutronix.de>, <linux@arm.linux.org.uk>,
        <linux-kernel@vger.kernel.org>, <thierry.reding@gmail.com>,
        <shawn.guo@linaro.org>, <airlied@linux.ie>, <andyshrk@gmail.com>,
        <p.zabel@pengutronix.de>, <mturquette@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>, <devicetree@vger.kernel.org>
Subject: Re: [PATCH RFC v3 11/18] drm/bridge: Add Synopsys DesignWare MIPI
 DSI host controller driver
References: <1419306399-9387-1-git-send-email-Ying.Liu@freescale.com>
 <1419306399-9387-12-git-send-email-Ying.Liu@freescale.com>
 <1770602566.921194.1419323596151.JavaMail.open-xchange@oxbaltgw08.schlund.de>
In-Reply-To: <1770602566.921194.1419323596151.JavaMail.open-xchange@oxbaltgw08.schlund.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Ying.Liu@freescale.com; 
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(339900001)(51704005)(24454002)(164054003)(377454003)(43544003)(189002)(479174004)(199003)(80316001)(76176999)(50986999)(99396003)(87936001)(65956001)(65806001)(23676002)(64126003)(31966008)(50466002)(6806004)(19580405001)(19580395003)(47776003)(85426001)(20776003)(64706001)(83506001)(84676001)(77156002)(105606002)(36756003)(120916001)(54356999)(62966003)(87266999)(4396001)(97736003)(59896002)(107046002)(106466001)(46102003)(104016003)(2950100001)(77096005)(33656002)(15975445007)(86362001)(68736005)(21056001)(92566001)(217873001);DIR:OUT;SFP:1102;SCL:1;SRVR:CY1PR0301MB0634;H:tx30smr01.am.freescale.net;FPR:;SPF:Fail;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB0634;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:CY1PR0301MB0634;
X-Forefront-PRVS: 04347F8039
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB0634;
X-OriginatorOrg: freescale.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Dec 2014 08:59:21.6738
 (UTC)
X-MS-Exchange-CrossTenant-Id: 710a03f5-10f6-4d38-9ff4-a80b81da590d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=710a03f5-10f6-4d38-9ff4-a80b81da590d;Ip=[192.88.168.50]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY1PR0301MB0634
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stefan,

On 12/23/2014 04:33 PM, Stefan Wahren wrote:
> Hi Liu,
>
>> Liu Ying <Ying.Liu@freescale.com> hat am 23. Dezember 2014 um 04:46
>> geschrieben:
>>
>>
>> This patch adds Synopsys DesignWare MIPI DSI host controller driver support.
>> Currently, the driver supports the burst with sync pulses mode only.
>>
>> Signed-off-by: Liu Ying <Ying.Liu@freescale.com>
>> ---
>> v2->v3:
>> * Newly introduced in v3 to address Andy Yan's comment. This is based on
>> the i.MX MIPI DSI driver in v2. To make the Synopsys DesignWare MIPI DSI
>> host controller driver less platform-dependant, this patch places it at
>> the drm/bridge directory as a DRM bridge driver.
>>
>> .../devicetree/bindings/drm/bridge/dw_mipi_dsi.txt | 72 ++
>
> please take care of [1] and send the Documentation part as a separate patch.
> This should also apply to all the other patches from your series.

All right, I'll do that.

Thanks,
Liu Ying

>
> Thanks
>
> Stefan
>
> [1] -
> http://lxr.free-electrons.com/source/Documentation/devicetree/bindings/submitting-patches.txt
>
