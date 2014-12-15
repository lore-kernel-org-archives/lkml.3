Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751017AbaLOFJS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 00:09:18 -0500
Received: from ozlabs.org ([103.22.144.67]:33635 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750736AbaLOFJQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 00:09:16 -0500
Date: Mon, 15 Dec 2014 16:09:09 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: Wim Van Sebroeck <wim@iguana.be>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiubo Li <Li.Xiubo@freescale.com>,
        Wolfram Sang <wsa@the-dreams.de>
Subject: Re: linux-next: manual merge of the driver-core tree with the
 watchdog tree
Message-ID: <20141215160909.24c2e73b@canb.auug.org.au>
In-Reply-To: <20141215043506.GB3949@kroah.com>
References: <20141215141114.575b8767@canb.auug.org.au>
	<20141215043506.GB3949@kroah.com>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/zbOO6D84O3op/3wc/a/G68p"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/zbOO6D84O3op/3wc/a/G68p
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Greg,

On Sun, 14 Dec 2014 20:35:06 -0800 Greg KH <greg@kroah.com> wrote:
>
> How is this happening, nothing has changed in my trees, did something
> new get added to the watchdog tree?

Yep.

It would have been much easier on me (and maybe Linus) if those "drop
owner assignment from platform_drivers" patches had gone via their
respective maintainers ... just something to remember for next time.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/zbOO6D84O3op/3wc/a/G68p
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUjmz6AAoJEMDTa8Ir7ZwVC98P+gP25e/q3vgOMKrd0U4+ibEh
Y4z8iEPiLdN043DGCTT9N/DYn1FNXzqgujenARur9IRyb6q5mBkf5lCXKfAYNHh7
QCF5QcbZC3rGMHm+H4APmokoL/gsgvR7Oacn6ty0SDgdcitwHyTXQCwqTBqeosPU
kElxu1ZaKp89WgtAmgv5kJFVhlvpID3sBhtptEOAfpcjp859F1JByJfyQTcFGadw
SlRVF1YFVJgeFvTcFCiYZ3Zdvj/heUOys3DFLuqpKxbPbORNPdqjtDvDSaHybPc6
VF5BLways+ycYYILTxJXtRchVtjOVGifG66nAY7h5OphnAl3r8W/2MCZqOgMI3lj
K39xIJXlx+6KQtaNdSuDzfLbGnYvMpWyduK7nOyIqJpOOoKr7Hi4Hbtv+BbEWcuM
QDiAWDk7KUASy6ySpmi8xHTPH5cui/g+iUTw6xS7QLSFZtutDgSOvClh3OXgW7sf
GbB8M9I3Mu9YDt+ZoL3EDNb6HsBimiu6EEvoYdFddf1/HjE3hVsltONUj0PGx6ub
XbaqSMZVsT+m2uOTtuTNPI+X3cwcJANPXeLQ/nPpCBMcww+j+63VkvMCbbiiMTQc
mUxmRaAtbOzDUwGxBbs031BKVWdcmWtwYuEDRrQ38P069mB1lGPnSeD62l8HnG1R
/jsmVLI0db9pBNHlmpvd
=g+Jw
-----END PGP SIGNATURE-----

--Sig_/zbOO6D84O3op/3wc/a/G68p--
