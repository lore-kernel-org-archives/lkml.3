Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753486AbaCJMqQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 08:46:16 -0400
Received: from top.free-electrons.com ([176.31.233.9]:48840 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752628AbaCJMqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 08:46:14 -0400
Message-ID: <531DB414.5020301@free-electrons.com>
Date: Mon, 10 Mar 2014 13:46:12 +0100
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: khali@linux-fr.org, akpm@linux-foundation.org
CC: jg1.han@samsung.com, chris.cheney@gmail.com, konrad.wilk@oracle.com,
        geert@linux-m68k.org, joe@perches.com, gregkh@linuxfoundation.org,
        davem@davemloft.net, m.chehab@samsung.com, swarren@nvidia.com,
        linux-kernel@vger.kernel.org, dhjeffery@gmail.com
Subject: Re: [PATCH v2] MAINTAINERS: update IBM ServeRAID RAID info
References: <1394443746.2979.3.camel@x220> <1394455352-11874-1-git-send-email-michael.opdenacker@free-electrons.com>
In-Reply-To: <1394455352-11874-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allowed me to check that Jack Hammer's e-mail address no longer
works. I will send a v3 update.

Michael.

On 03/10/2014 01:42 PM, Michael Opdenacker wrote:
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
>  CREDITS     | 8 ++++++++
>  MAINTAINERS | 5 +----
>  2 files changed, 9 insertions(+), 4 deletions(-)
>
> diff --git a/CREDITS b/CREDITS
> index e371c5504a50..6621cb9e7992 100644
> --- a/CREDITS
> +++ b/CREDITS
> @@ -1370,6 +1370,10 @@ S: 17 rue Danton
>  S: F - 94270 Le Kremlin-Bicêtre
>  S: France
>  
> +N: Jack Hammer
> +E: jack_hammer@adaptec.com
> +D: IBM ServeRAID RAID (ips) driver maintenance
> +
>  N: Greg Hankins
>  E: gregh@cc.gatech.edu
>  D: fixed keyboard driver to separate LED and locking status
> @@ -1680,6 +1684,10 @@ S: Reading
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


-- 
Michael Opdenacker, CEO, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
+33 484 258 098

