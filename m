Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751422AbaKGEAI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 23:00:08 -0500
Received: from mail-bn1bn0108.outbound.protection.outlook.com ([157.56.110.108]:23424
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751225AbaKGEAE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 23:00:04 -0500
X-WSS-ID: 0NENHRX-08-UXM-02
X-M-MSG: 
Message-ID: <545C4279.5080104@amd.com>
Date: Fri, 7 Nov 2014 11:54:33 +0800
From: David Zhou <david1.zhou@amd.com>
Organization: AMD
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Alex Pilon <alp+linux@alexpilon.ca>, David Airlie <airlied@linux.ie>
CC: <dri-devel@lists.freedesktop.org>, <linux-kernel@vger.kernel.org>,
        <trivial@kernel.org>
Subject: Re: [PATCH] drm: Fix spelling.
References: <20141107003505.GA3491@alexpilon.ca>
In-Reply-To: <20141107003505.GA3491@alexpilon.ca>
Content-Type: text/plain; charset="UTF-8"; format=flowed
X-Originating-IP: [10.237.74.94]
Content-Transfer-Encoding: 8BIT
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(189002)(199003)(51704005)(24454002)(101416001)(120916001)(92566001)(76176999)(59896002)(106466001)(33656002)(92726001)(47776003)(46102003)(20776003)(83506001)(87266999)(95666004)(65956001)(107046002)(54356999)(64706001)(23676002)(99396003)(62966003)(65816999)(21056001)(50986999)(87936001)(19580395003)(64126003)(36756003)(19580405001)(50466002)(68736004)(80316001)(102836001)(105586002)(97736003)(77156002)(84676001)(44976005)(4396001)(31966008)(86362001);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR02MB197;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR02MB197;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 03883BD916
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=David1.Zhou@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ok to fix.

Regards,
David
On 2014年11月07日 08:36, Alex Pilon wrote:
> Fix spelling of 'ioctl'.
>
> Signed-off-by: Alex Pilon <alp+linux@alexpilon.ca>
> ---
>   drivers/gpu/drm/drm_crtc.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/gpu/drm/drm_crtc.c b/drivers/gpu/drm/drm_crtc.c
> index e79c8d3..3d274c1 100644
> --- a/drivers/gpu/drm/drm_crtc.c
> +++ b/drivers/gpu/drm/drm_crtc.c
> @@ -2943,7 +2943,7 @@ EXPORT_SYMBOL(drm_mode_legacy_fb_format);
>    * @file_priv: drm file for the ioctl call
>    *
>    * Add a new FB to the specified CRTC, given a user request. This is the
> - * original addfb ioclt which only supported RGB formats.
> + * original addfb ioctl which only supported RGB formats.
>    *
>    * Called by the user via ioctl.
>    *

