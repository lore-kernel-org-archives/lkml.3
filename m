Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753438AbbALNvF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 08:51:05 -0500
Received: from mail-bn1bon0080.outbound.protection.outlook.com ([157.56.111.80]:19584
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753227AbbALNvA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 08:51:00 -0500
Date: Mon, 12 Jan 2015 14:50:27 +0100
From: Michal Simek <michal.simek@xilinx.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Pavel Machek <pavel@denx.de>, Konrad Zapalowicz <bergo.torino@gmail.com>
CC: atull <atull@opensource.altera.com>, <gregkh@linuxfoundation.org>,
        <jgunthorpe@obsidianresearch.com>, <hpa@zytor.com>, <monstr@monstr.eu>,
        <michal.simek@xilinx.com>, <rdunlap@infradead.org>,
        <mark.rutland@arm.com>, <linux-doc@vger.kernel.org>,
        <rubini@gnudd.com>, <pantelis.antoniou@konsulko.com>,
        <s.trumtrar@pengutronix.de>, <devel@driverdev.osuosl.org>,
        <sameo@linux.intel.com>, <nico@linaro.org>,
        <ijc+devicetree@hellion.org.uk>, <kyle.teske@ni.com>,
        <grant.likely@linaro.org>, <davidb@codeaurora.org>,
        <linus.walleij@linaro.org>, <cesarb@cesarb.net>,
        <devicetree@vger.kernel.org>, <jason@lakedaemon.net>,
        <pawel.moll@arm.com>, <iws@ovro.caltech.edu>, <broonie@kernel.org>,
        <philip@balister.org>, <dinguyen@opensource.altera.com>,
        <yvanderv@opensource.altera.com>, <linux-kernel@vger.kernel.org>,
        <balbi@ti.com>, <delicious.quinoa@gmail.com>, <robh+dt@kernel.org>,
        <rob@landley.net>, <galak@codeaurora.org>, <akpm@linux-foundation.org>,
        <davem@davemloft.net>, <m.chehab@samsung.com>
Subject: Re: [PATCH v8 0/4] FPGA Manager Framework
References: <1420575219-27061-1-git-send-email-atull@opensource.altera.com>
 <20150110181120.GA26067@t400> <alpine.DEB.2.10.1501111004580.2556@shineypoop>
 <20150111162426.GC26067@t400> <20150111195219.GA25760@amd>
 <20150111205800.GD26067@t400> <20150111213146.GA16524@amd>
In-Reply-To: <20150111213146.GA16524@amd>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-21242.006
X-TM-AS-User-Approved-Sender: Yes
Message-ID: <2ea77cba43724d5ab5aff54cec9fae98@BL2FFO11FD043.protection.gbl>
X-EOPAttributedMessage: 0
Authentication-Results: spf=pass (sender IP is 62.221.5.235)
 smtp.mailfrom=michal.simek@xilinx.com; 
X-Forefront-Antispam-Report: CIP:62.221.5.235;CTRY:GB;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(479174004)(51704005)(164054003)(377424004)(189002)(24454002)(199003)(377454003)(47776003)(62966003)(77096005)(106466001)(46102003)(87936001)(92566002)(92726002)(64706001)(77156002)(2950100001)(104016003)(108616004)(93886004)(76176999)(50466002)(23746002)(86362001)(64126003)(54356999)(83506001)(74316001)(19580395003)(50986999)(6806004)(65956001)(65806001)(19580405001)(65826006)(107986001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2FFO11HUB052;H:xir-pvapsmtpgw01;FPR:;SPF:Pass;MLV:sfv;PTR:unknown-62-221-5-235.ipspace.xilinx.com;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BL2FFO11HUB052;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:(601004);SRVR:BL2FFO11HUB052;
X-Forefront-PRVS: 0454444834
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:BL2FFO11HUB052;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2015 13:50:58.2552
 (UTC)
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[62.221.5.235]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL2FFO11HUB052
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/11/2015 10:31 PM, Pavel Machek wrote:
> On Sun 2015-01-11 21:58:00, Konrad Zapalowicz wrote:
>> On 01/11, Pavel Machek wrote:
>>> On Sun 2015-01-11 17:24:26, Konrad Zapalowicz wrote:
>>>> On 01/11, atull wrote:
>>>>> On Sat, 10 Jan 2015, Konrad Zapalowicz wrote:
>>>>>
>>>>>> On 01/06, atull@opensource.altera.com wrote:
>>>>>>> From: Alan Tull <atull@opensource.altera.com>
>>>>>>
>>>>>> Alan, there is something wrong with your email client configuration
>>>>>> and you need to fix.
>>>>>>
>>>>>> thanks,
>>>>>> konrad
>>>>>
>>>>> Hi Konrad,
>>>>>
>>>>> Can you be more specific?  What problem are you seeing?  Is it a problem 
>>>>> with the original patch  post or when I reply?  When I a post, I'm using
>>>>> 'git send-email' with sendmail and when I am replying, I am using alpine.
>>>>
>>>> I think that because you email client configuration sets the 'From'
>>>> header to "atull@..." and at the same time you sign-off messages with
>>>> "Alan Tull atull@..." the "From" is added at the beginning of the
>>>> message to indicate the original author.
>>>>
>>>> This should be fixed as the "from" is not welcomed in the body of the
>>>> commit message.
>>>
>>> Actually, why not? Tools should know to look at From: in the
>>> commit. AFAICT, Alan has it set up correctly.
>>
>> I think he has not. I suspect that the sendmail configuration in the git
>> config might be wrong. The 'from' must contain the same data as the git
>> is configured for the user.name and user.email options. Otherwise the
>> send-email is adding the "From: ..." to the message body.
> 
> And what is the problem with From: in the message body? Tools should
> handle that ok.

Konrad: Problem is probably just on your end. I have also no problem to handle
these patches.
Alan: From my point of view you don't need to change anything.

Thanks,
Michal


