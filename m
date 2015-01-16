Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756294AbbAPP7g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 10:59:36 -0500
Received: from mail-by2on0144.outbound.protection.outlook.com ([207.46.100.144]:19968
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751645AbbAPP7e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 10:59:34 -0500
X-WSS-ID: 0NIA11U-08-Y6R-02
X-M-MSG: 
Message-ID: <54B931D3.7040109@amd.com>
Date: Fri, 16 Jan 2015 09:44:19 -0600
From: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.10; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Al Stone <al.stone@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>,
        Al Stone <ahs3@redhat.com>
CC: linaro-acpi <linaro-acpi@lists.linaro.org>,
        Will Deacon <Will.Deacon@arm.com>, Yijing Wang <wangyijing@huawei.com>,
        Rob Herring <robh@kernel.org>, Timur Tabi <timur@codeaurora.org>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        "phoenix.liyi@huawei.com" <phoenix.liyi@huawei.com>,
        Robert Richter <rric@kernel.org>, Jason Cooper <jason@lakedaemon.net>,
        Arnd Bergmann <arnd@arndb.de>, Marc Zyngier <Marc.Zyngier@arm.com>,
        "jcm@redhat.com" <jcm@redhat.com>, Mark Brown <broonie@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Olof Johansson <olof@lixom.net>
Subject: Re: [Linaro-acpi] [PATCH v7 00/17] Introduce ACPI for ARM64 based
 on ACPI 5.1
References: <1421247905-3749-1-git-send-email-hanjun.guo@linaro.org>
 <CACxGe6v_BvCQqp8d=LaQ8HeaOU1Zh_HPpwFTdwOjHUbqXsnQ8g@mail.gmail.com>
 <20150115182346.GE2329@e104818-lin.cambridge.arm.com>
 <54B831C9.3060700@redhat.com>
 <20150116102035.GD13634@e104818-lin.cambridge.arm.com>
 <54B92B99.5000604@linaro.org>
In-Reply-To: <54B92B99.5000604@linaro.org>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.180.168.240]
X-EOPAttributedMessage: 0
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(199003)(164054003)(479174004)(51704005)(24454002)(189002)(377454003)(47776003)(76176999)(77096005)(83506001)(64126003)(65956001)(77156002)(19580405001)(50986999)(93886004)(87266999)(54356999)(65816999)(64706001)(65806001)(68736005)(15975445007)(87936001)(36756003)(92566002)(2950100001)(101416001)(59896002)(19580395003)(62966003)(46102003)(86362001)(97736003)(50466002)(105586002)(33656002)(23746002)(80316001)(106466001);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR02MB201;H:atltwp02.amd.com;FPR:;SPF:None;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-DmarcAction-Test: None
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(3005004);SRVR:BY2PR02MB201;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BY2PR02MB201;
X-Forefront-PRVS: 04583CED1A
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY2PR02MB201;
X-OriginatorOrg: amd4.onmicrosoft.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2015 15:44:22.7840
 (UTC)
X-MS-Exchange-CrossTenant-Id: fde4dada-be84-483f-92cc-e026cbee8e96
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=fde4dada-be84-483f-92cc-e026cbee8e96;Ip=[165.204.84.222]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY2PR02MB201
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 1/16/15 09:17, Al Stone wrote:
> On 01/16/2015 03:20 AM, Catalin Marinas wrote:
>> On Thu, Jan 15, 2015 at 09:31:53PM +0000, Al Stone wrote:
>>> On 01/15/2015 11:23 AM, Catalin Marinas wrote:
>>>> On Thu, Jan 15, 2015 at 04:26:20PM +0000, Grant Likely wrote:
>>>>> On Wed, Jan 14, 2015 at 3:04 PM, Hanjun Guo <hanjun.guo@linaro.org> wrote:
>>>>>> This is the v7 of ACPI core patches for ARM64 based on ACPI 5.1
>>>>>
>>>>> I'll get right to the point: Can we please have this series queued up
>>>>> for v3.20?
>>>> [snip ... ]
>>>
>>>>> 5. Platform support patches need verification and review
>>>>>     * ACPI core works on at least the Foundation model, Juno, APM
>>>>> Mustang, and AMD Seattle
>>>>>     * There still are driver patches being discussed. See Al's summary
>>>>> for details
>>>>>     * As I argued above, the state of driver patches isn't going to be
>>>>
>>>> We are still lacking here. To quote Al, "First version for AMD Seattle
>>>> has been posted to the public linaro-acpi mailing list for initial
>>>> review". Sorry but I don't follow linaro-acpi list. I don't know what's
>>>> in those patches and I can't tell which subsystems they touch, whether
>>>> maintainers agree with them. So in conclusion, I'm not confident the
>>>> arm64 hardware ACPI story looks that great yet.
>>>>
>>>
>>> This is solely my fault -- too much time on processes, email, and
>>> documentation, not enough time on the Seattle patches.  And not
>>> enough Seattles to go around for someone else to pick up the slack.
>>>
>>> I am aware not everyone is subscribed to linaro-acpi; we use that
>>> for internal review before posting more broadly, which is the only
>>> reason I sent them there.
>>>
>>> I'm in the middle of updating them as I have time, based on really
>>> good feedback from Arnd; few of them are terribly new (the very first
>>> posting was [0]) -- it's mostly a matter of rebasing, integrating
>>> updates from AMD and others, and reacting to the comments.  One can
>>> also see what these patches will probably look like via one of the
>>> Fedora kernel trees [1].
>>
>> Do you have some simple branch against mainline with just the ACPI core
>> patches and what's required for AMD Seattle? I have no plans to dig
>> through the Fedora kernels.
>>
>
> Nor was I expecting you to; I only added it as additional reference
> material, should one be interested.
>
> The version of patches sent to the linaro-acpi list are from the Linaro
> acpi.git tree, and are precisely what you describe; those are the ones
> being updated.
>

Catalin,

For Seattle, you could use the https://git.linaro.org/leg/acpi/acpi.git 
acpi-5.1-v7, and it would also need the AHCI ACPI patch here 
(https://lkml.org/lkml/2015/1/5/662).

Thanks,
Suravee
