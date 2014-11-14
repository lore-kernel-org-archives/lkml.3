Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755195AbaKNWoO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 17:44:14 -0500
Received: from mail.kernel.org ([198.145.19.201]:48709 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754644AbaKNWoM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 17:44:12 -0500
Date: Fri, 14 Nov 2014 23:44:07 +0100
From: Sebastian Reichel <sre@kernel.org>
To: Dmitry Torokhov <dtor@chromium.org>
Cc: Pavel Machek <pavel@ucw.cz>,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HIS: nokia-modem: fix error handling of
 irq_of_parse_and_map
Message-ID: <20141114224407.GB18566@earth.universe>
References: <20141114220637.GA33546@dtor-ws>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="1LKvkjL3sHcu1TtY"
Content-Disposition: inline
In-Reply-To: <20141114220637.GA33546@dtor-ws>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--1LKvkjL3sHcu1TtY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 14, 2014 at 02:06:37PM -0800, Dmitry Torokhov wrote:
> Return value of irq_of_parse_and_map() is unsigned int, with 0
> indicating failure, so testing for negative result never works.
>=20
> Signed-off-by: Dmitry Torokhov <dtor@chromium.org>

https://git.kernel.org/cgit/linux/kernel/git/sre/linux-hsi.git/commit/?h=3D=
for-next&id=3Dd95dc9e388104488d0f5a5969c435e601840da2e

-- Sebastian

--1LKvkjL3sHcu1TtY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJUZoW3AAoJENju1/PIO/qaXekP/2YDxp1v80i7XGao5krh1kEI
xJ56NxaFhIdZ6BxAwtjc1BM8gzsrdDQ/gRZBWbOeq1yI33rE4rOlCPlhjiV5i73G
DLlNpHQeljMRb3mlYEdiYhHk+5/F0mydfb0EP+DtXyJF0orYjzTyfpXFy6Qpn7oh
HL9HV5vX7k7qC7usOmGisi9LT26g+Jb9Gb9fVNyxwZMJwP14UzsiUOnGgnRxmhjD
C4JXG8m8R3Sb641EW+SPgbBxj01/mzIFNy585HszBbtuWOclVn6xid3yL0xaRpcq
UOIuV+iiasTj6FOwZMesjxaDs7ozIfyg1UgSdIku5szI/nWSZTIZAtnWM3CXRP+k
R6rFrbwcVyxQdPVAgU8k3RcJtzlPT4ZQ3F4ZvYEtlSThmNerP5eXhl27m8O7k5G9
2bF7onJTC2rxVpoCBDQ+upf4GhhEcK37mFjuckAtVzyi76t7GrHZUYS4YYUqhnS0
CcIL0hTGjg4NUs3WVNt/dH2wkYNKHTjRYshbuX8zNWqC6z/wPOiHZp/YDk4eMgLR
h/zfCVZwl5/4qtZEYGufWnOi6dcyOKJfHlz5IsCycVyoOfnCdgoheASgepw4aP71
z4S3qTruespH2Ca/UOKklPTVKrOX12hu30lhiI+YkGG1btp5FtElSyLSN2hkW+nw
ynMp9vr9rX/NJOE55oAZ
=SmAX
-----END PGP SIGNATURE-----

--1LKvkjL3sHcu1TtY--
