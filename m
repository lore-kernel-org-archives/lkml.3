Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932567AbaLBRxJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 12:53:09 -0500
Received: from mail-bn1on0090.outbound.protection.outlook.com ([157.56.110.90]:50273
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751916AbaLBRxH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 12:53:07 -0500
Message-ID: <547DFC30.304@opensource.altera.com>
Date: Tue, 2 Dec 2014 11:51:44 -0600
From: Thor Thayer <tthayer@opensource.altera.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Mark Rutland <mark.rutland@arm.com>
CC: "bp@alien8.de" <bp@alien8.de>,
        "dougthompson@xmission.com" <dougthompson@xmission.com>,
        "m.chehab@samsung.com" <m.chehab@samsung.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "dinguyen@opensource.altera.com" <dinguyen@opensource.altera.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "tthayer.linux@gmail.com" <tthayer.linux@gmail.com>
Subject: Re: [RESEND PATCHv5 5/5] arm: dts: Add Altera L2 Cache and OCRAM
 EDAC
References: <1415751263-1830-1-git-send-email-tthayer@opensource.altera.com> <1415751263-1830-6-git-send-email-tthayer@opensource.altera.com> <546BB27A.20405@opensource.altera.com> <547CD3ED.1080804@opensource.altera.com> <20141202150118.GM23671@leverpostej>
In-Reply-To: <20141202150118.GM23671@leverpostej>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: BN1PR02CA0029.namprd02.prod.outlook.com (10.141.56.29) To
 BLUPR03MB117.namprd03.prod.outlook.com (10.255.212.15)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BLUPR03MB117;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BLUPR03MB117;
X-Forefront-PRVS: 0413C9F1ED
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6049001)(6009001)(164054003)(189002)(377454003)(53754006)(479174003)(43784003)(199003)(24454002)(51704005)(31966008)(23746002)(110136001)(101416001)(21056001)(64126003)(50466002)(42186005)(33656002)(4396001)(102836001)(65956001)(47776003)(20776003)(64706001)(66066001)(83506001)(15975445006)(40100003)(50986999)(86362001)(65816999)(76176999)(54356999)(15202345003)(19580405001)(19580395003)(87976001)(92726001)(92566001)(19300405004)(68736005)(105586002)(95666004)(106356001)(107046002)(93886004)(122386002)(62966003)(120916001)(77156002)(46102003)(97736003)(99396003)(77096005)(562404015);DIR:OUT;SFP:1101;SCL:1;SRVR:BLUPR03MB117;H:[137.57.160.203];FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;MX:1;A:0;LANG:en;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BLUPR03MB117;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 12/02/2014 09:01 AM, Mark Rutland wrote:
> Hi Thor,
>
> On Mon, Dec 01, 2014 at 08:47:41PM +0000, Thor Thayer wrote:
>> Hi Boris,
>>
>> On 11/18/2014 02:56 PM, Thor Thayer wrote:
>>> Hi all,
>>>
>>> On 11/11/2014 06:14 PM, tthayer@opensource.altera.com wrote:
>>>> From: Thor Thayer<tthayer@opensource.altera.com>
>>>>
>>>> Adding the device tree entries and bindings needed to support
>>>> the Altera L2 cache and On-Chip RAM EDAC. This patch relies upon
>>>> an earlier patch to declare and setup On-chip RAM properly.
>>>> http://www.spinics.net/lists/devicetree/msg51117.html
>>>
>>> Any comments on these devicetree additions?
>>>
>>> Thanks,
>>> Thor
>>>> Signed-off-by: Thor Thayer<tthayer@opensource.altera.com>
>>>> ---
>>>> v2: Remove OCRAM declaration and reference prior patch.
>>>>
>>>> v3-5: No Change
>>>> ---
>>
>> I originally submitted this series on November 11, 2014.
>>
>> I haven't received any comments or ACKs on the device tree patch portion
>> (patch 5 of 5). According to
>> Documentation/devicetree/bindings/submitting-patches.txt, if the patch
>> hasn't been Acked after a couple of weeks, the maintainer can pull the
>> changes if they are comfortable with those changes.
>
> Apologies it has taken so long for this to be looked at. Unfortunately
> my inbox is overflowing (as are all of ours) and things fall by the
> wayside. I am sorry that this has lead to such a delayed response,
> especially given that it was negative.
>
> I'll try to keep up with this a bit more actively.
>
> Thanks,
> Mark.
>

Hi Mark,

Thank you for reviewing this. I have seen how busy the device tree ML is 
so I completely understand.

You have reviewed previous patch revisions in this series - thanks. I 
thought that I'd addressed most of the issues (in some cases by 
explaining my implementation) and since I hadn't heard anything, I 
assumed there weren't concerns.

Thanks again,

Thor
