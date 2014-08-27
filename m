Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934123AbaH0NG7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 09:06:59 -0400
Received: from mail-bn1lp0139.outbound.protection.outlook.com ([207.46.163.139]:20608
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933257AbaH0NG4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 09:06:56 -0400
Message-ID: <53FDD7D8.5050602@opensource.altera.com>
Date: Wed, 27 Aug 2014 08:06:32 -0500
From: Dinh Nguyen <dinguyen@opensource.altera.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: Thor Thayer <tthayer@opensource.altera.com>, Pavel Machek <pavel@denx.de>,
        <robherring2@gmail.com>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <rob@landley.net>, <linux@arm.linux.org.uk>,
        <atull@opensource.altera.com>, <delicious.quinoa@gmail.com>,
        <dougthompson@xmission.com>, <grant.likely@linaro.org>,
        <sameo@linux.intel.com>, <lee.jones@linaro.org>,
        <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <tthayer.linux@gmail.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-edac@vger.kernel.org>
Subject: Re: [PATCHv10 2/2] arm: dts: Add Altera SDRAM EDAC bindings & devicetree
 entries.
References: <1407770293-27190-1-git-send-email-tthayer@opensource.altera.com> <1407770293-27190-3-git-send-email-tthayer@opensource.altera.com> <20140814184949.GC11558@amd.pavel.ucw.cz> <53FCD456.3050404@opensource.altera.com> <53FCEDDA.4060906@opensource.altera.com> <20140827063638.GA28234@nazgul.tnic>
In-Reply-To: <20140827063638.GA28234@nazgul.tnic>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [99.103.66.154]
X-ClientProxiedBy: BN1PR02CA0011.namprd02.prod.outlook.com (10.141.56.11) To
 BY1PR0301MB1190.namprd03.prod.outlook.com (25.160.195.149)
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 0316567485
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(6009001)(24454002)(479174003)(199003)(377454003)(51704005)(164054003)(189002)(66066001)(65806001)(65956001)(77982001)(80022001)(79102001)(59896002)(93886004)(85306004)(83506001)(76482001)(80316001)(83322001)(20776003)(85852003)(83072002)(4396001)(81342001)(47776003)(64706001)(21056001)(87976001)(81542001)(23676002)(46102001)(101416001)(74662001)(74502001)(31966008)(86362001)(92726001)(92566001)(90102001)(50466002)(50986999)(99396002)(33656002)(77096002)(87266999)(54356999)(76176999)(65816999)(106356001)(107046002)(105586002)(95666004)(64126003)(110136001)(102836001)(217873001);DIR:OUT;SFP:;SCL:1;SRVR:BY1PR0301MB1190;H:Dinhs-MacBook-Pro.local;FPR:;MLV:sfv;PTR:InfoNoRecords;A:3;MX:1;LANG:en;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Boris

On 8/27/14, 1:36 AM, Borislav Petkov wrote:
> On Tue, Aug 26, 2014 at 03:28:10PM -0500, Dinh Nguyen wrote:
>> If Boris is okay with driver part and everyone else is OK with the DTS
>> portion, then I can apply the DTS patch to my tree, and Boris take the
>> driver patch into his tree?
> 
> Actually, it would be easier for everyone involved if those patches go
> together due to their dependency. So if you want me to take a look at
> the EDAC parts again and give you my ack so that you can pick them all
> up together and they go through your tree, let me know.
> 

That would be great!

Thanks,
Dinh
