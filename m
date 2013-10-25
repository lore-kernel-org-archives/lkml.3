Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755340Ab3JYC3R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 22:29:17 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:51623 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754056Ab3JYC3Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 22:29:16 -0400
Date: Thu, 24 Oct 2013 21:29:41 -0500
From: Felipe Balbi <balbi@ti.com>
To: Bjorn Helgaas <bhelgaas@google.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        <linux-kernel@vger.kernel.org>, Felipe Balbi <balbi@ti.com>
Subject: Re: [PATCH] device: Make dev_WARN/dev_WARN_ONCE print device as well
 as driver name
Message-ID: <20131025022941.GA2261@gimli>
Reply-To: <balbi@ti.com>
References: <20131024214233.12347.95711.stgit@bhelgaas-glaptop.roam.corp.google.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Kj7319i9nmIyA2yE"
Content-Disposition: inline
In-Reply-To: <20131024214233.12347.95711.stgit@bhelgaas-glaptop.roam.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Kj7319i9nmIyA2yE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 24, 2013 at 03:42:33PM -0600, Bjorn Helgaas wrote:
> dev_WARN() and dev_WARN_ONCE() are annoying because (1) they include
> only the driver name, not the device name, and (2) they print a spurious
> newline in the middle.  This results in messages like this that are less
> useful than they should be:
>=20
>   [   40.094995] Device pcieport
>   disabling already-disabled device
>=20
> This patch makes them work more like dev_printk().
>=20
> Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>

Pretty cool, much nicer output indeed :-)

Reviewed-by: Felipe Balbi <balbi@ti.com>

--=20
balbi

--Kj7319i9nmIyA2yE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJSadeUAAoJEIaOsuA1yqRE8IMQALNPQY6l+qBrPmCpQq3tPzYv
da4BGoxHNgcVm1AhLQAXLYPQBEaYUWrubEkczfFqlQqi9feCqzGjcxlhr5THNdaq
ndI9fCb8o+zduH1C74l9uDemtysu9IMIUOTKZ9RpTK7zM+iCqe62eAGCfWdUwuXB
Ocw61KZR9P9sKqlcAeIzKlWFMpU3eqr34Jx/yMAXxlvFC1ZwZ0BQAZAntsFN8HEV
blW/4nfbrEbUsWNs2SuO9RxIDi0JmacySUaYU/AbK6TVihU82USwLxJdI+YkkN+r
s2p2DtOqhPc6sOVkBqSUUXy46V4uTNE/TpEZDspG+twsm/0qwFkcNfAOa5yp1Zns
FCkfpW9J7xEtWHzumyLy8Bfkz9ui4B1bc1mQWOuI6738iwdCYHkDDWuvHN2BOQUD
8k+9ydQ7Ef9BEX+umtBy9ti/f7ygRk8d7ITuHMCtCbZrGImUAEEcF8kxTDV8dGcg
6jjxSZQ/kRXyos7w2DSVU360XbBen14pQjnP7weblOrtJpyEAosKSbgxrrAAmNUs
M+DKLG1+ISIBtaMtPl21iMB1U+uTaRYiPpvsYm1/ICKy8KAaEUkkOFTUG0eq3oPN
3rr0egNE8Nq+pzqjvivsOiQI66Pn/hpA96Z+zolKr/Ndl1fnkz93Gu7/NjWDinl1
li6OSucBsfOKzJUnOYCW
=2T0t
-----END PGP SIGNATURE-----

--Kj7319i9nmIyA2yE--
