Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756435Ab3EODUS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 23:20:18 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:38821 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755329Ab3EODUQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 23:20:16 -0400
Date: Wed, 15 May 2013 13:20:01 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Eric Paris <eparis@redhat.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Richard Guy Briggs <rgb@redhat.com>
Subject: linux-next: build warning after merge of the final tree (in Linus'
 tree)
Message-Id: <20130515132001.6cc824ba42106db973f90991@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.17; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__15_May_2013_13_20_01_+1000_FEmWk2Sh495lDqoN"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__15_May_2013_13_20_01_+1000_FEmWk2Sh495lDqoN
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi ,

After merging the final tree, today's linux-next build (i386 defconfig)
produced this warning:

kernel/auditfilter.c: In function 'audit_data_to_entry':
kernel/auditfilter.c:426:3: warning: this decimal constant is unsigned only=
 in ISO C90 [enabled by default]

Introduced by commit 780a7654cee8 ("audit: Make testing for a valid
loginuid explicit") from Linus' tree.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__15_May_2013_13_20_01_+1000_FEmWk2Sh495lDqoN
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRkv7hAAoJEECxmPOUX5FE1p0P/jIK6kHTavkEZ3lTxHxeojQh
x8DoI6YvL6IpzXDcAMLAuSZjI0xgkwqrqfrqaMFEuzcgcj2pmocrlSQnbTwyV7Yi
hLdT711fwh24eZ5CyO5LORSfQt7kHpuR6VS1JfsWH3L1YQGWL73+DzC07u6x04Ad
7rw1N7+SYhXgUB4esxLdc2hHvu4fd0O0yqpPPV4OSEr7SqKB8ADmGWRFrOchUFRg
mPraEa5G2TVsELCbH6YB20B72tAXhFbrFqETsontkZUwU4+TF+f0E2jYvr1D4Jrs
jxq4HqyutL1KeU9BbAXfXPleorUoYzAZt3EyuLdWu02vKTkLtiWwaQQX7+8jI2au
PaYPPjHtdrT1a9ThL7UY0zHW60dgc6ylncDxjqfiez5qDjwla1KNOjKeVwrWrKM9
FPtrlyZ/JveO/Da+fGorcxJaFwmeXPYpcxr0HIRilfsXA8DsDE3yS3NU2G7CnXQi
qq/Kl9bgXLvKB7pCG4u7N6NKWXIQABodBgQXwmjMesaK5HwZBc1ojN4GAo/X0EEQ
3N7Xokp7JhUjPIR6V5qkKWxTxNVSOBC/MelEx97X86+UINWgHC9f0bUwFABnbOgF
3YbLI4eD7GskJK0D32Xm2NC1mXL2AFWXIL/LWR6Bc38hY9qSMy4CrhsfMXah4Nk2
N8UuGx2dx51GynZ/QoC+
=iRv6
-----END PGP SIGNATURE-----

--Signature=_Wed__15_May_2013_13_20_01_+1000_FEmWk2Sh495lDqoN--
