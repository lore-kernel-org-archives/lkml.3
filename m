Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759015Ab3HMUL1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 16:11:27 -0400
Received: from claw.goop.org ([74.207.240.146]:40551 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758937Ab3HMUL0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 16:11:26 -0400
Message-ID: <520A92ED.8030109@goop.org>
Date: Tue, 13 Aug 2013 13:11:25 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] MAINTAINERS: Remove Jeremy from the Xen subsystem.
References: <1375725937-22930-1-git-send-email-konrad.wilk@oracle.com> <1375725937-22930-2-git-send-email-konrad.wilk@oracle.com>
In-Reply-To: <1375725937-22930-2-git-send-email-konrad.wilk@oracle.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/05/2013 11:05 AM, Konrad Rzeszutek Wilk wrote:
> Jeremy has been a key person in making Linux work with Xen.
> He has been enjoying the last year working on something
> different so reflect that in the maintainers file.

Ack.

    J
>
> CC: Jeremy Fitzhardinge <jeremy@goop.org>
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> ---
>  CREDITS     | 1 +
>  MAINTAINERS | 1 -
>  2 files changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/CREDITS b/CREDITS
> index 206d0fc..646a0a9 100644
> --- a/CREDITS
> +++ b/CREDITS
> @@ -1120,6 +1120,7 @@ D: author of userfs filesystem
>  D: Improved mmap and munmap handling
>  D: General mm minor tidyups
>  D: autofs v4 maintainer
> +D: Xen subsystem
>  S: 987 Alabama St
>  S: San Francisco
>  S: CA, 94110
> diff --git a/MAINTAINERS b/MAINTAINERS
> index defc053..440af74 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -9237,7 +9237,6 @@ F:	drivers/media/tuners/tuner-xc2028.*
>  
>  XEN HYPERVISOR INTERFACE
>  M:	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> -M:	Jeremy Fitzhardinge <jeremy@goop.org>
>  L:	xen-devel@lists.xensource.com (moderated for non-subscribers)
>  L:	virtualization@lists.linux-foundation.org
>  S:	Supported

