Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752652AbaAFMxw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 07:53:52 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:47756 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750914AbaAFMxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 07:53:50 -0500
Date: Mon, 6 Jan 2014 12:53:44 +0000
From: Mark Brown <broonie@kernel.org>
To: Daniel Santos <daniel.santos@pobox.com>
Cc: linux-spi <linux-spi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Message-ID: <20140106125344.GR31886@sirena.org.uk>
References: <1388965166-27334-1-git-send-email-daniel.santos@pobox.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2m+IWTtMCMjzK22K"
Content-Disposition: inline
In-Reply-To: <1388965166-27334-1-git-send-email-daniel.santos@pobox.com>
X-Cookie: Go climb a gravity well!
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: spidev: fix hang when transfer_one_message fails
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2m+IWTtMCMjzK22K
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Jan 05, 2014 at 05:39:26PM -0600, danielfsantos@att.net wrote:
> This corrects a problem in spi_pump_messages() that leads to an spi
> message hanging forever when a call to transfer_one_message() fails.
> This failure occurs in my MCP2210 driver when the cs_change bit is set
> on the last transfer in a message, an operation which the hardware does
> not support.

Applied, thanks.

--2m+IWTtMCMjzK22K
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSyqdUAAoJELSic+t+oim9ulgP/RL2cdeIakKKkM1ZzW/lTpI8
uTNIu/xa8hLXytBql2o9BirYs/2+4Q5LTkfCAZowYAPYcZHMLIva9JMBbT4n4hLr
9rpIMrdO3MM5NV3GlvvGXjfXoLK7FFS0yWt0RdhFXMr9ND0b4UZOKKL2r0NwE11V
yweJp2s96j52UVWGRFY1zmaooZ0HmRoD4AtZAuUjSrozaRPG+UDpzBtG9MF/CGTe
1d+n6iEFL4ml1LcQ+EOAluZqObpcookNYkhNjxegEhkLfJ40tJoGjtyeXf45W7S9
84WyX2WfUJuGvNgzMQvXyoQzUIIZ8elzAtPtdV0uQd/fePm+7mPxfaHOtlOLqbTU
kfFUvQiwdGzxo9CEafdUp2hMmqWDVa2MTzqfaJ8iVil4X4UtxCqMMMoLiT5JK+Ps
U69f+TqI0FZ0WG5bnbD9OD8BRuYfq82LpZ8s+uXV4beh/K0CpVX8bHkVodNsOZwr
qeNhXrl6blNMB8y7mhjljVqGTtB+64d8JmYIDOR8jsrHBHOcUD2lJIVeiPbxl2wc
oVg5ZXFPbg0mlCK31Ps8OdvqnrQZjtJ/Qcv/jYvZ5Uiz/WfDfysDzYz0DemkhTk0
3vuDnMRya7QVA/2PIy7e4NbT2MhhXEhNNI2hSZp6caHZvRGVKSyjbwtcwfGKd7xU
fO/aVuZnI/NMK2G9SgHy
=D+4I
-----END PGP SIGNATURE-----

--2m+IWTtMCMjzK22K--
