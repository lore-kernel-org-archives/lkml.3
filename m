Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756164AbaGVRC2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 13:02:28 -0400
Received: from mail-bn1lp0139.outbound.protection.outlook.com ([207.46.163.139]:2267
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756033AbaGVRCZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 13:02:25 -0400
Date: Tue, 22 Jul 2014 19:02:08 +0200
From: Michal Simek <michal.simek@xilinx.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>, Srikanth Thokala <sthokal@xilinx.com>
CC: Michal Simek <michal.simek@xilinx.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH v4] pcie: Add Xilinx PCIe Host Bridge IP driver
References: <1404361654-2894-1-git-send-email-sthokal@xilinx.com>
 <20140716173824.GA24357@google.com>
 <CA+mB=1JupzQy+R14kKAk7mTJR2FcZ+cQv-uXQSB6jEVBW95aGQ@mail.gmail.com>
 <CAErSpo41HwMferWm8q69Sz0t-Cs1WHgwwVp1VKsoxxyvrgQhfQ@mail.gmail.com>
In-Reply-To: <CAErSpo41HwMferWm8q69Sz0t-Cs1WHgwwVp1VKsoxxyvrgQhfQ@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-RCIS-Action: ALLOW
Message-ID: <dc252e61-3179-4f51-90e6-f92929e93d40@BN1AFFO11FD030.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:62.221.5.235;CTRY:GB;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(438002)(51704005)(199002)(189002)(377454003)(164054003)(479174003)(24454002)(65806001)(76482001)(81342001)(6806004)(64126003)(19580395003)(20776003)(47776003)(85306003)(107046002)(80022001)(77982001)(65956001)(70736001)(64706001)(74502001)(31966008)(46102001)(74662001)(21056001)(93886003)(83322001)(44976005)(79102001)(95666004)(106466001)(1496007)(19580405001)(81542001)(4396001)(86362001)(31696002)(85852003)(102836001)(83072002)(92566001)(92726001)(74316001)(50986999)(99396002)(54356999)(76176999)(50466002)(33646002)(87936001)(23676002)(104016003)(83506001)(65826006)(107986001);DIR:OUT;SFP:;SCL:1;SRVR:BN1AFFO11HUB008;H:xir-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-62-221-5-235.ipspace.xilinx.com;A:1;MX:1;LANG:en;
X-OriginatorOrg: xilinx.onmicrosoft.com
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 02801ACE41
Authentication-Results: spf=pass (sender IP is 62.221.5.235)
 smtp.mailfrom=michal.simek@xilinx.com; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/22/2014 06:08 PM, Bjorn Helgaas wrote:
> On Mon, Jul 21, 2014 at 11:10 PM, Srikanth Thokala <sthokal@xilinx.com> wrote:
>> On Wed, Jul 16, 2014 at 11:08 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>>> ...
>>> I see I forgot to ask for a MAINTAINERS entry for this driver.  Can
>>> you add one?
>>
>> There was a discussion on this earlier and Michal mentioned it is not
>> required as it is
>> handled by our Xilinx record.
>>
>> Here is the reply from Michal to the MAINTAINERS update comment,
>>
>> < Reply from Michal >
>>
>>> Please also include a MAINTAINERS update for drivers/pci/host/pci-xilinx.c.
>>
>> This should be handle by our record that's why MAINTAINERS update is
>> not necessary.
>> (N: xilinx below)
> 
> That's technically true in the sense that get_maintainer.pl will do
> the right thing, but I often review patches in email (without
> extracting them), so it's more convenient to just look in MAINTAINERS
> to see if they have the right acks.  But I guess I can deal with it
> either way.

There is also another reason for using just this fragment.
Because developers and their responsibilities are changing so often
and I just know who is responsible for it at that time.

Thanks,
Michal


