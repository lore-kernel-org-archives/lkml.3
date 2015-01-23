Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755350AbbAWPMP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 10:12:15 -0500
Received: from mail-bn1bon0140.outbound.protection.outlook.com ([157.56.111.140]:16716
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752593AbbAWPML (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 10:12:11 -0500
X-WSS-ID: 0NIMY7R-08-4S9-02
X-M-MSG: 
Message-ID: <54C264B1.5090508@amd.com>
Date: Fri, 23 Jan 2015 09:11:45 -0600
From: Tom Lendacky <thomas.lendacky@amd.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Andrey Ryabinin <a.ryabinin@samsung.com>, <linux-kernel@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "open list:AMD CRYPTOGRAPHIC..." <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH] crypto: ccp: terminate ccp_support array with empty element
References: <1421852791-29679-1-git-send-email-a.ryabinin@samsung.com>
In-Reply-To: <1421852791-29679-1-git-send-email-a.ryabinin@samsung.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.180.168.240]
X-EOPAttributedMessage: 0
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Thomas.Lendacky@amd.com; davemloft.net; dkim=none (message not
 signed) header.d=none;davemloft.net; dmarc=permerror action=none
 header.from=amd.com;
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(479174004)(51704005)(377454003)(24454002)(65956001)(105586002)(33656002)(50466002)(77096005)(107886001)(65806001)(87936001)(47776003)(83506001)(80316001)(19580405001)(19580395003)(106466001)(76176999)(54356999)(65816999)(50986999)(86362001)(59896002)(62966003)(46102003)(2950100001)(77156002)(23746002)(92566002)(101416001)(36756003);DIR:OUT;SFP:1102;SCL:1;SRVR:BLUPR02MB194;H:atltwp02.amd.com;FPR:;SPF:None;MLV:sfv;LANG:en;
X-DmarcAction-Test: None
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(3005004);SRVR:BLUPR02MB194;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BLUPR02MB194;
X-Forefront-PRVS: 0465429B7F
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BLUPR02MB194;
X-OriginatorOrg: amd4.onmicrosoft.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2015 15:11:54.2139
 (UTC)
X-MS-Exchange-CrossTenant-Id: fde4dada-be84-483f-92cc-e026cbee8e96
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=fde4dada-be84-483f-92cc-e026cbee8e96;Ip=[165.204.84.222]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLUPR02MB194
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/21/2015 09:06 AM, Andrey Ryabinin wrote:
> x86_match_cpu() expects array of x86_cpu_ids terminated
> with empty element.
>
> Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>

Acked-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>   drivers/crypto/ccp/ccp-dev.c | 1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/drivers/crypto/ccp/ccp-dev.c b/drivers/crypto/ccp/ccp-dev.c
> index c6e6171..ca29c12 100644
> --- a/drivers/crypto/ccp/ccp-dev.c
> +++ b/drivers/crypto/ccp/ccp-dev.c
> @@ -583,6 +583,7 @@ bool ccp_queues_suspended(struct ccp_device *ccp)
>   #ifdef CONFIG_X86
>   static const struct x86_cpu_id ccp_support[] = {
>   	{ X86_VENDOR_AMD, 22, },
> +	{ },
>   };
>   #endif
>
>
