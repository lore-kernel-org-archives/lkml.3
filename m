Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755237AbaJXIqB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 04:46:01 -0400
Received: from mail-bn1bon0083.outbound.protection.outlook.com ([157.56.111.83]:20160
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750964AbaJXIp6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 04:45:58 -0400
Date: Fri, 24 Oct 2014 10:45:43 +0200
From: Michal Simek <michal.simek@xilinx.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, <linux-arm-kernel@lists.infradead.org>
CC: Michal Simek <michal.simek@xilinx.com>,
        Soren Brinkmann <soren.brinkmann@xilinx.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] MAINTAINERS: Add myself as reviewer for Zynq
References: <1414081762-28886-1-git-send-email-soren.brinkmann@xilinx.com>
 <93a573b450ca429cad3ba42f875880d7@BL2FFO11FD051.protection.gbl>
 <1905062.WThGHQej1A@wuerfel>
In-Reply-To: <1905062.WThGHQej1A@wuerfel>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-21046.003
X-TM-AS-User-Approved-Sender: Yes
Message-ID: <2e0177fec3e14239ba979cbc5e924a73@BN1BFFO11FD026.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:62.221.5.235;CTRY:GB;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(51704005)(199003)(479174003)(377454003)(24454002)(189002)(120916001)(23746002)(46102003)(33646002)(92566001)(80022003)(74316001)(76482002)(108616004)(87936001)(85852003)(587094004)(21056001)(102836001)(16601075003)(95666004)(50466002)(15202345003)(86362001)(4396001)(107046002)(20776003)(47776003)(106466001)(31966008)(65806001)(65956001)(64706001)(104016003)(99396003)(19580405001)(19580395003)(6806004)(15975445006)(54356999)(44976005)(85306004)(83506001)(50986999)(76176999)(64126003)(65826006)(107986001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1BFFO11HUB008;H:xir-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-62-221-5-235.ipspace.xilinx.com;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1BFFO11HUB008;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 0374433C81
Authentication-Results: spf=pass (sender IP is 62.221.5.235)
 smtp.mailfrom=michal.simek@xilinx.com; 
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/24/2014 10:30 AM, Arnd Bergmann wrote:
> On Friday 24 October 2014 08:08:15 Michal Simek wrote:
>> On 10/23/2014 06:29 PM, Soren Brinkmann wrote:
>>> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
>>> ---
>>> v2:
>>>  - I removed the additional 'F' entries
>>>
>>>  MAINTAINERS | 1 +
>>>  1 file changed, 1 insertion(+)
>>>
>>> diff --git a/MAINTAINERS b/MAINTAINERS
>>> index 0484f2c526f0..8b49eeee5a27 100644
>>> --- a/MAINTAINERS
>>> +++ b/MAINTAINERS
>>> @@ -1543,6 +1543,7 @@ F:      arch/arm/mach-pxa/include/mach/z2.h
>>>  
>>>  ARM/ZYNQ ARCHITECTURE
>>>  M:   Michal Simek <michal.simek@xilinx.com>
>>> +R:   Sören Brinkmann <soren.brinkmann@xilinx.com>
>>>  L:   linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
>>>  W:   http://wiki.xilinx.com
>>>  T:   git git://git.xilinx.com/linux-xlnx.git
>>>
>>
>> Applied.
>> IMHO: This can go through arm-soc tree.
> 
> Yes, a simple patch like this, you can forward to use with your
> Signed-off-by, or add an Ack and ask us to pick it up directly.
> 
> With the current timing, I can still pick it up as a fix for 3.18 if you
> like.
> 

Ok here is my
Acked-by: Michal Simek <michal.simek@xilinx.com>

and please pick it up as fix directly to 3.18.

Thanks a lot,
Michal
