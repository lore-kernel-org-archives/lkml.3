Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932606AbaLAUtG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 15:49:06 -0500
Received: from mail-by2on0062.outbound.protection.outlook.com ([207.46.100.62]:23713
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932318AbaLAUtE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 15:49:04 -0500
Message-ID: <547CD3ED.1080804@opensource.altera.com>
Date: Mon, 1 Dec 2014 14:47:41 -0600
From: Thor Thayer <tthayer@opensource.altera.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: <bp@alien8.de>, <dougthompson@xmission.com>, <m.chehab@samsung.com>,
        <robh+dt@kernel.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <linux@arm.linux.org.uk>, <dinguyen@opensource.altera.com>,
        <grant.likely@linaro.org>
CC: <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-edac@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <tthayer.linux@gmail.com>
Subject: Re: [RESEND PATCHv5 5/5] arm: dts: Add Altera L2 Cache and OCRAM
 EDAC
References: <1415751263-1830-1-git-send-email-tthayer@opensource.altera.com> <1415751263-1830-6-git-send-email-tthayer@opensource.altera.com> <546BB27A.20405@opensource.altera.com>
In-Reply-To: <546BB27A.20405@opensource.altera.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: BLUPR05CA0057.namprd05.prod.outlook.com (10.141.20.27) To
 BY2PR03MB127.namprd03.prod.outlook.com (10.242.36.27)
X-Microsoft-Antispam: UriScan:;UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR03MB127;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY2PR03MB127;
X-Forefront-PRVS: 0412A98A59
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(6049001)(51704005)(189002)(199003)(377454003)(479174003)(53754006)(24454002)(164054003)(95666004)(23746002)(15975445006)(99396003)(40100003)(19580395003)(80316001)(120916001)(122386002)(97736003)(83506001)(107046002)(101416001)(106356001)(77096004)(68736005)(105586002)(87976001)(102836001)(86362001)(33656002)(15202345003)(46102003)(92566001)(2201001)(92726001)(42186005)(4396001)(31966008)(76176999)(54356999)(50986999)(65816999)(87266999)(21056001)(77156002)(64126003)(62966003)(19580405001)(47776003)(20776003)(65806001)(19300405004)(64706001)(66066001)(921003)(1121003)(562404015);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB127;H:[137.57.160.203];FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;MX:1;A:0;LANG:en;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY2PR03MB127;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR03MB074;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Boris,

On 11/18/2014 02:56 PM, Thor Thayer wrote:
> Hi all,
>
> On 11/11/2014 06:14 PM, tthayer@opensource.altera.com wrote:
>> From: Thor Thayer<tthayer@opensource.altera.com>
>>
>> Adding the device tree entries and bindings needed to support
>> the Altera L2 cache and On-Chip RAM EDAC. This patch relies upon
>> an earlier patch to declare and setup On-chip RAM properly.
>> http://www.spinics.net/lists/devicetree/msg51117.html
>
> Any comments on these devicetree additions?
>
> Thanks,
> Thor
>> Signed-off-by: Thor Thayer<tthayer@opensource.altera.com>
>> ---
>> v2: Remove OCRAM declaration and reference prior patch.
>>
>> v3-5: No Change
>> ---

I originally submitted this series on November 11, 2014.

I haven't received any comments or ACKs on the device tree patch portion 
(patch 5 of 5). According to 
Documentation/devicetree/bindings/submitting-patches.txt, if the patch 
hasn't been Acked after a couple of weeks, the maintainer can pull the 
changes if they are comfortable with those changes.

Dinh checked for merge conflicts in the DTS files in his November 7 
email (queued patches for 3.19).

Dinh acked patches 1 & 2 on November 12.

Thanks,

Thor

