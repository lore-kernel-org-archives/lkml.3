Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756064AbaGNOnW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 10:43:22 -0400
Received: from dns-bn1lp0143.outbound.protection.outlook.com ([207.46.163.143]:40441
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755940AbaGNOnI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 10:43:08 -0400
X-WSS-ID: 0N8PI7O-07-NEJ-02
X-M-MSG: 
Message-ID: <53C3EC73.2060109@amd.com>
Date: Mon, 14 Jul 2014 09:42:59 -0500
From: Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: <dougthompson@xmission.com>, <m.chehab@samsung.com>,
        <linux-edac@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] EDAC, MCE_AMD: Add MCE decoding for F15h M60h
References: <1405098795-4678-1-git-send-email-Aravind.Gopalakrishnan@amd.com>
 <20140714140610.GB25115@pd.tnic>
In-Reply-To: <20140714140610.GB25115@pd.tnic>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.180.168.240]
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(428002)(164054003)(199002)(189002)(24454002)(479174003)(52544003)(51704005)(377454003)(50986999)(83072002)(59896001)(54356999)(77982001)(64706001)(105586002)(31966008)(79102001)(85306003)(15975445006)(50466002)(76482001)(83506001)(76176999)(110136001)(95666004)(87266999)(87936001)(65816999)(74662001)(64126003)(81342001)(80316001)(23676002)(65956001)(19580395003)(33656002)(84676001)(47776003)(92726001)(36756003)(20776003)(86362001)(15202345003)(81542001)(85852003)(83322001)(97736001)(68736004)(19580405001)(21056001)(99396002)(106466001)(46102001)(102836001)(74502001)(4396001)(101416001)(44976005)(107046002)(92566001)(80022001);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR02MB042;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 02723F29C4
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Aravind.Gopalakrishnan@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/14/2014 9:06 AM, Borislav Petkov wrote:
> On Fri, Jul 11, 2014 at 12:13:15PM -0500, Aravind Gopalakrishnan wrote:
>> Add decoding logic for new Fam15h model 60h.
>>
>> Tested using mce_amd_inj module and works fine.
>>
>> Signed-off-by: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
>> ---
>>   drivers/edac/mce_amd.c | 59 ++++++++++++++++++++++++++++++++++++++++++++++----
>>   1 file changed, 55 insertions(+), 4 deletions(-)
> Ok, I simplified it a bit, those switch-case(s) with a single case
> statement are not as readable as a simple if-else. I'd appreciate it if
> you ran it to check whether it still decodes fine before I apply it.
>
> Thanks.

Yep, works fine.

Thanks,
-Aravind.

>
> ---
> From: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
> Subject: [PATCH] EDAC, MCE, AMD: Add MCE decoding for F15h M60h
> Date:	Fri, 11 Jul 2014 12:13:15 -0500
> Message-ID: <1405098795-4678-1-git-send-email-Aravind.Gopalakrishnan@amd.com>
> X-Mailer: git-send-email 1.8.1.2
> MIME-Version: 1.0
> Content-Transfer-Encoding: 8bit
> Content-Type: text/plain; charset=utf-8
> Status: RO
>
> Add decoding logic for new Fam15h model 60h.
>
> Tested using mce_amd_inj module and works fine.
>
> Signed-off-by: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
> Link: http://lkml.kernel.org/r/1405098795-4678-1-git-send-email-Aravind.Gopalakrishnan@amd.com
> [ Boris: simplify a bit. ]
> Signed-off-by: Borislav Petkov <bp@suse.de>
> ---
>

