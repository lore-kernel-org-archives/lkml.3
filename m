Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752870AbaKGSC3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 13:02:29 -0500
Received: from sauhun.de ([89.238.76.85]:55871 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751850AbaKGSC1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 13:02:27 -0500
Date: Fri, 7 Nov 2014 19:03:37 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thierry Reding <thierry.reding@gmail.com>
Subject: Re: [PATCH 2/3] i2c: core: Dispose OF IRQ mapping at client removal
 time
Message-ID: <20141107180337.GG3656@katana>
References: <1414677578-27412-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
 <1414677578-27412-3-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HB4mHL4PVvkpZAgW"
Content-Disposition: inline
In-Reply-To: <1414677578-27412-3-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--HB4mHL4PVvkpZAgW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 30, 2014 at 03:59:37PM +0200, Laurent Pinchart wrote:
> Clients instantiated from OF get an IRQ mapping created at device
> registration time. Dispose the mapping when the client is removed.
>=20
> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.co=
m>

Added stable and applied to for-current, thanks!


--HB4mHL4PVvkpZAgW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUXQl5AAoJEBQN5MwUoCm2Ui0P/jSzEwsDjCsMoeeOatPTqFGX
9wkRsWtpCpOKNTObyhbr3Tdq1SxA375h7IG5Uf7tgyTPzcuj5rjIDuDByaiHuGiC
hJrgk3QmGkJpsAllrrZrsVANlHDgDobFS50MIRV3UaJ3s/SjVPQWDvJgsOtiBrE2
J5loKiVvbltKNCh2D2EXlxLDHNS+5F7SQ3uDl517TbMd6nAsXmGVF2/v/DJtAKIz
sp/5AS+jpyQ5FmXvrfkwYqWAcGgdJ9VpBi5EF2VU6stARcnmVtDuoh4tB5UGEjzW
47HZZ48QKQ6psiunkIO2SDvZ5kBZJQLeAPqBcFeLXIMNcLKyt/StSOoq1rXQpenU
BiRGczTKBJcT+iEGgyinI0XfxUp03t1bY3Vtp6K35qj+m6RF8Zr7iSVIkVT7LO4+
b4K0UYL8ccxP/MP5lTeulThq9hrWdJY81Md7DIUrZWieIcP7tVMmbn1qhB4W8KWO
3ykW5p4t2n+OKd+mIm5pROrfoRSEUUp3pMg0l5szddMRz3zYrbynbikqMVeKHeVN
Pzxt4znsIF0r/JQqd7bVzJu4MuAHW+sc38nX6bcAmd+vqy4al6SWK0F6S7cDT2Vj
pG1ZvDHFP90Crf8V1uIxFObrC/k/FqhxsTzcVTWYlbwHqqa2zxlggDl88q20tOEH
rSl21MsQrwFHptOpBwpG
=tdaS
-----END PGP SIGNATURE-----

--HB4mHL4PVvkpZAgW--
