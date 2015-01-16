Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754640AbbAPPbb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 10:31:31 -0500
Received: from mail-bn1bn0109.outbound.protection.outlook.com ([157.56.110.109]:45179
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752376AbbAPPb3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 10:31:29 -0500
X-WSS-ID: 0NI9ZQZ-07-I1P-02
X-M-MSG: 
Message-ID: <54B92B36.6080700@amd.com>
Date: Fri, 16 Jan 2015 09:16:06 -0600
From: Tom Lendacky <thomas.lendacky@amd.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>
CC: "hanjun.guo@linaro.org" <hanjun.guo@linaro.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Mark Rutland <Mark.Rutland@arm.com>,
        linaro-acpi <linaro-acpi@lists.linaro.org>,
        Yijing Wang <wangyijing@huawei.com>, "Rob Herring" <robh@kernel.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
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
 <54B8BB24.2020408@linaro.org> <54B9240A.7060003@amd.com>
 <20150116145545.GR7091@arm.com>
In-Reply-To: <20150116145545.GR7091@arm.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.180.168.240]
X-EOPAttributedMessage: 0
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Thomas.Lendacky@amd.com; 
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(24454002)(479174004)(55674003)(377454003)(199003)(189002)(51704005)(92566002)(59896002)(62966003)(36756003)(110136001)(106466001)(105586002)(93886004)(2950100001)(86362001)(77156002)(68736005)(46102003)(50466002)(77096005)(23746002)(64126003)(83506001)(561944003)(87266999)(101416001)(50986999)(76176999)(97736003)(54356999)(80316001)(87936001)(64706001)(65816999)(33656002)(65956001)(65806001)(47776003);DIR:OUT;SFP:1102;SCL:1;SRVR:CO1PR02MB206;H:atltwp01.amd.com;FPR:;SPF:None;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-DmarcAction-Test: None
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(3005004);SRVR:CO1PR02MB206;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:CO1PR02MB206;
X-Forefront-PRVS: 04583CED1A
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:CO1PR02MB206;
X-OriginatorOrg: amd4.onmicrosoft.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2015 15:16:14.3766
 (UTC)
X-MS-Exchange-CrossTenant-Id: fde4dada-be84-483f-92cc-e026cbee8e96
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=fde4dada-be84-483f-92cc-e026cbee8e96;Ip=[165.204.84.221]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR02MB206
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Will,

On 01/16/2015 08:55 AM, Will Deacon wrote:
> Hi Tom,
>
> On Fri, Jan 16, 2015 at 02:45:30PM +0000, Tom Lendacky wrote:
>> I have tested ACPI-enablement patches for the amd-xgbe/amd-xgbe-phy
>> drivers that I'm about to submit upstream with the V7 patch series
>> on the AMD Seattle server platform. There does not appear to be support
>> for the _CCA attribute in this patch series. The amd-xgbe driver will
>> setup the device domain and cache attributes based on the presence of
>> this attribute, but it requires the arch support to assign the proper
>> DMA operations in order for it to all work correctly.
>>
>> Overriding the _CCA attribute in the driver, I was able to successfully
>> test the driver and this patch series.
>
> Hopefully this will all be addressed when the IORT parts of ACPI have
> settled down (the current proposal allows for these attributes to be
> described as well as their interaction with things like IOMMUs).
>
> In the meantime, are you falling back to non-coherent DMA? If so, what
> attributes have you settled on? We need to be really careful not to
> corrupt data during cache invalidatation when mapping a non-coherent
> buffer for the CPU.
>

The override I used in the driver was to set the device to use AxDOMAIN
of 3 and AxCACHE of 0 so that the caches are not accessed.

Tom

> Will
>
