Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932069AbbA2IT2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 03:19:28 -0500
Received: from mail-bn1on0144.outbound.protection.outlook.com ([157.56.110.144]:22976
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755650AbbA2ITZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 03:19:25 -0500
X-WSS-ID: 0NIXJ45-07-K6H-02
X-M-MSG: 
Message-ID: <54C9ECF8.6020309@amd.com>
Date: Thu, 29 Jan 2015 10:19:04 +0200
From: Oded Gabbay <oded.gabbay@amd.com>
Organization: AMD
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>, Dave Airlie <airlied@linux.ie>
CC: <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Ben Goz <ben.goz@amd.com>
Subject: Re: linux-next: manual merge of the drm tree with Linus' tree
References: <20150129131718.645dbb99@canb.auug.org.au>
In-Reply-To: <20150129131718.645dbb99@canb.auug.org.au>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.20.0.84]
X-EOPAttributedMessage: 0
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Oded.Gabbay@amd.com; canb.auug.org.au; dkim=none (message not
 signed) header.d=none;canb.auug.org.au; dmarc=permerror action=none
 header.from=amd.com;
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(377454003)(41574002)(24454002)(51704005)(479174004)(92566002)(83506001)(77156002)(62966003)(87936001)(65806001)(46102003)(47776003)(101416001)(2950100001)(87266999)(36756003)(23746002)(33656002)(50986999)(54356999)(76176999)(50466002)(86362001)(64126003)(106466001)(105586002)(77096005);DIR:OUT;SFP:1102;SCL:1;SRVR:CO1PR02MB207;H:atltwp01.amd.com;FPR:;SPF:None;MLV:sfv;LANG:en;
X-DmarcAction-Test: None
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(3005004);SRVR:CO1PR02MB207;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:CO1PR02MB207;
X-Forefront-PRVS: 0471B73328
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:CO1PR02MB207;
X-OriginatorOrg: amd4.onmicrosoft.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jan 2015 08:19:20.1972
 (UTC)
X-MS-Exchange-CrossTenant-Id: fde4dada-be84-483f-92cc-e026cbee8e96
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=fde4dada-be84-483f-92cc-e026cbee8e96;Ip=[165.204.84.221]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR02MB207
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 01/29/2015 04:17 AM, Stephen Rothwell wrote:
> Hi Dave,
>
> Today's linux-next merge of the drm tree got conflicts in
> drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c and
> drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.h between commits
> b8cbab042cd6 ("drm/amdkfd: Allow user to limit only queues per device")
> and 9fa843e76d90 ("drm/amdkfd: Fix bug in call to init_pipelines()")
> from Linus' tree and commits bcea30817574 ("drm/amdkfd: Add SDMA
> user-mode queues support to QCM") and fe502804205e ("drm/amdkfd: Remove
> call to deprecated init_memory interface") from the drm tree.
>
> I fixed it up (hopefully - see below) and can carry the fix as
> necessary (no action is required).
>
Looks fine, thanks!

	Oded
