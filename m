Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760773Ab3DBGaE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 02:30:04 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:48229 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760205Ab3DBGaC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 02:30:02 -0400
Date: Tue, 2 Apr 2013 17:29:50 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>, Arnd Bergmann <arnd@arndb.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Richard Weinberger <richard@nod.at>
Subject: linux-next: build failure after merge of the char-misc tree
Message-Id: <20130402172950.1fd8d6653a4c79b319945212@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__2_Apr_2013_17_29_50_+1100_6QBsxo5aodd/GpJr"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__2_Apr_2013_17_29_50_+1100_6QBsxo5aodd/GpJr
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the char-misc tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/misc/cs5535-mfgpt.c:30:3: warning: missing terminating " character =
[enabled by default]
drivers/misc/cs5535-mfgpt.c:31:31: warning: missing terminating " character=
 [enabled by default]
drivers/misc/cs5535-mfgpt.c:384:0: error: unterminated argument list invoki=
ng macro "MODULE_PARM_DESC"
drivers/misc/cs5535-mfgpt.c:27:1: error: expected '=3D', ',', ';', 'asm' or=
 '__attribute__' at end of input

Caused by commit 945480b159aa ("cs5535-mfgpt: Add another reset method").

I have used the char-misc tree from next-20130328 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au


--Signature=_Tue__2_Apr_2013_17_29_50_+1100_6QBsxo5aodd/GpJr
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRWnreAAoJEECxmPOUX5FEhlUP/24y8ydJOE6G+fqmY6bqM99j
dWkCNl6GCpG/3acPm0N4faWtBZIG5DHd0JUbnbfQRcm1nkhurug78K5lECItyvls
JAD8R3Q9FSnb1k+FYuQqa0LsEEJDNKCEH8EMmQE5ZoTo/Hg4qrurqCAyui7aNVvu
66mjtBSJ6bSYkzBgJW1LwmVXIFazYADJOckonjR7pijGALSvWuFLdCre+U7aw16h
zBJcfm3Q7L9/yQyVnZ26sAsfjV1c3d4V+x+X7oMTczZQ9w7tAdZdT+KtHhqVPxSo
pe+Md8gE2wjK8iZyGdtey6JUIBvHKduzx+TxYoPtDR5wcu2vQoL0GBdlQAv+afK1
cAHFigWQPDkBA9yazEMa3YCpjFQYe9nwQAzRnOtnB25c/bEYF98hM2liGDbCU2d9
slIhiJC05ojoJO3t05l4inL38QKH85QHWOPUb9yb+99RQT3ldoHoCDZH8XDKWUzy
W/LkOrDM++/cb+8B9o0Z3x2d15SnwjdE8DRCyhjR4jBv8ShyD1kK/BsUIcd/PG8E
lsFgK6ARl+0rhw0I7+9k1tgQOY7ZHAySq4zTEr7kP/UhASjUViQTXbZlmX28v++2
8tw4Qms7Ocv7CmoOmwstKbXUiyBaVXmdFnnGsFjdnyq5fzEIY7bFlZqsDD3icRRt
Lk7T25O/7i9dJfZGbphc
=1RDy
-----END PGP SIGNATURE-----

--Signature=_Tue__2_Apr_2013_17_29_50_+1100_6QBsxo5aodd/GpJr--
