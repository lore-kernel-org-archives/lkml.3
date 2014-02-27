Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752683AbaB0MOf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 07:14:35 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:58476 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752393AbaB0MOd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 07:14:33 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v2.0.1
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20120718-3
Message-ID: <530F2C09.2040500@jp.fujitsu.com>
Date: Thu, 27 Feb 2014 21:14:01 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Rashika Kheria <rashika.kheria@gmail.com>
CC: <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Toshi Kani <toshi.kani@hp.com>, David Rientjes <rientjes@google.com>,
        Chen Gong <gong.chen@linux.intel.com>, Kevin Hao <haokexin@gmail.com>,
        <josh@joshtriplett.org>
Subject: Re: [PATCH 04/46] kernel: Mark function as static in kernel/resource.c
References: <7b4a60c74ced00e0d65c38488f20dc4bd69f0dd2.1393493276.git.rashika.kheria@gmail.com> <c216e1f98b80cff1736617fbf1474ea4dbaa4b4f.1393493276.git.rashika.kheria@gmail.com>
In-Reply-To: <c216e1f98b80cff1736617fbf1474ea4dbaa4b4f.1393493276.git.rashika.kheria@gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-SecurityPolicyCheck-GC: OK by FENCE-Mail
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/02/27 20:14), Rashika Kheria wrote:
> Mark function as static in kernel/resource.c because it is not used
> outside this file.
>
> This eliminates the following warning in kernel/resource.c:
> kernel/resource.c:518:5: warning: no previous prototype for ‘reallocate_resource’ [-Wmissing-prototypes]
>
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>
> ---

Reviewed-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>

Thanks,
Yasuaki Ishimatsu

>   kernel/resource.c |    6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/kernel/resource.c b/kernel/resource.c
> index 3f285dc..ede7db2 100644
> --- a/kernel/resource.c
> +++ b/kernel/resource.c
> @@ -515,9 +515,9 @@ static int find_resource(struct resource *root, struct resource *new,
>    * @newsize: new size of the resource descriptor
>    * @constraint: the size and alignment constraints to be met.
>    */
> -int reallocate_resource(struct resource *root, struct resource *old,
> -			resource_size_t newsize,
> -			struct resource_constraint  *constraint)
> +static int reallocate_resource(struct resource *root, struct resource *old,
> +			      resource_size_t newsize,
> +			      struct resource_constraint  *constraint)
>   {
>   	int err=0;
>   	struct resource new = *old;
>


