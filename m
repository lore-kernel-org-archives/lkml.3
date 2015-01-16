Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755281AbbAPR1k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 12:27:40 -0500
Received: from mail-bn1bn0103.outbound.protection.outlook.com ([157.56.110.103]:61920
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752126AbbAPR1i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 12:27:38 -0500
X-Greylist: delayed 7873 seconds by postgrey-1.27 at vger.kernel.org; Fri, 16 Jan 2015 12:27:38 EST
X-WSS-ID: 0NIA54Q-07-PF7-02
X-M-MSG: 
Message-ID: <54B94674.10206@amd.com>
Date: Fri, 16 Jan 2015 11:12:20 -0600
From: Tom Lendacky <thomas.lendacky@amd.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Mark Rutland <Mark.Rutland@arm.com>,
        linaro-acpi <linaro-acpi@lists.linaro.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Yijing Wang <wangyijing@huawei.com>, Rob Herring <robh@kernel.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Timur Tabi <timur@codeaurora.org>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Charles Garcia-Tobin <Charles.Garcia-Tobin@arm.com>,
        "phoenix.liyi@huawei.com" <phoenix.liyi@huawei.com>,
        Robert Richter <rric@kernel.org>, Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <Marc.Zyngier@arm.com>, "jcm@redhat.com" <jcm@redhat.com>,
        Mark Brown <broonie@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        "graeme.gregory@linaro.org" <graeme.gregory@linaro.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "hanjun.guo@linaro.org" <hanjun.guo@linaro.org>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        Sudeep Holla <Sudeep.Holla@arm.com>, "Olof Johansson" <olof@lixom.net>
Subject: Re: [PATCH v7 00/17] Introduce ACPI for ARM64 based on ACPI 5.1
References: <1421247905-3749-1-git-send-email-hanjun.guo@linaro.org>
 <2198633.UpIyI82Yon@wuerfel> <20150116153320.GU7091@arm.com>
 <1809831.d9GPSfLUEN@wuerfel> <20150116154913.GW7091@arm.com>
In-Reply-To: <20150116154913.GW7091@arm.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.180.168.240]
X-EOPAttributedMessage: 0
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Thomas.Lendacky@amd.com; 
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(24454002)(377454003)(55674003)(479174004)(51704005)(199003)(189002)(50466002)(2950100001)(561944003)(77096005)(105586002)(36756003)(23746002)(68736005)(64126003)(106466001)(86362001)(92566002)(50986999)(65816999)(93886004)(83506001)(76176999)(54356999)(33656002)(65806001)(47776003)(62966003)(46102003)(64706001)(101416001)(65956001)(97736003)(87936001)(77156002);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR02MB200;H:atltwp01.amd.com;FPR:;SPF:None;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-DmarcAction-Test: None
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(3005004);SRVR:BN1PR02MB200;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BN1PR02MB200;
X-Forefront-PRVS: 04583CED1A
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN1PR02MB200;
X-OriginatorOrg: amd4.onmicrosoft.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2015 17:12:28.6508
 (UTC)
X-MS-Exchange-CrossTenant-Id: fde4dada-be84-483f-92cc-e026cbee8e96
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=fde4dada-be84-483f-92cc-e026cbee8e96;Ip=[165.204.84.221]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN1PR02MB200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/16/2015 09:49 AM, Will Deacon wrote:
> On Fri, Jan 16, 2015 at 03:40:28PM +0000, Arnd Bergmann wrote:
>> On Friday 16 January 2015 15:33:20 Will Deacon wrote:
>>> On Fri, Jan 16, 2015 at 03:14:13PM +0000, Arnd Bergmann wrote:
>>>> On Friday 16 January 2015 14:55:45 Will Deacon wrote:
>>>>> On Fri, Jan 16, 2015 at 02:45:30PM +0000, Tom Lendacky wrote:
>>>>>> I have tested ACPI-enablement patches for the amd-xgbe/amd-xgbe-phy
>>>>>> drivers that I'm about to submit upstream with the V7 patch series
>>>>>> on the AMD Seattle server platform. There does not appear to be support
>>>>>> for the _CCA attribute in this patch series. The amd-xgbe driver will
>>>>>> setup the device domain and cache attributes based on the presence of
>>>>>> this attribute, but it requires the arch support to assign the proper
>>>>>> DMA operations in order for it to all work correctly.
>>>>>>
>>>>>> Overriding the _CCA attribute in the driver, I was able to successfully
>>>>>> test the driver and this patch series.
>>>>>
>>>>> Hopefully this will all be addressed when the IORT parts of ACPI have
>>>>> settled down (the current proposal allows for these attributes to be
>>>>> described as well as their interaction with things like IOMMUs).
>>>>>
>>>>> In the meantime, are you falling back to non-coherent DMA? If so, what
>>>>> attributes have you settled on? We need to be really careful not to
>>>>> corrupt data during cache invalidatation when mapping a non-coherent
>>>>> buffer for the CPU.
>>>>
>>>> I think in case of ACPI we should use cache-coherent as the default,
>>>> as this is what all servers will use for DMA masters.
>>>
>>> I don't agree. The dma-coherent we have for device-tree isn't nearly
>>> expressive enough for the kind of things we want to describe and there's
>>> no reason to make the same mistake in ACPI, especially as it *is* being
>>> addressed by IORT. If we run with _CCA, then we're going to be stuck
>>> supporting something that isn't fit for purpose and which will likely be
>>> abused to describe both fixed features of the system and software
>>> configuration preferences. It also opens up a can of worms if we have to
>>> support a mixture of _CCA and IORT in the future.
>>>
>>> Or are you suggesting that we ignore _CCA and just assume cache-coherency?
>>> In that case, how do we support systems that aren't cache coherent, where
>>> not being cache coherent includes devices that require either device or
>>> IOMMU configuration to enable cacheable transactions?
>>
>> I was thinking we'd ignore _CCA because as you say a simple on/off flag
>> would not be enough to describe what we have to do for noncoherent
>> devices. I can't think of any reason why a server hardware would include
>> noncoherent devices, so if they are configurable they should be configured
>> into coherent mode by the firmware.
>
> The on-board ethernet on Seattle requires the driver to program its AXI
> attributes, so configuring it to be a coherent master actually means
> "program the same cacheable AXI settings as you have on the CPU". That
> sounds like Linux should be doing it to me, but even if the firmware takes
> a guess at "normal cacheable WBRWA", it's not clear to me whether that
> register persists across things like adapter reset.
>
> Tom?

The registers that contain the AxDOMAIN and AxCACHE settings do not
persist across an adapter reset.

Tom

>
> There's also the situation where the firmware hasn't initialised the
> register and Linux realises this during probe. What should it do then?
>
> Will
>
