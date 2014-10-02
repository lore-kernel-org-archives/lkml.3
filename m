Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754306AbaJBO5U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 10:57:20 -0400
Received: from g4t3425.houston.hp.com ([15.201.208.53]:33215 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753932AbaJBO5S convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 10:57:18 -0400
From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
To: Michael Opdenacker <michael.opdenacker@free-electrons.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "Scott.Benesh@pmcs.com" <Scott.Benesh@pmcs.com>
CC: "davem@davemloft.net" <davem@davemloft.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "joe@perches.com" <joe@perches.com>,
        "m.chehab@samsung.com" <m.chehab@samsung.com>,
        "crope@iki.fi" <crope@iki.fi>,
        "jg1.han@samsung.com" <jg1.han@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] MAINTAINERS: remove iss_storagedev@hp.com list
Thread-Topic: [PATCH] MAINTAINERS: remove iss_storagedev@hp.com list
Thread-Index: AQHP3hTxJB1MOjcsxU2y+XMSkP3wqpwc5Ivg
Date: Thu, 2 Oct 2014 14:56:34 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B402958CCA64E@G4W3202.americas.hpqcorp.net>
References: <1412235940-17628-1-git-send-email-michael.opdenacker@free-electrons.com>
In-Reply-To: <1412235940-17628-1-git-send-email-michael.opdenacker@free-electrons.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [16.210.48.37]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-
> owner@vger.kernel.org] On Behalf Of Michael Opdenacker
> Sent: Thursday, 02 October, 2014 2:46 AM
> To: akpm@linux-foundation.org
> Cc: davem@davemloft.net; gregkh@linuxfoundation.org; joe@perches.com;
> m.chehab@samsung.com; crope@iki.fi; jg1.han@samsung.com; linux-
> kernel@vger.kernel.org; scameron@beardog.cce.hp.com;
> mikem@beardog.cce.hp.com; Michael Opdenacker
> Subject: [PATCH] MAINTAINERS: remove iss_storagedev@hp.com list
> 
> This removes the iss_storagedev@hp.com mailing list from the MAINTAINERS
> file, as this address is now rejected by the HP mail server.
> 
> Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
> ---
>  MAINTAINERS | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 37054306dc9f..b0ed53797f43 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -4215,14 +4215,12 @@ F:	drivers/media/dvb-frontends/hd29l2*
> 
>  HEWLETT-PACKARD SMART2 RAID DRIVER
>  M:	Chirag Kantharia <chirag.kantharia@hp.com>
> -L:	iss_storagedev@hp.com
>  S:	Maintained
>  F:	Documentation/blockdev/cpqarray.txt
>  F:	drivers/block/cpqarray.*
> 
>  HEWLETT-PACKARD SMART ARRAY RAID DRIVER (hpsa)
>  M:	"Stephen M. Cameron" <scameron@beardog.cce.hp.com>
> -L:	iss_storagedev@hp.com
>  S:	Supported
>  F:	Documentation/scsi/hpsa.txt
>  F:	drivers/scsi/hpsa*.[ch]
> @@ -4231,7 +4229,6 @@ F:	include/uapi/linux/cciss*.h
> 
>  HEWLETT-PACKARD SMART CISS RAID DRIVER (cciss)
>  M:	Mike Miller <mike.miller@hp.com>
> -L:	iss_storagedev@hp.com
>  S:	Supported
>  F:	Documentation/blockdev/cciss.txt
>  F:	drivers/block/cciss*

NAK - that address is still valid; I just tested it from my gmail
account.  In fact, that's the only working email address of all
of those listed.  Chirag, Stephen, and Mike are no longer at HP.

I'll prod PMC-Sierra to send an update to MAINTAINERS.

---
Rob Elliott    HP Server Storage




