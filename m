Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753095AbaCJOsg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 10:48:36 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34669 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753442AbaCJOsf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 10:48:35 -0400
Date: Mon, 10 Mar 2014 15:48:31 +0100
From: Jean Delvare <jdelvare@suse.de>
To: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Cc: akpm@linux-foundation.org, jg1.han@samsung.com, chris.cheney@gmail.com,
        konrad.wilk@oracle.com, geert@linux-m68k.org, joe@perches.com,
        gregkh@linuxfoundation.org, davem@davemloft.net, m.chehab@samsung.com,
        swarren@nvidia.com, linux-kernel@vger.kernel.org, dhjeffery@gmail.com
Subject: Re: [PATCH v3] MAINTAINERS: update IBM ServeRAID RAID info
Message-ID: <20140310154831.05522ad6@endymion.delvare>
In-Reply-To: <1394455805-12267-1-git-send-email-michael.opdenacker@free-electrons.com>
References: <531DB414.5020301@free-electrons.com>
	<1394455805-12267-1-git-send-email-michael.opdenacker@free-electrons.com>
Organization: SUSE Linux
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Mar 2014 13:50:05 +0100, Michael Opdenacker wrote:
> - Invalid maintainer e-mail address:
>   Mail server reply:
>   Recipient address rejected: User unknown in virtual alias table
> - Remove no longer working webpage URL
> - Remove obsolete "Person" field
> - Move status to "Orphan"
> - Add Dave Jeffery and Jack Hammer to the CREDITS file
> 
> Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
> ---
>  CREDITS     | 7 +++++++
>  MAINTAINERS | 5 +----
>  2 files changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/CREDITS b/CREDITS
> index e371c5504a50..0ffb4f68bb33 100644
> --- a/CREDITS
> +++ b/CREDITS
> @@ -1370,6 +1370,9 @@ S: 17 rue Danton
>  S: F - 94270 Le Kremlin-Bicêtre
>  S: France
>  
> +N: Jack Hammer
> +D: IBM ServeRAID RAID (ips) driver maintenance
> +
>  N: Greg Hankins
>  E: gregh@cc.gatech.edu
>  D: fixed keyboard driver to separate LED and locking status
> @@ -1680,6 +1683,10 @@ S: Reading
>  S: RG6 2NU
>  S: United Kingdom
>  
> +N: Dave Jeffery
> +E: dhjeffery@gmail.com
> +D: SCSI hacks and IBM ServeRAID RAID driver maintenance
> +
>  N: Jakub Jelinek
>  E: jakub@redhat.com
>  W: http://sunsite.mff.cuni.cz/~jj
> diff --git a/MAINTAINERS b/MAINTAINERS
> index b7befe758429..dbf4ca466efa 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -4296,10 +4296,7 @@ F:	drivers/scsi/ibmvscsi/
>  X:	drivers/scsi/ibmvscsi/ibmvstgt.c
>  
>  IBM ServeRAID RAID DRIVER
> -P:	Jack Hammer
> -M:	Dave Jeffery <ipslinux@adaptec.com>
> -W:	http://www.developer.ibm.com/welcome/netfinity/serveraid.html
> -S:	Supported
> +S:	Orphan
>  F:	drivers/scsi/ips.*
>  
>  ICH LPC AND GPIO DRIVER

Reviewed-by: Jean Delvare <jdelvare@suse.de>

-- 
Jean Delvare
SUSE L3 Support
