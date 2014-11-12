Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753424AbaKLUSR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 15:18:17 -0500
Received: from ezexch.ezchip.com ([212.179.42.101]:39808 "EHLO ezchip.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753151AbaKLUSQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 15:18:16 -0500
Message-ID: <5463C07E.7070505@ezchip.com>
Date: Wed, 12 Nov 2014 15:18:06 -0500
From: Chris Metcalf <cmetcalf@ezchip.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Chen Gang <gang.chen.5i5j@gmail.com>
CC: <rdunlap@infradead.org>, <rickard_strandqvist@spectrumdigital.se>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arch: tile: gxio: Export symbols for module using in
 'mpipe.c'
References: <cr8vqhwy7vrnhtnbt7587wmv.1415751123895@email.android.com>
In-Reply-To: <cr8vqhwy7vrnhtnbt7587wmv.1415751123895@email.android.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [12.216.194.146]
X-ClientProxiedBy: BLUPR07CA0040.namprd07.prod.outlook.com (10.255.223.153) To
 DB3PR02MB0537.eurprd02.prod.outlook.com (25.160.51.149)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:DB3PR02MB0537;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:DB3PR02MB0537;
X-Forefront-PRVS: 03932714EB
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6049001)(6009001)(24454002)(479174003)(189002)(377454003)(199003)(92726001)(86362001)(54356999)(19580395003)(92566001)(87976001)(42186005)(99396003)(21056001)(4396001)(50466002)(120916001)(83506001)(95666004)(76176999)(87266999)(97736003)(15975445006)(50986999)(23676002)(80316001)(65806001)(66066001)(107046002)(64706001)(20776003)(47776003)(106356001)(65816999)(105586002)(64126003)(59896002)(46102003)(77096003)(62966003)(15202345003)(77156002)(122386002)(36756003)(33656002)(101416001)(102836001)(31966008)(110136001)(40100003)(18886065003);DIR:OUT;SFP:1101;SCL:1;SRVR:DB3PR02MB0537;H:[10.7.0.239];FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:DB3PR02MB0537;
X-OriginatorOrg: ezchip.com
X-TM-AS-Product-Ver: SMEX-11.0.0.1191-7.500.1018-21096.002
X-TM-AS-Result: No--4.313000-8.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11/2014 7:16 PM, Chen Gang wrote:
> And I also want to consult, can tile be run under qemu or other
> simulators? Welcome any ideas, suggestions, and completions.

Our use of qemu so far as been purely in the context of virtualization,
where it functions as the KVM driver.  No one has looked into using qemu
as an instruction simulator, for example.  Patches welcome :-)

We do have a simulator, but for the time being, it's only available
as part of chip sales to our customers.

-- 
Chris Metcalf, EZChip Semiconductor
http://www.ezchip.com

