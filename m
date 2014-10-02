Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751615AbaJBHRR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 03:17:17 -0400
Received: from top.free-electrons.com ([176.31.233.9]:39206 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750987AbaJBHRQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 03:17:16 -0400
Message-ID: <542CFBF8.6080703@free-electrons.com>
Date: Thu, 02 Oct 2014 09:17:12 +0200
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: akpm@linux-foundation.org
CC: davem@davemloft.net, gregkh@linuxfoundation.org, joe@perches.com,
        m.chehab@samsung.com, crope@iki.fi, jg1.han@samsung.com,
        linux-kernel@vger.kernel.org, mikem@beardog.cce.hp.com,
        ISS StorageDev <iss_storagedev@hp.com>
Subject: Re: [PATCH] MAINTAINERS: fix Mike Miller's e-mail address
References: <1412233478-17115-1-git-send-email-michael.opdenacker@free-electrons.com>
In-Reply-To: <1412233478-17115-1-git-send-email-michael.opdenacker@free-electrons.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/02/2014 09:04 AM, Michael Opdenacker wrote:
> This replaces Mike Miller's e-mail address
> (now rejected by the HP mail server) by the
> latest one that he used to submit patches.
>
> Checked that this one is not rejected.
>
> Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
> ---
>  MAINTAINERS | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 37054306dc9f..6a8677b5ba24 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -4230,7 +4230,7 @@ F:	include/linux/cciss*.h
>  F:	include/uapi/linux/cciss*.h
>  
>  HEWLETT-PACKARD SMART CISS RAID DRIVER (cciss)
> -M:	Mike Miller <mike.miller@hp.com>
> +M:	Mike Miller <mikem@beardog.cce.hp.com>
>  L:	iss_storagedev@hp.com
>  S:	Supported
>  F:	Documentation/blockdev/cciss.txt

Oops, copying Mike Miller and the corresponding list too... Blind trust
in get_maintainer.pl is evil ;)

Michael.

-- 
Michael Opdenacker, CEO, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
+33 484 258 098

