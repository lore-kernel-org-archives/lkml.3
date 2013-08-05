Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755332Ab3HEWKs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 18:10:48 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:43195 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755019Ab3HEWKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 18:10:46 -0400
Message-ID: <5200230E.9000002@oracle.com>
Date: Mon, 05 Aug 2013 18:11:26 -0400
From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130402 Thunderbird/17.0.5
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        David Vrabel <david.vrabel@citrix.com>
Subject: Re: [PATCH 3/3] MAINTAINERS: Add in two extra co-maintainers of the
 Xen tree.
References: <1375725937-22930-1-git-send-email-konrad.wilk@oracle.com> <1375725937-22930-4-git-send-email-konrad.wilk@oracle.com>
In-Reply-To: <1375725937-22930-4-git-send-email-konrad.wilk@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/05/2013 02:05 PM, Konrad Rzeszutek Wilk wrote:
> Both Boris and David have graciously volunteered to help in
> maintaining the Xen subsystem tree. Cementing this in the
> MAINTAINERS file so they are copied on Xen related patches.
>
> CC: Boris Ostrovsky <boris.ostrovsky@oracle.com>
> CC: David Vrabel <david.vrabel@citrix.com>
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

Acked-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>


> ---
>   MAINTAINERS | 2 ++
>   1 file changed, 2 insertions(+)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 785f56a..0161dad 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -9237,6 +9237,8 @@ F:	drivers/media/tuners/tuner-xc2028.*
>   
>   XEN HYPERVISOR INTERFACE
>   M:	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> +M:	Boris Ostrovsky <boris.ostrovsky@oracle.com>
> +M:	David Vrabel <david.vrabel@citrix.com>
>   L:	xen-devel@lists.xenproject.org (moderated for non-subscribers)
>   S:	Supported
>   F:	arch/x86/xen/

