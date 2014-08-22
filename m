Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756499AbaHVO7j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 10:59:39 -0400
Received: from ozlabs.org ([103.22.144.67]:53511 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756303AbaHVO7i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 10:59:38 -0400
Date: Sat, 23 Aug 2014 00:59:25 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: error while fetching the mips tree
Message-ID: <20140823005925.159d4f58@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/E720twxdUSFEDsuo=BWFulU"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/E720twxdUSFEDsuo=BWFulU
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Ralf,

Fetching the mips tree produces this error:

fatal: unable to connect to git.linux-mips.org:
git.linux-mips.org[0: 78.24.191.183]: errno=3DConnection refused

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/E720twxdUSFEDsuo=BWFulU
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJT91rTAAoJEMDTa8Ir7ZwVoFMP/3yDxCI0blArLTPK9J8SgvqD
HvESmLwG6WOjlQn2lltCQD0qvEQ1HzGXLZFteZEqdEOKIuu2/idDTpzyUNqlk4sE
6WRSTL2szbzFAEebhQ1DrXoAcdqDFMSwFeKJh7FC74+YaDaJiMlZzW+DbFvrfET7
7LTAyltFo8m05kr687N24N2yBFUULn7Zsrdk92MXLjtTX/KzcBxAuazp+Djwsgtj
K7C/R5u0Fo2lYN7sl0Mhdss6o8HEwukM00wvfeolf3Ydpshg9p5EcWdWTli/AvuY
i70XL9l8qAfr8ct+fyqPBcXQTnYEiNEgJVjL+Q9D7weyh0QaC9OFNdOlaMYNcblF
qqgqaWyrHIG0oOueMA9X95R2usRmnYHxgqO4GWqKU+pzoWr4RV3yB5dFHHWOv12m
3o7vGgG7V+GKVehwldBQRhTxJLDydrhqU+M66A8vUYlXuUzXRrP7jlQ8wntc3kUt
0gCI8o/SFTe1D64hTtXNspLwFruI72s3XelKzpD0lZO/D8TG9OGiqGJvUk8NVWhP
0bXQ+28wxvD89HMhbp5xt1QhsQOqEYBOWOkDsHK91LZWzJIAABAf+KALogNGZVcg
E+Dlc0kcQUdwkoyvg2tMHm1ZYog3xdcIDQo8o32ypRXx405HoCi2lfgjazF56Hr9
AQ4ojZhugiIWFF3G9kfj
=pOF9
-----END PGP SIGNATURE-----

--Sig_/E720twxdUSFEDsuo=BWFulU--
