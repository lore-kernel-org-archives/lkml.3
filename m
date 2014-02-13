Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752638AbaBMX3Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 18:29:24 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:33950 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752107AbaBMX3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 18:29:20 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v2.0.1
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20120718-3
Message-ID: <52FD54F0.8050006@jp.fujitsu.com>
Date: Fri, 14 Feb 2014 08:27:44 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Daeseok Youn <daeseok.youn@gmail.com>
CC: <akpm@linux-foundation.org>, <toshi.kani@hp.com>, <rientjes@google.com>,
        <gong.chen@linux.intel.com>, <haokexin@gmail.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel/resource.c: fix sparse non static symbol warning
References: <2767883.6dX08SOjIi@daeseok-laptop.cloud.net>
In-Reply-To: <2767883.6dX08SOjIi@daeseok-laptop.cloud.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-SecurityPolicyCheck-GC: OK by FENCE-Mail
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/02/13 11:02), Daeseok Youn wrote:
>  From f8e0752ac80e56bcbfe197a5820692d199822b52 Mon Sep 17 00:00:00 2001
> From: Daeseok Youn <daeseok.youn@gmail.com>
> Date: Thu, 13 Feb 2014 10:11:39 +0900
> Subject: [PATCH] kernel/resource.c: fix sparse non static symbol warning
>
> kernel/resource.c:518:5: warning:
>   symbol 'reallocate_resource' was not declared. Should it be static?
>
> Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
> ---

Reviewed-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>

Thanks,
Yasuaki Ishimatsu


>   kernel/resource.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/kernel/resource.c b/kernel/resource.c
> index 3f285dc..b2979c6 100644
> --- a/kernel/resource.c
> +++ b/kernel/resource.c
> @@ -515,7 +515,7 @@ static int find_resource(struct resource *root, struct resource *new,
>    * @newsize: new size of the resource descriptor
>    * @constraint: the size and alignment constraints to be met.
>    */
> -int reallocate_resource(struct resource *root, struct resource *old,
> +static int reallocate_resource(struct resource *root, struct resource *old,
>   			resource_size_t newsize,
>   			struct resource_constraint  *constraint)
>   {
>


