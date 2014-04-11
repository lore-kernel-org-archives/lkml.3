Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759024AbaDKPnD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 11:43:03 -0400
Received: from mail-oa0-f52.google.com ([209.85.219.52]:46540 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755733AbaDKPm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 11:42:58 -0400
Message-ID: <53480D80.4080404@pochix.net>
Date: Fri, 11 Apr 2014 10:42:56 -0500
From: Robert Jennings <rob@pochix.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Nathan Fontenot <nfont@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-scsi <linux-scsi@vger.kernel.org>,
        Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH] Update Maintainers for IBM Power 842, vscsi, and vfc
 drivers
References: <53459226.2070002@linux.vnet.ibm.com>
In-Reply-To: <53459226.2070002@linux.vnet.ibm.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512



On 04/09/2014 01:32 PM, Nathan Fontenot wrote:
> Update the MAINTAINERS file to indicate the current maintainers
> for the IBM Power 842 Compression driver, IBM Power Virtual SCSI
> driver and the IBM Power Virtual FC Driver.
> 
> Signed-off-by: Nathan Fontenot <nfont@linux.vnet.ibm.com>

Nathan, sorry I didn't take care of this before I gave up
rcj@linux.ibm.com.

Acked-by: Robert Jennings <rob@pochix.net>

> --- MAINTAINERS |   16 +++++++++++----- 1 file changed, 11 
> insertions(+), 5 deletions(-)
> 
> Index: linux/MAINTAINERS 
> ===================================================================
>
>
> 
- --- linux.orig/MAINTAINERS	2014-04-08 14:14:57.000000000 -0500
> +++ linux/MAINTAINERS	2014-04-08 14:25:29.000000000 -0500 @@ 
> -4358,7 +4358,7 @@ F:	drivers/crypto/nx/
> 
> IBM Power 842 compression accelerator -M:	Robert Jennings 
> <rcj@linux.vnet.ibm.com> +M:	Nathan Fontenot 
> <nfont@linux.vnet.ibm.com> S:	Supported F: 
> drivers/crypto/nx/nx-842.c F:	include/linux/nx842.h @@ -4374,12 
> +4374,18 @@ S:	Supported F:	drivers/net/ethernet/ibm/ibmveth.*
> 
> -IBM Power Virtual SCSI/FC Device Drivers -M:	Robert Jennings 
> <rcj@linux.vnet.ibm.com> +IBM Power Virtual SCSI Device Drivers
> +M: Nathan Fontenot <nfont@linux.vnet.ibm.com> L: 
> linux-scsi@vger.kernel.org S:	Supported -F:	drivers/scsi/ibmvscsi/
>  -X:	drivers/scsi/ibmvscsi/ibmvstgt.c +F: 
> drivers/scsi/ibmvscsi/ibmvscsi* +F:	drivers/scsi/ibmvscsi/viosrp.h
>  + +IBM Power Virtual FC Device Drivers +M:	Brian King 
> <brking@linux.vnet.ibm.com> +L:	linux-scsi@vger.kernel.org +S: 
> Supported +F:	drivers/scsi/ibmvscsi/ibmvfc*
> 
> IBM ServeRAID RAID DRIVER P:	Jack Hammer
> 
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCgAGBQJTSA1/AAoJEHQMPZ7t8u1zbmwQAJXdfa1pObeOpukcuE924zGH
jKxeDsFSLSrkxltO7vVMZ/y2LsKJtOaNXy1GzSqX7y3TbaDv2hWYi+GcI6/AlBl+
cgTtMBfYmSUpyuOxEdDzkj4KRx8cF02V0ajCcCqkwTqwvDw5JWBR3/sjDTAvYhes
RzCv3Fl6F3Nf0ksTmmmUxlAmXUITH++4paYTZjrTW2N4YVUKVVzszr4K0dFqqqlW
Ffi/brOXPF7ItfdL4/cEm5j2cZPh/zMLHJb24z67WMmzhCIUELzBjlEFRsBalaz/
X+/pKED01KqNiOpWOLR7FKWZlNkiHV2ZB9QxoUAsepI/s94TxOK94nNHiT6feunG
5WQjrwiWYC2ntG/arNITtz/t+Hs0OKsAvT5mCQ4W+e+UzHB/61zeN3p2/avrA0H6
A33yN2BeHkUyR3ra4uzhn+Sx2nOJvArMNGrnw+LAxrxg17ymE7qGvAqGmDExeTRl
dLJv58B94QlchIgApuESQ4pLGvftvgT0bE/34DgWcTIBzQyTneTn5UTCOYR9h6hA
wpDPmujlt5aEEb2Pm11pJSJ7lvY8MoPOqyc7aHWPkz7t6qfKEdJ8IquRFAyqi+/6
MeiinUCUW1Tp4gif+sy+Dc8UIsMIniUDeyA0//aWZCkA+CfF++P89WWdke/c2t+X
otp+JW8ZqTgHZi1DUuiv
=TcEI
-----END PGP SIGNATURE-----
