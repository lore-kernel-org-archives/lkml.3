Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753886AbbAPOps (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 09:45:48 -0500
Received: from mail-bn1bon0116.outbound.protection.outlook.com ([157.56.111.116]:4768
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751312AbbAPOpq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 09:45:46 -0500
X-WSS-ID: 0NI9YBY-08-UTE-02
X-M-MSG: 
Message-ID: <54B9240A.7060003@amd.com>
Date: Fri, 16 Jan 2015 08:45:30 -0600
From: Tom Lendacky <thomas.lendacky@amd.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Hanjun Guo <hanjun.guo@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Grant Likely <grant.likely@linaro.org>
CC: Mark Rutland <Mark.Rutland@arm.com>,
        linaro-acpi <linaro-acpi@lists.linaro.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "Yijing Wang" <wangyijing@huawei.com>, Rob Herring <robh@kernel.org>,
        "Lorenzo Pieralisi" <Lorenzo.Pieralisi@arm.com>,
        Timur Tabi <timur@codeaurora.org>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        Charles Garcia-Tobin <Charles.Garcia-Tobin@arm.com>,
        "phoenix.liyi@huawei.com" <phoenix.liyi@huawei.com>,
        Robert Richter <rric@kernel.org>, Jason Cooper <jason@lakedaemon.net>,
        Arnd Bergmann <arnd@arndb.de>, Marc Zyngier <Marc.Zyngier@arm.com>,
        "jcm@redhat.com" <jcm@redhat.com>, Mark Brown <broonie@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "graeme.gregory@linaro.org" <graeme.gregory@linaro.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        Sudeep Holla <Sudeep.Holla@arm.com>, "Olof Johansson" <olof@lixom.net>
Subject: Re: [PATCH v7 00/17] Introduce ACPI for ARM64 based on ACPI 5.1
References: <1421247905-3749-1-git-send-email-hanjun.guo@linaro.org>
 <CACxGe6v_BvCQqp8d=LaQ8HeaOU1Zh_HPpwFTdwOjHUbqXsnQ8g@mail.gmail.com>
 <20150115182346.GE2329@e104818-lin.cambridge.arm.com>
 <54B8BB24.2020408@linaro.org>
In-Reply-To: <54B8BB24.2020408@linaro.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
X-Originating-IP: [10.180.168.240]
Content-Transfer-Encoding: 8BIT
X-EOPAttributedMessage: 0
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Thomas.Lendacky@amd.com; 
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(24454002)(377454003)(164054003)(199003)(189002)(51704005)(479174004)(65956001)(2950100001)(93886004)(68736005)(77096005)(64706001)(47776003)(65806001)(33656002)(23676002)(77156002)(62966003)(101416001)(87266999)(15975445007)(86362001)(50986999)(92566002)(46102003)(87936001)(59896002)(97736003)(105586002)(83506001)(54356999)(1720100001)(19580395003)(65816999)(76176999)(50466002)(106466001)(80316001)(64126003)(19580405001)(36756003);DIR:OUT;SFP:1102;SCL:1;SRVR:CO1PR02MB207;H:atltwp02.amd.com;FPR:;SPF:None;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-DmarcAction-Test: None
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(3005004);SRVR:CO1PR02MB207;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:CO1PR02MB207;
X-Forefront-PRVS: 04583CED1A
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:CO1PR02MB207;
X-OriginatorOrg: amd4.onmicrosoft.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2015 14:45:37.9609
 (UTC)
X-MS-Exchange-CrossTenant-Id: fde4dada-be84-483f-92cc-e026cbee8e96
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=fde4dada-be84-483f-92cc-e026cbee8e96;Ip=[165.204.84.222]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR02MB207
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/16/2015 01:17 AM, Hanjun Guo wrote:
> On 2015年01月16日 02:23, Catalin Marinas wrote:
>> Hi Grant,
>>
>> On Thu, Jan 15, 2015 at 04:26:20PM +0000, Grant Likely wrote:
>>> On Wed, Jan 14, 2015 at 3:04 PM, Hanjun Guo <hanjun.guo@linaro.org>
>>> wrote:
>>>> This is the v7 of ACPI core patches for ARM64 based on ACPI 5.1
>>>
>>> I'll get right to the point: Can we please have this series queued up
>>> for v3.20?
>>
>> Before you even ask for this, please look at the patches and realise
>> that there is a complete lack of Reviewed-by tags on the code (well,
>> apart from trivial Kconfig changes). In addition, the series touches on
>> other subsystems like clocksource, irqchip, acpi and I don't see any
>> acks from the corresponding maintainers. So even if I wanted to merge
>
> For the ACPI part, Rafael already said that "Having looked at the
> patches recently, I don't see any major problems in them from the ACPI
> core perspective, so to me they are good to go." [1]
> Is that kind of ack for this ?
>
> Thanks
> Hanjun
>
> [1]:
> http://lkml.iu.edu/hypermail/linux/kernel/1409.1/03363.html
>

I have tested ACPI-enablement patches for the amd-xgbe/amd-xgbe-phy
drivers that I'm about to submit upstream with the V7 patch series
on the AMD Seattle server platform. There does not appear to be support
for the _CCA attribute in this patch series. The amd-xgbe driver will
setup the device domain and cache attributes based on the presence of
this attribute, but it requires the arch support to assign the proper
DMA operations in order for it to all work correctly.

Overriding the _CCA attribute in the driver, I was able to successfully
test the driver and this patch series.

Thanks,
Tom


> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
