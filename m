Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753404AbbAEKAp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 05:00:45 -0500
Received: from mail-by2on0144.outbound.protection.outlook.com ([207.46.100.144]:64431
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751121AbbAEKAn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 05:00:43 -0500
Message-ID: <54AA61D2.1040002@freescale.com>
Date: Mon, 5 Jan 2015 18:05:06 +0800
From: Liu Ying <Ying.Liu@freescale.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: <dri-devel@lists.freedesktop.org>, <stefan.wahren@i2se.com>,
        <devicetree@vger.kernel.org>, <linux@arm.linux.org.uk>,
        <kernel@pengutronix.de>, <linux-kernel@vger.kernel.org>,
        <a.hajda@samsung.com>, <mturquette@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>, <andyshrk@gmail.com>
Subject: Re: [PATCH RFC v7 16/21] drm: panel: Add support for Himax HX8369A
 MIPI DSI panel
References: <1419910451-15268-1-git-send-email-Ying.Liu@freescale.com>
 <1419910451-15268-17-git-send-email-Ying.Liu@freescale.com>
 <20150105085424.GP2711@phenom.ffwll.local>
In-Reply-To: <20150105085424.GP2711@phenom.ffwll.local>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Ying.Liu@freescale.com; 
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(339900001)(479174004)(189002)(51704005)(24454002)(377454003)(199003)(2201001)(50466002)(97736003)(65956001)(65806001)(4396001)(36756003)(23746002)(2950100001)(77156002)(62966003)(68736005)(77096005)(92566001)(99396003)(120916001)(84676001)(83506001)(19580405001)(80316001)(19580395003)(87266999)(54356999)(86362001)(6806004)(104016003)(87936001)(106466001)(105606002)(47776003)(64706001)(20776003)(107886001)(76176999)(50986999)(107046002)(65816999)(85426001)(46102003)(21056001)(31966008)(33656002)(921003)(1121003)(217873001);DIR:OUT;SFP:1102;SCL:1;SRVR:CY1PR0301MB0635;H:tx30smr01.am.freescale.net;FPR:;SPF:Fail;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-DmarcAction: None
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(3005003);SRVR:CY1PR0301MB0635;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:CY1PR0301MB0635;
X-Forefront-PRVS: 0447DB1C71
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB0635;
X-OriginatorOrg: freescale.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2015 10:00:40.0108
 (UTC)
X-MS-Exchange-CrossTenant-Id: 710a03f5-10f6-4d38-9ff4-a80b81da590d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=710a03f5-10f6-4d38-9ff4-a80b81da590d;Ip=[192.88.168.50]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY1PR0301MB0635
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

On 01/05/2015 04:54 PM, Daniel Vetter wrote:
> On Tue, Dec 30, 2014 at 11:34:06AM +0800, Liu Ying wrote:
>> This patch adds support for Himax HX8369A MIPI DSI panel.
>>
>> Reviewed-by: Andrzej Hajda <a.hajda@samsung.com>
>> Signed-off-by: Liu Ying <Ying.Liu@freescale.com>
>> ---
>> v6->v7:
>>   * Address Andrzej Hajda's following comments.
>>   * Simplify the return logic in hx8369a_dcs_write().
>>   * Replace the macro hx8369a_dsi_init_helper() with a function array to improve
>>     the code quality.
>>   * Handle error cases during getting gpios in probe().
>>   * Add 'Reviewed-by: Andrzej Hajda <a.hajda@samsung.com>'.
>
> If you only update one patch in a big series it's imo better to just
> resend that one to avoid spamming the mailing list with noise. Imo it also
> helps to keep the discussion all nicely grouped together.

Thanks for your suggestion.  I would try to make people happy about
the way the series is submitted for review.

>
> In any case please give a short overview of what changed in the cover
> letter when resending the entire series so that people don't have to go
> through all the invidual patches.

Yes, absolutely.  I gave short overviews of what changed in the very
beginning of the cover letters from v2 to v8 and I will do this in
every necessary follow-up version.

Regards,
Liu Ying

> -Daniel
>
