Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754744AbaKENzH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 08:55:07 -0500
Received: from down.free-electrons.com ([37.187.137.238]:41752 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751198AbaKENzE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 08:55:04 -0500
Date: Wed, 5 Nov 2014 14:51:31 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Vinod Koul <vinod.koul@intel.com>
Cc: dmaengine@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/11] dmaengine: Cleanup chancnt
Message-ID: <20141105135131.GA2989@lukather>
References: <1413450063-23829-1-git-send-email-maxime.ripard@free-electrons.com>
 <20141016090346.GE1638@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XsQoSWH+UP9D9v3l"
Content-Disposition: inline
In-Reply-To: <20141016090346.GE1638@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--XsQoSWH+UP9D9v3l
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Vinod,

On Thu, Oct 16, 2014 at 02:33:46PM +0530, Vinod Koul wrote:
> On Thu, Oct 16, 2014 at 11:00:52AM +0200, Maxime Ripard wrote:
> > Hi everyone,
> >=20
> > As pointed out in the documentation thread [1], the chancnt variable
> > is filled during the driver registration in dma_async_device_register,
> > from the liste of channels that has been set.
> >=20
> > This serie removes the occurences of the drivers that set it in their
> > probe function.
> Barring the typos in the cover letter, series looks fine.

It's been 3 weeks already, and there's been no reviews justifying to
send a second version of the patch set.

Can we merge this in?

Thanks,
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--XsQoSWH+UP9D9v3l
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUWitjAAoJEBx+YmzsjxAgizwQAKmHIePrZOmL87voLW/9TRTk
DbEp5aSL04pqr0CYhaWk07yG7LIR4R98DQIIJupmWq1bpgPnLsDUtpkoy8XHraEC
DgBrrHyVJa/6B7wOliRrUP54OFg4YrVGNx1MaLLbGicsupWDD1Eue5Yiaa3O1OBF
kYgwoOoYGVVPc8+F0tMfeGKTXwORnG3do77Rl5H4BFHQx6m7r5zgrzBzA7Gas2ZZ
qezSbsprc3nmjYPzkow8dXFuOFaKLG8OEzJe4boJv3qkWcA7pVNqvOfQIo0njWeR
szDp9ZiPokhZDo0gQxw0ht00/LkKGng3HkivF5vDLSuZqxYVbOICZMP8A12QG59Q
4BA+V23S2DLem2OBWDFk6+6loxsfEI7yD5USQNMwjO/dBNYY7IpsXdw71mp5hS/M
E4I23POu+nmK9dgvbyZ1cZJi/LrNx0wcYcMdQZkwXOApmN3Jyq0abFyVj621gw8P
CkFewTUAp/JE2pMWUwLmXlRdo+2+xtno3R200sJ5nVdvoBVFCSoxXCdfAsA08Tz4
dbGdseTY2GmTGOVukJDhmpNU6Gnwc9TCba57w32mIvxaJQphHExJ7jJtJ/letT2f
JYZOATkBqUQ1b3/ql9HWqmzMnMsYvS0LmTT5Kzxv8s1rYE0sTJbL+/rBX9DF20kK
nE6yiMjJcOW/NJRQcpet
=56qH
-----END PGP SIGNATURE-----

--XsQoSWH+UP9D9v3l--
