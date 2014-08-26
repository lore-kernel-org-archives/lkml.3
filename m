Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753244AbaHZSrf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 14:47:35 -0400
Received: from [207.46.163.182] ([207.46.163.182]:2263 "EHLO
	na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753070AbaHZSrd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 14:47:33 -0400
Message-ID: <53FCD41F.2060203@opensource.altera.com>
Date: Tue, 26 Aug 2014 13:38:23 -0500
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
Subject: Re: [PATCHv10 1/2] edac: altera: Add Altera SDRAM EDAC support.
References: <1407770293-27190-1-git-send-email-tthayer@opensource.altera.com> <1407770293-27190-2-git-send-email-tthayer@opensource.altera.com> <20140814184930.GB11558@amd.pavel.ucw.cz>
In-Reply-To: <20140814184930.GB11558@amd.pavel.ucw.cz>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: CO1PR06CA054.namprd06.prod.outlook.com (10.242.160.44) To
 BL2PR03MB114.namprd03.prod.outlook.com (10.255.230.14)
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 03152A99FF
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(6049001)(6009001)(199003)(24454002)(189002)(52604005)(51704005)(479174003)(377424004)(377454003)(53754006)(19580395003)(77096002)(74502001)(80316001)(50466002)(107046002)(23746002)(81542001)(74662001)(83322001)(99396002)(95666004)(105586002)(54356999)(110136001)(19580405001)(76176999)(83506001)(50986999)(87266999)(106356001)(64126003)(65806001)(42186005)(31966008)(65816999)(59896002)(79102001)(102836001)(81342001)(101416001)(85306004)(87976001)(76482001)(65956001)(66066001)(33656002)(92566001)(90102001)(86362001)(77982001)(83072002)(64706001)(92726001)(4396001)(21056001)(85852003)(80022001)(47776003)(20776003)(46102001)(217873001);DIR:OUT;SFP:;SCL:1;SRVR:BL2PR03MB114;H:[137.57.160.203];FPR:;MLV:sfv;PTR:InfoNoRecords;A:0;MX:1;LANG:en;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 08/14/2014 01:49 PM, Pavel Machek wrote:
> On Mon 2014-08-11 10:18:12, tthayer@opensource.altera.com wrote:
>> From: Thor Thayer <tthayer@opensource.altera.com>
>>
>> This patch adds support for the CycloneV and ArriaV SDRAM controllers.
>> Correction and reporting of SBEs, Panic on DBEs.
>>
>> Signed-off-by: Thor Thayer <tthayer@opensource.altera.com>
> Acked-by: Pavel Machek <pavel@denx.de>
>
Hi All,

Any further comments or suggestions on this patch series? Thanks for 
reviewing, Pavel!

Thor
