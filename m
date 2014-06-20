Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966589AbaFTKlC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 06:41:02 -0400
Received: from mail-by2lp0244.outbound.protection.outlook.com ([207.46.163.244]:33121
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S966233AbaFTKlA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 06:41:00 -0400
Message-ID: <53A40FB0.2020503@ixiacom.com>
Date: Fri, 20 Jun 2014 13:40:48 +0300
From: Sorin Dumitru <sdumitru@ixiacom.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: James Hogan <james.hogan@imgtec.com>, <linux-kernel@vger.kernel.org>,
        <linux-mips@linux-mips.org>
CC: <ralf@linux-mips.org>
Subject: Re: [PATCH] mips: n32: use compat getsockopt syscall
References: <1403250786-9763-1-git-send-email-sdumitru@ixiacom.com> <53A404D2.3030303@imgtec.com>
In-Reply-To: <53A404D2.3030303@imgtec.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [205.168.23.154]
X-ClientProxiedBy: BY2PR07CA057.namprd07.prod.outlook.com (10.141.251.32) To
 BLUPR0601MB0946.namprd06.prod.outlook.com (25.160.35.22)
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 024847EE92
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(6009001)(6049001)(428001)(51704005)(479174003)(199002)(189002)(24454002)(164054003)(83506001)(83072002)(85852003)(87976001)(36756003)(102836001)(74502001)(31966008)(105586002)(33656002)(4396001)(50466002)(74662001)(99396002)(21056001)(101416001)(2201001)(50986999)(46102001)(54356999)(92726001)(92566001)(76176999)(87266999)(85306003)(95666004)(86362001)(65816999)(77096002)(64126003)(47776003)(81342001)(23756003)(42186005)(20776003)(19580395003)(80316001)(83322001)(19580405001)(76482001)(65806001)(66066001)(106356001)(80022001)(77982001)(81542001)(64706001)(79102001)(59896001)(2101003);DIR:OUT;SFP:;SCL:1;SRVR:BLUPR0601MB0946;H:[10.205.20.44];FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=sdumitru@ixiacom.com; 
X-MS-Exchange-CrossPremises-OriginalClientIPAddress: 205.168.23.154
X-MS-Exchange-CrossPremises-AuthSource: BLUPR0601MB0946.namprd06.prod.outlook.com
X-MS-Exchange-CrossPremises-AuthAs: Internal
X-MS-Exchange-CrossPremises-AuthMechanism: 06
X-MS-Exchange-CrossPremises-AVStamp-Service: 1.0
X-MS-Exchange-CrossPremises-SCL: 1
X-MS-Exchange-CrossPremises-Antispam-ScanContext: DIR:Originating;SFV:NSPM;SKIP:0;
X-MS-Exchange-CrossPremises-Processed-By-Journaling: Journal Agent
X-OrganizationHeadersPreserved: BLUPR0601MB0946.namprd06.prod.outlook.com
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-OriginatorOrg: ixiacom.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 06/20/14 12:54, James Hogan wrote:
> On 20/06/14 08:53, Sorin Dumitru wrote:
>> Signed-off-by: Sorin Dumitru <sdumitru@ixiacom.com>
>
> A little more commit message wouldn't hurt. Did it break a particular
> program?

Yes, it was found by an internal program trying to get IP_PKTOPTIONS on 
a cavium octeon board.

Should I resubmit stating what was broken in the commit message?

Thanks,
Sorin
