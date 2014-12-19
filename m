Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751986AbaLSCUv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 21:20:51 -0500
Received: from mail-bn1on0137.outbound.protection.outlook.com ([157.56.110.137]:1664
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751603AbaLSCUs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 21:20:48 -0500
Message-ID: <54938C81.6070304@freescale.com>
Date: Fri, 19 Dec 2014 10:25:05 +0800
From: Liu Ying <Ying.Liu@freescale.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Philipp Zabel <p.zabel@pengutronix.de>
CC: <dri-devel@lists.freedesktop.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux@arm.linux.org.uk>,
        <kernel@pengutronix.de>, <thierry.reding@gmail.com>,
        <shawn.guo@linaro.org>, <mturquette@linaro.org>, <airlied@linux.ie>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC v2 06/14] ARM: dts: imx6qdl: Move existing MIPI DSI
 ports into a new 'ports' node
References: <1418886696-11636-1-git-send-email-Ying.Liu@freescale.com>
	 <1418886696-11636-7-git-send-email-Ying.Liu@freescale.com>
 <1418898812.4212.11.camel@pengutronix.de>
In-Reply-To: <1418898812.4212.11.camel@pengutronix.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Ying.Liu@freescale.com; 
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(339900001)(51704005)(24454002)(189002)(377454003)(199003)(479174004)(46102003)(110136001)(107046002)(84676001)(4396001)(54356999)(106466001)(76176999)(104016003)(68736005)(99396003)(50466002)(77096005)(83506001)(97736003)(105606002)(120916001)(21056001)(86362001)(50986999)(65806001)(6806004)(19580405001)(47776003)(80316001)(19580395003)(65816999)(23676002)(87936001)(77156002)(64706001)(36756003)(99136001)(20776003)(33656002)(85426001)(62966003)(2950100001)(32563001)(217873001);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR0301MB0626;H:tx30smr01.am.freescale.net;FPR:;SPF:Fail;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR0301MB0626;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BN1PR0301MB0626;
X-Forefront-PRVS: 0430FA5CB7
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN1PR0301MB0626;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR0301MB0721;
X-OriginatorOrg: freescale.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2014 02:20:43.6194
 (UTC)
X-MS-Exchange-CrossTenant-Id: 710a03f5-10f6-4d38-9ff4-a80b81da590d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=710a03f5-10f6-4d38-9ff4-a80b81da590d;Ip=[192.88.168.50]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN1PR0301MB0721
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Philipp,

On 12/18/2014 06:33 PM, Philipp Zabel wrote:
> Am Donnerstag, den 18.12.2014, 15:11 +0800 schrieb Liu Ying:
>> The MIPI DSI node contains some ports which represent possible DRM CRTCs
>> it can connect with.  Each port has a 'reg' property embedded.  This
>> property will be wrongly interpretted by the MIPI DSI bus driver, because
>> the driver will take each subnode which contains a 'reg' property as a
>> DSI peripheral device.  This patch moves the existing MIPI DSI ports into
>> a new 'ports' node so that the MIPI DSI bus driver may distinguish its
>> DSI peripheral device(s) from the existing ports.
>>
>> Signed-off-by: Liu Ying <Ying.Liu@freescale.com>
>
> Acked-by: Philipp Zabel <p.zabel@pengutronix.de>

Thanks.  I'll add your ack for this one in the next version.

Regards,
Liu Ying

>
> regards
> Philipp
>
