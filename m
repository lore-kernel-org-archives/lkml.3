Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753083AbaC0DiG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 23:38:06 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:60806 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751658AbaC0DiD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 23:38:03 -0400
Date: Wed, 26 Mar 2014 22:36:01 -0500
From: Felipe Balbi <balbi@ti.com>
To: Peter Hurley <peter@hurleysoftware.com>
CC: <balbi@ti.com>, Greg KH <gregkh@linuxfoundation.org>,
        Marcel Holtmann <marcel@holtmann.org>, <linux-serial@vger.kernel.org>,
        <linux-bluetooth@vger.kernel.org>, <m-karicheri2@ti.com>,
        <b32955@freescale.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 09/11] bluetooth: hci_ldisc: fix deadlock condition
Message-ID: <20140327033601.GA13038@saruman.home>
Reply-To: <balbi@ti.com>
References: <1395343807-21618-1-git-send-email-balbi@ti.com>
 <1395343807-21618-9-git-send-email-balbi@ti.com>
 <53337513.1010708@hurleysoftware.com>
 <20140327020909.GA11651@saruman.home>
 <53338ADF.3060803@hurleysoftware.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TB36FDmn/VVEgNH/"
Content-Disposition: inline
In-Reply-To: <53338ADF.3060803@hurleysoftware.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--TB36FDmn/VVEgNH/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Mar 26, 2014 at 10:20:15PM -0400, Peter Hurley wrote:
> >>You may want to build on top of this patch split handling;
> >>I noticed some of the protocol drivers are calling
> >>hci_uart_tx_wakeup() from work functions already (so don't
> >>need to schedule another work...)
> >
> >I don't think that should be part of $subject, though.
>=20
> I don't understand what you mean here.

it seemed, at first, like you suggested to redo this patch modifying the
protocol drivers to avoid two workqueues. But now that I read it again
you _did_ write "on top of this patch".

--=20
balbi

--TB36FDmn/VVEgNH/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTM5yhAAoJEIaOsuA1yqREJmwP/RCH5cxTPO9r3kfm72rgeDPY
ofFEK3bLEQ+fmVQloQAGbgE+8/ZodxydZb/8m8i8D/CHASG/hN/94DOaOw3Vf1wg
njdjW2LcdErJ0TAHcoaxbjosJwmyOWU5L6SM7/lj2/DDqXaRnCURA7QoneIQhfnM
QTlePNjLxSpB5meg0j+KI4IrbJeQe/gMAhfcvnVL6P1r2f1LN8lGyH20t9u5+zTd
mQ9qz+rBs7wH+cEm8C2hJ/0blyznGFT1mMClcxAS3Zswn50JiNiPuT75gxZgTgLh
xWO1UlUfj611xT/RjQhPWbsuFAJ6HvAjZSefAC+TdG62m9GhoXJ9KeLBnaGnryhV
pBlXI+jvDX8diyt+c6Gavc4tK964nGsPmNIgfsrg4J3/FIABzt/U7KthB9Xs9kth
WnoAIHhYlzeaf1Hp0TcgyNhHQFov1xu/1rMLnJvrdWouT6PS4jw2yvJPjOTZDdOn
hs8N6/9UQVUqbaQepmb49PbWyf1idwjXBCtg4Xawc5N3phsBWqn4LF2Cjka0PbWA
anTmYKNAk2uCe6AGAZY9EsD2xUxnrZMsbU8zWsCLfTMnh9Ryn573oJF9D5OOoZa/
lrLo4zfe+1SWEClsuuBIFmab+TN6pfsVDTNHXWGioovFMYnbTq5anNTeAOWu52xw
n8xKzNNluPIGtevpX4u9
=n1X3
-----END PGP SIGNATURE-----

--TB36FDmn/VVEgNH/--
