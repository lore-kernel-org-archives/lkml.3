Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752599AbaIIV0Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 17:26:16 -0400
Received: from omr2.cc.vt.edu ([198.82.141.100]:49840 "EHLO omr2.cc.vt.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751176AbaIIV0N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 17:26:13 -0400
X-Mailer: exmh version 2.8.0 04/21/2012 with nmh-1.6+dev
To: Ley Foon Tan <lftan@altera.com>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, lftan.linux@gmail.com,
        cltang@codesourcery.com
Subject: Re: [PATCH v3 25/29] nios2: Module support
In-Reply-To: Your message of "Mon, 08 Sep 2014 17:22:36 +0800."
             <1410168160-3624-26-git-send-email-lftan@altera.com>
From: Valdis.Kletnieks@vt.edu
References: <1410168160-3624-1-git-send-email-lftan@altera.com>
            <1410168160-3624-26-git-send-email-lftan@altera.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1410297958_3387P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 09 Sep 2014 17:25:58 -0400
Message-ID: <75377.1410297958@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1410297958_3387P
Content-Type: text/plain; charset=us-ascii

On Mon, 08 Sep 2014 17:22:36 +0800, Ley Foon Tan said:
> This patch adds support for loadable modules.
>
> Signed-off-by: Ley Foon Tan <lftan@altera.com>

> +/*
> + * Modules should NOT be allocated with kmalloc for (obvious) reasons.
> + * But we do it for now to avoid relocation issues. CALL26/PCREL26 cannot reach
> + * from 0x80000000 (vmalloc area) to 0xc00000000 (kernel) (kmalloc returns
> + * addresses in 0xc0000000)
> + */

That's a nice scary comment to see. :)

What's the long-term plan here?

--==_Exmh_1410297958_3387P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBVA9wZgdmEQWDXROgAQLPnhAAnAPmjPRb6kVb+COoyqcTT8eU2H2FC1N+
a4YnhzT1D+VI9MBar4uWi/kXi9KNonJZpG06UF6/z9hTfkD8NzL++MMRY1PP7qMJ
uJM3NCMRnXtZFUv2v0vlBB3aEDcHcCK6pG/GeSe6tzeFXXMfBnKggavq/xmg3mq0
qutlKnVa4gRAJ6MgmB0sbtt1exbQ2yr5Jb1pCP4/RlApOXn+EmzriO6A+jP3EZjr
j1+B6LgixOetZ44RhNLLB3Zi0xe0h5bt0bDjjMJhWB9obMbN9iPAcO1zZogxGkKF
SdGiNue1swoqUkvpk/B4LfJnaFkSTfvZqXAm4WfnKMMZeZKq/Fs0Uj1jnssXtzMT
xu9RFVJhdcf1vcK60prLMttk6P+CKreU9c74GGX/j3LeaRwscRsW9x1qeD0r6Ztx
uQcGb8znX4jWm+EAAgrdCR8jkQ3KmmrwknG47V3zrdiAh5Yzs+ubpIGGgieYoIrv
LkZEYksd+BB79361ihzfryzm6gleb3iZOp+KLnE97D+PoSPU8AjKbwjL4bcf0QzG
iTZXlLhSPwViA5+5RDit+E53td80wAmi7FSU2+U5wXFFj/Mh60yScwgtyJOiGpF/
x0B11XsyDlcoNyp+60tVT9whMh5t4z/DutWERGa3FJI5DO3pqtAeKgNJOXHM4ChS
NWKSbTNkKiA=
=5sxg
-----END PGP SIGNATURE-----

--==_Exmh_1410297958_3387P--
