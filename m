Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751567AbaKKU4J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 15:56:09 -0500
Received: from ezexch.ezchip.com ([212.179.42.101]:42555 "EHLO ezchip.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751086AbaKKU4H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 15:56:07 -0500
Message-ID: <546277D2.2060500@ezchip.com>
Date: Tue, 11 Nov 2014 15:55:46 -0500
From: Chris Metcalf <cmetcalf@ezchip.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Andrew Morton <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tile: Use the more common pr_warn instead of pr_warning
References: <cover.1414691783.git.joe@perches.com>	 <5453946F.3030803@tilera.com> <1414777846.13647.3.camel@perches.com>
In-Reply-To: <1414777846.13647.3.camel@perches.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [12.216.194.146]
X-ClientProxiedBy: DM2PR00CA0032.namprd00.prod.outlook.com (25.160.243.42) To
 DB3PR02MB0539.eurprd02.prod.outlook.com (25.160.51.150)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:DB3PR02MB0539;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:DB3PR02MB0539;
X-Forefront-PRVS: 0392679D18
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(6049001)(51704005)(24454002)(377454003)(479174003)(41574002)(189002)(199003)(99396003)(23756003)(87976001)(4396001)(120916001)(83506001)(97736003)(92566001)(92726001)(15975445006)(19580405001)(102836001)(59896002)(46102003)(101416001)(40100003)(19580395003)(80316001)(33656002)(77096003)(64126003)(42186005)(62966003)(77156002)(31966008)(95666004)(50986999)(107046002)(50466002)(105586002)(15202345003)(86362001)(36756003)(106356001)(110136001)(87266999)(122386002)(76176999)(65806001)(66066001)(54356999)(21056001)(20776003)(65956001)(65816999)(47776003)(64706001)(18886065003);DIR:OUT;SFP:1101;SCL:1;SRVR:DB3PR02MB0539;H:[10.7.0.239];FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:DB3PR02MB0539;
X-OriginatorOrg: ezchip.com
X-TM-AS-Product-Ver: SMEX-11.0.0.1191-7.500.1018-21094.002
X-TM-AS-Result: No--3.179500-8.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/31/2014 1:50 PM, Joe Perches wrote:
> And other message logging neatening.
>
> Other miscellanea:
>
> o coalesce formats
> o realign arguments
> o standardize a couple of macros
> o use __func__ instead of embedding the function name
>
> Signed-off-by: Joe Perches<joe@perches.com>

Thanks!  Taken into the tile tree.

-- 
Chris Metcalf, EZChip Semiconductor
http://www.ezchip.com

