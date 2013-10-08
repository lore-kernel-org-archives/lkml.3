Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755102Ab3JHObk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 10:31:40 -0400
Received: from smtp.citrix.com ([66.165.176.89]:39720 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752623Ab3JHObj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 10:31:39 -0400
X-IronPort-AV: E=Sophos;i="4.90,1056,1371081600"; 
   d="scan'208";a="61487870"
Date: Tue, 8 Oct 2013 15:30:49 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Rob Herring <robherring2@gmail.com>
CC: <linux-kernel@vger.kernel.org>, <stefano.stabellini@eu.citrix.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Leonidas Da Silva Barbosa <leosilva@linux.vnet.ibm.com>,
        Ashley Lai <ashley@ashleylai.com>, Rajiv Andrade <mail@srajiv.net>,
        Marcel Selhorst <tpmdd@selhorst.net>, Sirrix AG <tpmdd@sirrix.com>,
        <tpmdd-devel@lists.sourceforge.net>
Subject: Re: [PATCH] tpm: xen-tpmfront: fix missing declaration of
 xen_domain
In-Reply-To: <1381182353-12449-1-git-send-email-robherring2@gmail.com>
Message-ID: <alpine.DEB.2.02.1310081530340.26077@kaball.uk.xensource.com>
References: <1381182353-12449-1-git-send-email-robherring2@gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="1342847746-19982471-1381242649=:26077"
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--1342847746-19982471-1381242649=:26077
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Mon, 7 Oct 2013, Rob Herring wrote:
> From: Rob Herring <rob.herring@calxeda.com>
>=20
> xen-tpmfront fails to build on arm64 with the following error:
>=20
> drivers/char/tpm/xen-tpmfront.c: In function =E2=80=98xen_tpmfront_init=
=E2=80=99:
> drivers/char/tpm/xen-tpmfront.c:422:2: error: implicit declaration of fun=
ction =E2=80=98xen_domain=E2=80=99 [-Werror=3Dimplicit-function-declaration=
]
>=20
> Add include of xen/xen.h to fix this.
>=20
> Signed-off-by: Rob Herring <rob.herring@calxeda.com>
> Cc: Leonidas Da Silva Barbosa <leosilva@linux.vnet.ibm.com>
> Cc: Ashley Lai <ashley@ashleylai.com>
> Cc: Rajiv Andrade <mail@srajiv.net>
> Cc: Marcel Selhorst <tpmdd@selhorst.net>
> Cc: Sirrix AG <tpmdd@sirrix.com>
> Cc: tpmdd-devel@lists.sourceforge.net

Thanks, added to my queue


>  drivers/char/tpm/xen-tpmfront.c | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/drivers/char/tpm/xen-tpmfront.c b/drivers/char/tpm/xen-tpmfr=
ont.c
> index 06189e5..94c280d 100644
> --- a/drivers/char/tpm/xen-tpmfront.c
> +++ b/drivers/char/tpm/xen-tpmfront.c
> @@ -10,6 +10,7 @@
>  #include <linux/errno.h>
>  #include <linux/err.h>
>  #include <linux/interrupt.h>
> +#include <xen/xen.h>
>  #include <xen/events.h>
>  #include <xen/interface/io/tpmif.h>
>  #include <xen/grant_table.h>
> --=20
> 1.8.1.2
>=20
--1342847746-19982471-1381242649=:26077--
