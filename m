Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755963AbbA2IV0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 03:21:26 -0500
Received: from mail-by2on0132.outbound.protection.outlook.com ([207.46.100.132]:17952
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752765AbbA2IVW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 03:21:22 -0500
X-WSS-ID: 0NIXJ7H-07-K9A-02
X-M-MSG: 
Message-ID: <54C9ED70.1020803@amd.com>
Date: Thu, 29 Jan 2015 10:21:04 +0200
From: Oded Gabbay <oded.gabbay@amd.com>
Organization: AMD
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>, Dave Airlie <airlied@linux.ie>
CC: <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Ben Goz <ben.goz@amd.com>
Subject: Re: linux-next: build failure after merge of the drm tree
References: <20150129133857.2bdbb86d@canb.auug.org.au>
In-Reply-To: <20150129133857.2bdbb86d@canb.auug.org.au>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.20.0.84]
X-EOPAttributedMessage: 0
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Oded.Gabbay@amd.com; canb.auug.org.au; dkim=none (message not
 signed) header.d=none;canb.auug.org.au; dmarc=permerror action=none
 header.from=amd.com;
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(377454003)(24454002)(51444003)(51704005)(479174004)(92566002)(83506001)(77156002)(62966003)(87936001)(65806001)(46102003)(47776003)(101416001)(2950100001)(87266999)(36756003)(23746002)(33656002)(50986999)(54356999)(76176999)(50466002)(86362001)(64126003)(106466001)(105586002)(77096005);DIR:OUT;SFP:1102;SCL:1;SRVR:CO1PR02MB207;H:atltwp01.amd.com;FPR:;SPF:None;MLV:sfv;LANG:en;
X-DmarcAction-Test: None
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(3005004);SRVR:CO1PR02MB207;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:CO1PR02MB207;
X-Forefront-PRVS: 0471B73328
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:CO1PR02MB207;
X-OriginatorOrg: amd4.onmicrosoft.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jan 2015 08:21:19.3961
 (UTC)
X-MS-Exchange-CrossTenant-Id: fde4dada-be84-483f-92cc-e026cbee8e96
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=fde4dada-be84-483f-92cc-e026cbee8e96;Ip=[165.204.84.221]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR02MB207
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 01/29/2015 04:38 AM, Stephen Rothwell wrote:
> After merging the drm tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
>
> drivers/gpu/drm/amd/amdkfd/kfd_device.c: In function 'kgd2kfd_device_init':
> drivers/gpu/drm/amd/amdkfd/kfd_device.c:193:11: error: 'max_num_of_processes' undeclared (first use in this function)
>    size += (max_num_of_processes * sizeof(struct pm4_map_process) +
>             ^
> drivers/gpu/drm/amd/amdkfd/kfd_device.c:193:11: note: each undeclared identifier is reported only once for each function it appears in
> drivers/gpu/drm/amd/amdkfd/kfd_device.c:194:26: error: 'max_num_of_queues_per_process' undeclared (first use in this function)
>     max_num_of_processes * max_num_of_queues_per_process *
>                            ^
So I think that Dave's drm-next now contains the correct code.
Will you merge it again, or do you do it daily anyway ? I fear I'm entirely 
clear with the details of the linux-next process.

	Oded
