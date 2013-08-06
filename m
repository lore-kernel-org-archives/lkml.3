Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755492Ab3HFJbh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 05:31:37 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:53020 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755346Ab3HFJbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 05:31:36 -0400
X-IronPort-AV: E=Sophos;i="4.89,825,1367971200"; 
   d="scan'208";a="39639084"
Message-ID: <5200C270.7070904@citrix.com>
Date: Tue, 6 Aug 2013 10:31:28 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: <xen-devel@lists.xenproject.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 3/3] MAINTAINERS: Add in two extra	co-maintainers
 of the Xen tree.
References: <1375725937-22930-1-git-send-email-konrad.wilk@oracle.com> <1375725937-22930-4-git-send-email-konrad.wilk@oracle.com>
In-Reply-To: <1375725937-22930-4-git-send-email-konrad.wilk@oracle.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/08/13 19:05, Konrad Rzeszutek Wilk wrote:
> Both Boris and David have graciously volunteered to help in
> maintaining the Xen subsystem tree. Cementing this in the
> MAINTAINERS file so they are copied on Xen related patches.

Acked-by: David Vrabel <david.vrabel@citrix.com>

> ---
>  MAINTAINERS | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 785f56a..0161dad 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -9237,6 +9237,8 @@ F:	drivers/media/tuners/tuner-xc2028.*
>  
>  XEN HYPERVISOR INTERFACE
>  M:	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> +M:	Boris Ostrovsky <boris.ostrovsky@oracle.com>
> +M:	David Vrabel <david.vrabel@citrix.com>
>  L:	xen-devel@lists.xenproject.org (moderated for non-subscribers)
>  S:	Supported
>  F:	arch/x86/xen/

