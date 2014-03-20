Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760114AbaCTWZx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 18:25:53 -0400
Received: from ozlabs.org ([203.10.76.45]:41062 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759932AbaCTWZr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 18:25:47 -0400
Date: Fri, 21 Mar 2014 09:25:41 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: James Morris <jmorris@namei.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paul Moore <pmoore@redhat.com>
Subject: linux-next: empty commit in the security tree
Message-Id: <20140321092541.77ae84b831cc71b1318d6f12@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__21_Mar_2014_09_25_41_+1100_gNv0mN.2Qx6wjY62"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__21_Mar_2014_09_25_41_+1100_gNv0mN.2Qx6wjY62
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi James,

I noticed this commit in the security tree this morning:

commit 2c5f5c9a1d1b3559cbbda8e014706eb359566c00
Author: Paul Moore <pmoore@redhat.com>
Date:   Wed Mar 19 16:46:04 2014 -0400

    selinux: fix the output of ./scripts/get_maintainer.pl for SELinux
   =20
It has no changes, just a commit message.  Did something go missing?

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__21_Mar_2014_09_25_41_+1100_gNv0mN.2Qx6wjY62
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTK2rpAAoJEMDTa8Ir7ZwVMfgP/3ViAztOPkepit9mH+OvxnHI
jw9t5NsuvcJ7dn4MotVNy03FveYg4Ih3cIMQVSfsucSHQTj6VlMOwgJ+URuZ4Y1i
A4D0pQ5388PGsWcG2mvi7QviixJ6Q1gAhyGIDFWmFCJg5xIOoDTMyq17YuWC6Pfb
Nlg+yolsMZEBW/pWndF1maByEAqjAl1+hWq+/bBh5j0HMoV9D3T3jeD0iAqxHfKA
QP52cP8lrtD7SD/x/6Jo8SkM+xYBCq7VAX1ieg8KOrMy+nojZ0tErHwHj3f+lPFE
ynWIT94moZ3JgRSxDwrENHWOYmB59mdyB9xph09MXPHi/WUpYFr7lR5Np2vOGhxf
bu3GjNai2wkZsfrUSJ2fa2R/GaE0x9K7/7aE0/gXWVIn0raxjBRoM7EdgK0F5ZB4
+zB6ExKJUSvPFOV8XIMvPcIBXfkoB1fT5w7+1NtdEo9S5OAlvd+r8ueHFSoUAuXb
+vurQ/542/z5r6yicDzBoWw0YN+weZKMQTr+Yfu7YGwKP9jvzv/Lc3MCljdCmoz7
AOIaDcN2+rKN+5qid3wqGDy6MEU0pnN4rGQoAth59nek1Ia1zlvCBz8XQA9oR9po
edPsYerivtopGbGl1Pfrvg/wlran+OAM/uRTQwxeJbSFlzGLVJqUuUicWB1NlMbz
3wuKgYeO/sTKutwV8gIc
=Iq9S
-----END PGP SIGNATURE-----

--Signature=_Fri__21_Mar_2014_09_25_41_+1100_gNv0mN.2Qx6wjY62--
