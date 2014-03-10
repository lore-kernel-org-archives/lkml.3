Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752298AbaCJJGF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 05:06:05 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54969 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751795AbaCJJGD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 05:06:03 -0400
Date: Mon, 10 Mar 2014 10:05:58 +0100
From: Jean Delvare <jdelvare@suse.de>
To: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Cc: akpm@linux-foundation.org, joe@perches.com, gregkh@linuxfoundation.org,
        davem@davemloft.net, m.chehab@samsung.com, swarren@nvidia.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: remove invalid IBM ServeRAID RAID
 maintainer address
Message-ID: <20140310100558.72cb750a@endymion.delvare>
In-Reply-To: <1394441655-8257-1-git-send-email-michael.opdenacker@free-electrons.com>
References: <1394441655-8257-1-git-send-email-michael.opdenacker@free-electrons.com>
Organization: SUSE Linux
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michael,

On Mon, 10 Mar 2014 09:54:15 +0100, Michael Opdenacker wrote:
> Mail server reply:
> Recipient address rejected: User unknown in virtual alias table
> 
> Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
> ---
>  MAINTAINERS | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index b7befe758429..52ca18df1707 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -4297,7 +4297,6 @@ X:	drivers/scsi/ibmvscsi/ibmvstgt.c
>  
>  IBM ServeRAID RAID DRIVER
>  P:	Jack Hammer

A name without an address isn't quite useful (this field is obsolete.)

> -M:	Dave Jeffery <ipslinux@adaptec.com>
>  W:	http://www.developer.ibm.com/welcome/netfinity/serveraid.html

This URL doesn't work for me.

>  S:	Supported

Which makes the validity of this claim rather dubious. I'd suggest you
remove the P and W fields change S to Orphaned.

>  F:	drivers/scsi/ips.*

Thanks,
-- 
Jean Delvare
SUSE L3 Support
