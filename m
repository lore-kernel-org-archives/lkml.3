Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754743AbaHZUbu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 16:31:50 -0400
Received: from mail-bn1blp0189.outbound.protection.outlook.com ([207.46.163.189]:53754
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753601AbaHZUbs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 16:31:48 -0400
Message-ID: <53FCEDDA.4060906@opensource.altera.com>
Date: Tue, 26 Aug 2014 15:28:10 -0500
From: Dinh Nguyen <dinguyen@opensource.altera.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Thor Thayer <tthayer@opensource.altera.com>, Pavel Machek <pavel@denx.de>
CC: <robherring2@gmail.com>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <rob@landley.net>, <linux@arm.linux.org.uk>,
        <atull@opensource.altera.com>, <delicious.quinoa@gmail.com>,
        <dougthompson@xmission.com>, <grant.likely@linaro.org>, <bp@alien8.de>,
        <sameo@linux.intel.com>, <lee.jones@linaro.org>,
        <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <tthayer.linux@gmail.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-edac@vger.kernel.org>
Subject: Re: [PATCHv10 2/2] arm: dts: Add Altera SDRAM EDAC bindings & devicetree
 entries.
References: <1407770293-27190-1-git-send-email-tthayer@opensource.altera.com> <1407770293-27190-3-git-send-email-tthayer@opensource.altera.com> <20140814184949.GC11558@amd.pavel.ucw.cz> <53FCD456.3050404@opensource.altera.com>
In-Reply-To: <53FCD456.3050404@opensource.altera.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: BN1PR02CA0033.namprd02.prod.outlook.com (10.141.56.33) To
 BY1PR0301MB1191.namprd03.prod.outlook.com (25.160.195.15)
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 03152A99FF
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(6049001)(6009001)(164054003)(377424004)(189002)(53754006)(377454003)(479174003)(51704005)(199003)(24454002)(51914003)(50466002)(33656002)(77982001)(31966008)(85306004)(93886004)(79102001)(74502001)(74662001)(23746002)(76482001)(59896002)(83322001)(19580405001)(83072002)(42186005)(80316001)(85852003)(90102001)(19580395003)(92726001)(95666004)(105586002)(92566001)(86362001)(4396001)(77096002)(87976001)(102836001)(106356001)(21056001)(83506001)(101416001)(64706001)(99396002)(65956001)(76176999)(80022001)(64126003)(50986999)(66066001)(54356999)(87266999)(46102001)(65806001)(20776003)(107046002)(81542001)(81342001)(47776003)(65816999)(217873001);DIR:OUT;SFP:;SCL:1;SRVR:BY1PR0301MB1191;H:[137.57.160.210];FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:0;LANG:en;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/26/2014 01:39 PM, Thor Thayer wrote:
> 
> On 08/14/2014 01:49 PM, Pavel Machek wrote:
>> On Mon 2014-08-11 10:18:13, tthayer@opensource.altera.com wrote:
>>> From: Thor Thayer <tthayer@opensource.altera.com>
>>>
>>> Add the Altera SDRAM EDAC bindings and device tree changes to the
>>> Altera SoC project.
>>>
>>> Signed-off-by: Thor Thayer <tthayer@opensource.altera.com>
>> Acked-by: Pavel Machek <pavel@denx.de>
>>
>>
> Hi All,
> 
> Any further comments or suggestions on this patch series? Thanks for the
> review, Pavel!

If Boris is okay with driver part and everyone else is OK with the DTS
portion, then I can apply the DTS patch to my tree, and Boris take the
driver patch into his tree?

Thanks,
Dinh

