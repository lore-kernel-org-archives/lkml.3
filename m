Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753229AbaIOGiZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 02:38:25 -0400
Received: from ozlabs.org ([103.22.144.67]:41713 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751540AbaIOGiX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 02:38:23 -0400
Date: Mon, 15 Sep 2014 16:38:13 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Behan Webster <behanw@converseincode.com>,
        <llvmlinux@lists.linuxfoundation.org>,
        Wim Van Sebroeck <wim@iguana.be>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mark Charlebois <charlebm@gmail.com>, Rob Clark <robdclark@gmail.com>
Subject: linux-next: manual merge of the llvmlinux tree with the  tree
Message-ID: <20140915163813.490886b4@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/qxA6LJAdmVkQvJWDMl1+fn+"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/qxA6LJAdmVkQvJWDMl1+fn+
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the llvmlinux tree got a conflict in
drivers/gpu/drm/msm/hdmi/hdmi.c between commit fc886107c556 ("drm/msm:
Change nested function to static function") from the watchdog tree and
commit 8f2c494adad0 ("msm, hdmi: LLVMLinux: Remove nested function from
HDMI driver") from the llvmlinux tree.

I fixed it up (these patches are doing the same thing, so I used the
version in the watchdog tree) and can carry the fix as necessary (no
action is required).

P.S. Behan, I noticed that the llvmlinux patch has no Signed-off-by
from you even though you committed it ...
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/qxA6LJAdmVkQvJWDMl1+fn+
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUFoldAAoJEMDTa8Ir7ZwVqK0P/iX7t42ZJcbgUwyAxCX1Wg5w
LaZCC4D9UVEVROVwf+b4Bkg7rGErndyrUwSV6ps4xwR3ET0b1KJ3iI0eq3O0aRTt
acqWFohsT5xSqtzgRaCCfXrDYi423X9R2hnsvO4cccwp4QGAHCWibtLIKL9G5tAW
dajZYvWwnCBru86RXqXvm7HkWwyU8hlPSXjKNwmGBmcF7M09sx56kzlTH77a/tsr
YzwVvsy9QpcN/gqyqXQ3NqkjtOPBoyqpdUyNsHwvwa/HA5wo+FZr/VzKU9VwrJDq
0NhWM8G4dioeeuOWjO/njWSQHr/ruhN8O24GJ27Vp5C33qDfuu1kTY9vMEwhAX8+
QbivyHH6Kj2Kuqcto7WGSefgS4kyMHRuhDDUimsMgyv5PA1W8GCNbLN+QKXX8ySM
loFI/PQyb7kt7qPoxiFXk2KZdfwKW/CQEA0dCreUyuWcnKWzmzDNFcNWQyvtrxSx
Mdtl1yvpsNSdGE+612ITBxmnTl+SMH5bGh4yiq5y+vdBpwfpGhJfCgzh36AuV5m8
k9+XSIJWfq3IE9foLFSw8BvzcxTtJtRY+o+x7A0i6njDhlcik2gaUkwRIGHuXH3R
Y/CDaisiuvlP6FxO8GI1I6m8zTj/C3SX+Xt24BtTUlOnz+QL3S4jsQXTM+76nQTR
eUMv9Bl00TIKLjwb/U4U
=aLQH
-----END PGP SIGNATURE-----

--Sig_/qxA6LJAdmVkQvJWDMl1+fn+--
