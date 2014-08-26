Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753299AbaHZScQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 14:32:16 -0400
Received: from mail-by2lp0241.outbound.protection.outlook.com ([207.46.163.241]:27942
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752086AbaHZScN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 14:32:13 -0400
Message-ID: <53FCD456.3050404@opensource.altera.com>
Date: Tue, 26 Aug 2014 13:39:18 -0500
From: Thor Thayer <tthayer@opensource.altera.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Pavel Machek <pavel@denx.de>
CC: <robherring2@gmail.com>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <rob@landley.net>, <linux@arm.linux.org.uk>,
        <atull@opensource.altera.com>, <delicious.quinoa@gmail.com>,
        <dinguyen@opensource.altera.com>, <dougthompson@xmission.com>,
        <grant.likely@linaro.org>, <bp@alien8.de>, <sameo@linux.intel.com>,
        <lee.jones@linaro.org>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <tthayer.linux@gmail.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-edac@vger.kernel.org>
Subject: Re: [PATCHv10 2/2] arm: dts: Add Altera SDRAM EDAC bindings & devicetree
 entries.
References: <1407770293-27190-1-git-send-email-tthayer@opensource.altera.com> <1407770293-27190-3-git-send-email-tthayer@opensource.altera.com> <20140814184949.GC11558@amd.pavel.ucw.cz>
In-Reply-To: <20140814184949.GC11558@amd.pavel.ucw.cz>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: CO1PR06CA041.namprd06.prod.outlook.com (10.242.160.31) To
 BL2PR03MB113.namprd03.prod.outlook.com (10.255.230.12)
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 03152A99FF
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(6009001)(6049001)(377454003)(479174003)(53754006)(51704005)(199003)(189002)(51914003)(377424004)(24454002)(106356001)(65806001)(77982001)(64126003)(86362001)(66066001)(83322001)(4396001)(83072002)(110136001)(47776003)(80316001)(23746002)(65956001)(19580395003)(81342001)(107046002)(65816999)(46102001)(19580405001)(81542001)(80022001)(64706001)(87266999)(20776003)(99396002)(76176999)(87976001)(101416001)(54356999)(105586002)(50986999)(95666004)(83506001)(76482001)(74502001)(21056001)(77096002)(74662001)(79102001)(85306004)(31966008)(33656002)(85852003)(42186005)(102836001)(92726001)(59896002)(92566001)(50466002)(90102001)(217873001);DIR:OUT;SFP:;SCL:1;SRVR:BL2PR03MB113;H:[137.57.160.203];FPR:;MLV:sfv;PTR:InfoNoRecords;A:0;MX:1;LANG:en;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 08/14/2014 01:49 PM, Pavel Machek wrote:
> On Mon 2014-08-11 10:18:13, tthayer@opensource.altera.com wrote:
>> From: Thor Thayer <tthayer@opensource.altera.com>
>>
>> Add the Altera SDRAM EDAC bindings and device tree changes to the Altera SoC project.
>>
>> Signed-off-by: Thor Thayer <tthayer@opensource.altera.com>
> Acked-by: Pavel Machek <pavel@denx.de>
>
>
Hi All,

Any further comments or suggestions on this patch series? Thanks for the 
review, Pavel!

Thor
