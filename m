Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753398AbbAELal (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 06:30:41 -0500
Received: from mail-by2on0092.outbound.protection.outlook.com ([207.46.100.92]:8000
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753196AbbAELaj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 06:30:39 -0500
Date: Mon, 5 Jan 2015 12:30:20 +0100
From: Michal Simek <michal.simek@xilinx.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Erico Nunes <nunes.erico@gmail.com>, <michal.simek@xilinx.com>
CC: <monstr@monstr.eu>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] microblaze: Add missing PVR version codes
References: <1420166433-12712-1-git-send-email-nunes.erico@gmail.com>
In-Reply-To: <1420166433-12712-1-git-send-email-nunes.erico@gmail.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-21224.006
X-TM-AS-User-Approved-Sender: Yes
Message-ID: <3f1aeed9398e4d47baeec954d0987a97@BY2FFO11FD036.protection.gbl>
X-EOPAttributedMessage: 0
Authentication-Results: spf=pass (sender IP is 62.221.5.235)
 smtp.mailfrom=michal.simek@xilinx.com; 
X-Forefront-Antispam-Report: CIP:62.221.5.235;CTRY:GB;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(24454002)(189002)(377454003)(51704005)(164054003)(479174004)(199003)(47776003)(64706001)(54356999)(50986999)(31966008)(87936001)(77156002)(65956001)(23746002)(92726002)(46102003)(50466002)(62966003)(108616004)(21056001)(99396003)(77096005)(65806001)(20776003)(19580405001)(6806004)(4396001)(76176999)(83506001)(92566001)(106466001)(86362001)(120916001)(74316001)(19580395003)(2950100001)(107046002)(104016003)(65826006)(107986001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2FFO11HUB030;H:xir-pvapsmtpgw01;FPR:;SPF:Pass;MLV:sfv;PTR:unknown-62-221-5-235.ipspace.xilinx.com;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2FFO11HUB030;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BY2FFO11HUB030;
X-Forefront-PRVS: 0447DB1C71
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY2FFO11HUB030;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2015 11:30:36.8869
 (UTC)
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[62.221.5.235]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY2FFO11HUB030
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/02/2015 03:40 AM, Erico Nunes wrote:
> PVR version code was missing in the cpu_ver_lookup table for the following
> versions: 8.50.b 8.50.c 9.2 9.3
> 
> This caused /proc/cpuinfo to display "CPU-Ver: Unknown" for these versions.
> 
> This was detected and the patch tested with MicroBlaze version 8.50.c.
> The other codes were taken from the Xilinx MicroBlaze Processor Reference
> Guides UG081 (v14.7) and UG984 (v2014.1).
> 
> Signed-off-by: Erico Nunes <nunes.erico@gmail.com>
> ---
>  arch/microblaze/kernel/cpu/cpuinfo.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/arch/microblaze/kernel/cpu/cpuinfo.c b/arch/microblaze/kernel/cpu/cpuinfo.c
> index 234acad..b60442d 100644
> --- a/arch/microblaze/kernel/cpu/cpuinfo.c
> +++ b/arch/microblaze/kernel/cpu/cpuinfo.c
> @@ -41,8 +41,12 @@ const struct cpu_ver_key cpu_ver_lookup[] = {
>  	{"8.40.a", 0x18},
>  	{"8.40.b", 0x19},
>  	{"8.50.a", 0x1a},
> +	{"8.50.b", 0x1c},
> +	{"8.50.c", 0x1e},
>  	{"9.0", 0x1b},
>  	{"9.1", 0x1d},
> +	{"9.2", 0x1f},
> +	{"9.3", 0x20},
>  	{NULL, 0},
>  };
>  
> 

Applied.

Thanks,
Michal
