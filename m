Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754318AbaJVHg0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 03:36:26 -0400
Received: from mail-bn1on0079.outbound.protection.outlook.com ([157.56.110.79]:26640
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751100AbaJVHgZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 03:36:25 -0400
Date: Wed, 22 Oct 2014 09:36:15 +0200
From: Michal Simek <michal.simek@xilinx.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>, Michal Simek <michal.simek@xilinx.com>
CC: Soren Brinkmann <soren.brinkmann@xilinx.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] MAINTAINERS: Update Zynq maintainer record
References: <1413927103-31358-1-git-send-email-soren.brinkmann@xilinx.com>
	 <ba5ded105f25449a8ccd35f3109ff2de@BL2FFO11FD019.protection.gbl>
 <1413960882.18654.2.camel@perches.com>
In-Reply-To: <1413960882.18654.2.camel@perches.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-21042.001
X-TM-AS-User-Approved-Sender: Yes
Message-ID: <7f1a322b4d7b481ea8b316736fe6b24a@BL2FFO11FD025.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:62.221.5.235;CTRY:GB;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(24454002)(164054003)(199003)(377454003)(479174003)(377424004)(189002)(51704005)(19580395003)(102836001)(106466001)(31966008)(64126003)(107046002)(19580405001)(44976005)(4396001)(95666004)(6806004)(86362001)(16601075003)(64706001)(47776003)(20776003)(15975445006)(85852003)(83506001)(92566001)(87936001)(76176999)(54356999)(50986999)(15202345003)(21056001)(65806001)(65956001)(23746002)(587094004)(99396003)(76482002)(50466002)(46102003)(80022003)(74316001)(104016003)(85306004)(120916001)(108616004)(65826006)(107986001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2FFO11HUB043;H:xir-pvapsmtpgw01;FPR:;PTR:unknown-62-221-5-235.ipspace.xilinx.com;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BL2FFO11HUB043;
X-Forefront-PRVS: 037291602B
Authentication-Results: spf=pass (sender IP is 62.221.5.235)
 smtp.mailfrom=michal.simek@xilinx.com; 
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/22/2014 08:54 AM, Joe Perches wrote:
> On Wed, 2014-10-22 at 08:29 +0200, Michal Simek wrote:
>> On 10/21/2014 11:31 PM, Soren Brinkmann wrote:
>>>  - add myself as reviewer for Zynq
>>>  - add entry to cover Zynq clock drivers
>>>  - add entry to cover Xilinx DMA drivers
>>>
>>> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
>>> ---
>>>  MAINTAINERS | 3 +++
>>>  1 file changed, 3 insertions(+)
>>>
>>> diff --git a/MAINTAINERS b/MAINTAINERS
>>> index a20df9bf8ab0..07eecdddbe8b 100644
>>> --- a/MAINTAINERS
>>> +++ b/MAINTAINERS
>>> @@ -1543,6 +1543,7 @@ F:	arch/arm/mach-pxa/include/mach/z2.h
>>>  
>>>  ARM/ZYNQ ARCHITECTURE
>>>  M:	Michal Simek <michal.simek@xilinx.com>
>>> +R:	Sören Brinkmann <soren.brinkmann@xilinx.com>
>>
>> this is fine.
>>
>>>  L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
>>>  W:	http://wiki.xilinx.com
>>>  T:	git git://git.xilinx.com/linux-xlnx.git
>>> @@ -1552,7 +1553,9 @@ F:	drivers/cpuidle/cpuidle-zynq.c
>>>  F:	drivers/block/xsysace.c
>>>  N:	zynq
>>>  N:	xilinx
>>> +F:	drivers/clk/zynq/
>>
>> this is handled by N: zynq
>>
>>>  F:	drivers/clocksource/cadence_ttc_timer.c
>>> +F:	drivers/dma/xilinx/
>>
>> ditto.
> 
> F: specific paths are better than N: file names
> because get_maintainers doesn't add the patches
> submitters for N: entries.

I expect that you are referring to this description

        N: Files and directories with regex patterns.
           N:   [^a-z]tegra     all files whose path contains the word tegra
           One pattern per line.  Multiple N: lines acceptable.
           scripts/get_maintainer.pl has different behavior for files that
           match F: pattern and matches of N: patterns.  By default,
           get_maintainer will not look at git log history when an F: pattern
           match occurs.  When an N: match occurs, git log history is used
           to also notify the people that have git commit signatures.

The purpose of this patch was that Soren is aware about changes
around xilinx drivers not to sign dma drivers to me + CC him.

Also this fragment informing me that something is happening around these drivers
and also driver submitter is informed that's why using git log history is
at least for me preferred way.

Thanks,
Michal
