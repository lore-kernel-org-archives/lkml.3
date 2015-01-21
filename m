Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752539AbbAUJMv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 04:12:51 -0500
Received: from mail-bl2on0121.outbound.protection.outlook.com ([65.55.169.121]:52304
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751974AbbAUJMp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 04:12:45 -0500
X-Greylist: delayed 906 seconds by postgrey-1.27 at vger.kernel.org; Wed, 21 Jan 2015 04:12:45 EST
Message-ID: <54BF69FC.9040607@freescale.com>
Date: Wed, 21 Jan 2015 10:57:32 +0200
From: Cristian Stoica <cristian.stoica@freescale.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Kim Phillips <kim.phillips@freescale.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
CC: Tudor Ambarus <tudor.ambarus@freescale.com>,
        <linux-crypto@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>, Marek Vasut <marex@denx.de>,
        Horia Geanta <horia.geanta@freescale.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] crypto: caam - don't emit ICV check failures to dmesg
References: <1414686811-6527-1-git-send-email-tudor.ambarus@freescale.com>
	<1414688107-8196-1-git-send-email-tudor.ambarus@freescale.com>
	<20141106151714.GE4544@gondor.apana.org.au>
	<20141204182245.f352ea22dc61ea6f65d85c62@freescale.com>
	<20141211193018.2465016d545334a76c0f4bab@freescale.com>
 <20150120124310.ba1dd7a6454f65255c1ed713@freescale.com>
In-Reply-To: <20150120124310.ba1dd7a6454f65255c1ed713@freescale.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=B18196@freescale.com; 
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(339900001)(24454002)(479174004)(189002)(377454003)(199003)(164054003)(85426001)(77156002)(68736005)(62966003)(77096005)(46102003)(87936001)(97736003)(64126003)(36756003)(59896002)(558084003)(106466001)(104016003)(19580405001)(80316001)(19580395003)(93886004)(105606002)(64706001)(47776003)(33656002)(65956001)(65806001)(6806004)(83506001)(54356999)(87266999)(65816999)(50986999)(76176999)(92566002)(2950100001)(50466002)(23746002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM2PR03MB400;H:tx30smr01.am.freescale.net;FPR:;SPF:Fail;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-DmarcAction-Test: None
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(3005004);SRVR:DM2PR03MB400;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:DM2PR03MB400;
X-Forefront-PRVS: 04631F8F77
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:DM2PR03MB400;
X-OriginatorOrg: freescale.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2015 08:57:36.7134
 (UTC)
X-MS-Exchange-CrossTenant-Id: 710a03f5-10f6-4d38-9ff4-a80b81da590d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=710a03f5-10f6-4d38-9ff4-a80b81da590d;Ip=[192.88.168.50]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM2PR03MB400
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kim,

On 01/20/2015 08:43 PM, Kim Phillips wrote:
> ICV check failures are part of normal operation;
> leave user notification up to the higher levels,
> as is done in s/w algorithm implementations.
> 

Tested on P4080DS.

Tested-by: Cristian Stoica <cristian.stoica@freescale.com>


Thanks,
Cristian S.
