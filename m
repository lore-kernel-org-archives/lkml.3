Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932297AbaHNWUg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 18:20:36 -0400
Received: from mail-bl2lp0203.outbound.protection.outlook.com ([207.46.163.203]:53525
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932117AbaHNWUf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 18:20:35 -0400
X-WSS-ID: 0NABI1Q-08-8FN-02
X-M-MSG: 
Message-ID: <53ED361F.4010009@amd.com>
Date: Thu, 14 Aug 2014 17:20:15 -0500
From: Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Borislav Petkov <bp@suse.de>
CC: Clemens Ladisch <clemens@ladisch.de>, Guenter Roeck <linux@roeck-us.net>,
        <jdelvare@suse.de>, <rdunlap@infradead.org>, <tglx@linutronix.de>,
        <mingo@redhat.com>, <hpa@zytor.com>, <dan.carpenter@oracle.com>,
        <lm-sensors@lm-sensors.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2] hwmon, k10temp: Add support for F15h M60h
References: <1408035262-18026-1-git-send-email-aravind.gopalakrishnan@amd.com>
 <20140814201730.GA501@roeck-us.net> <53ED1A87.6000400@ladisch.de>
 <20140814210816.GC18887@pd.tnic> <53ED30BD.90403@amd.com>
 <20140814220530.GD18887@pd.tnic>
In-Reply-To: <20140814220530.GD18887@pd.tnic>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.180.168.240]
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019004)(6009001)(428002)(189002)(199003)(51704005)(479174003)(377454003)(24454002)(93886004)(33656002)(87266999)(21056001)(85306004)(76176999)(65956001)(65816999)(50986999)(54356999)(77982001)(110136001)(99396002)(76482001)(97736001)(102836001)(107046002)(74502001)(46102001)(106466001)(31966008)(95666004)(83506001)(80022001)(85852003)(47776003)(65806001)(50466002)(83322001)(44976005)(80316001)(83072002)(92726001)(74662001)(68736004)(87936001)(81342001)(23676002)(59896001)(101416001)(86362001)(84676001)(105586002)(4396001)(81542001)(20776003)(64706001)(92566001)(79102001)(36756003);DIR:OUT;SFP:1102;SCL:1;SRVR:CO1PR02MB048;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 03030B9493
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Aravind.Gopalakrishnan@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/14/2014 5:05 PM, Borislav Petkov wrote:
> On Thu, Aug 14, 2014 at 04:57:17PM -0500, Aravind Gopalakrishnan wrote:
>> Actually I don't need it outside of k10temp as of now (or near future)
>> I added it in amd_nb as that was Clemens, Guenter's suggestion on the
>> previous version;
>> Besides, it made sense as it's an indirect access of NB_SMU register and
>> amd_nb seems a good place to put the function in case someone needs it in
>> the future.
> Then someone can move it then. But until that happens it is pretty
> pointless of having the Kconfig dependency just for one small function
> with a single user.
>
>> I can move it locally to k10temp and remove the dependency if that's
>> more preferable.
> Yeah, it looks like a fabricated and not true dependency, which doesn't
> make any sense currently.
>
> Thanks.
>

Ok, Will fix this and send V3.

-Aravind.
