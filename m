Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752018AbaLYC6E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 21:58:04 -0500
Received: from mail-db3on0098.outbound.protection.outlook.com ([157.55.234.98]:54400
	"EHLO emea01-db3-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751651AbaLYC6C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 21:58:02 -0500
Message-ID: <549B7D2C.4000201@ezchip.com>
Date: Wed, 24 Dec 2014 21:57:48 -0500
From: Chris Metcalf <cmetcalf@ezchip.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        <akpm@linux-foundation.org>
CC: <peterz@infradead.org>, <mingo@kernel.org>, <davej@redhat.com>,
        <sasha.levin@oracle.com>, <hughd@google.com>, <linux-mm@kvack.org>,
        <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 34/38] tile: drop pte_file()-related helpers
References: <1419423766-114457-1-git-send-email-kirill.shutemov@linux.intel.com> <1419423766-114457-35-git-send-email-kirill.shutemov@linux.intel.com>
In-Reply-To: <1419423766-114457-35-git-send-email-kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [173.76.26.91]
X-ClientProxiedBy: BN3PR09CA0036.namprd09.prod.outlook.com (25.160.111.174) To
 DB3PR02MB0537.eurprd02.prod.outlook.com (25.160.51.149)
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=cmetcalf@ezchip.com; 
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:DB3PR02MB0537;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:DB3PR02MB0537;
X-Forefront-PRVS: 04362AC73B
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(6049001)(377454003)(51704005)(199003)(479174004)(24454002)(189002)(80316001)(23746002)(62966003)(122386002)(77156002)(31966008)(120916001)(50466002)(40100003)(21056001)(68736005)(19580405001)(19580395003)(87976001)(99396003)(107046002)(46102003)(83506001)(15975445007)(65956001)(77096005)(66066001)(20776003)(47776003)(64706001)(36756003)(50986999)(87266999)(76176999)(54356999)(33656002)(86362001)(106356001)(97736003)(4396001)(2950100001)(92566001)(117156001)(42186005)(101416001)(65816999)(105586002)(18886065003);DIR:OUT;SFP:1101;SCL:1;SRVR:DB3PR02MB0537;H:[192.168.1.162];FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:DB3PR02MB0537;
X-OriginatorOrg: ezchip.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Dec 2014 02:57:56.5379 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3PR02MB0537
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/24/2014 7:22 AM, Kirill A. Shutemov wrote:
> We've replaced remap_file_pages(2) implementation with emulation.
> Nobody creates non-linear mapping anymore.
>
> Signed-off-by: Kirill A. Shutemov<kirill.shutemov@linux.intel.com>
> Cc: Chris Metcalf<cmetcalf@ezchip.com>
> ---
>   arch/tile/include/asm/pgtable.h | 11 -----------
>   arch/tile/mm/homecache.c        |  4 ----
>   2 files changed, 15 deletions(-)

Acked-by: Chris Metcalf <cmetcalf@ezchip.com>

-- 
Chris Metcalf, EZChip Semiconductor
http://www.ezchip.com

