Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752859Ab3G2A1A (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jul 2013 20:27:00 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:57735 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753019Ab3G2A0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jul 2013 20:26:52 -0400
Date: Mon, 29 Jul 2013 10:26:42 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dave Airlie <airlied@gmail.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: problem fetching the drm-intel-fixes tree
Message-Id: <20130729102642.4f1bf9d49a95f5c3dee87b37@canb.auug.org.au>
In-Reply-To: <CAPM=9txKODStMCnLRjFKh4y7v8wijDsyMEHZvgdjjZoc7HQOug@mail.gmail.com>
References: <20130729100843.8d129b9953ed39e55e1d5a31@canb.auug.org.au>
	<CAPM=9txKODStMCnLRjFKh4y7v8wijDsyMEHZvgdjjZoc7HQOug@mail.gmail.com>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__29_Jul_2013_10_26_42_+1000_3Plo.flWVrPYw83N"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__29_Jul_2013_10_26_42_+1000_3Plo.flWVrPYw83N
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

On Mon, 29 Jul 2013 10:15:50 +1000 Dave Airlie <airlied@gmail.com> wrote:
>
> > Trying to fetch the drm-intel-fixes tree
> > (git://people.freedesktop.org/~danvet/drm-intel#drm-intel-fixes) this
> > morning produced this error:
>=20
> There is some issue with personal fdo repos at the moment and anon git,
>=20
> I'll ask admin to look into it.

Thanks.  In the mean time, I will use what I fetched on Friday.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__29_Jul_2013_10_26_42_+1000_3Plo.flWVrPYw83N
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJR9bbJAAoJEECxmPOUX5FEVmQP/16N/8hKJL4H8cI10H8VLZ33
kO2hOefgDYkUcV1pc8unK7Rn4bef0W5FGfWzLx7aLlCtIqLLODZhBgHte5Iemm5h
3VlBXcRn6hZuMNyZIVFcVkL1P0vvmNwRsvDfkzRiGRl9dHFz/2vrQWMpw25HYjlB
Zdqnd0DO/fd14w9XhefYjl4lsPDTbXBhOqZbDhHjLRRmC07WONoQvOIhW5nZ2v1N
6Ui4k2eJIUEutwGXWktbCaRBST/xK4x6/DEPvg1uO/7N6LMHso15j6pllUAUmfqe
NrTL5h4eVYiqUx98p/EOy7+j6hRAg4g+QvBk9iVuarQz/5g9F5yBHzHU2JI2TSP4
tMa5xdhTlUTzHTdVHORn4N3LhXAJizn0MbrXlFnFV0ISLimMY7xM5elJRLsb37hQ
6sxLrZkJVdhug6CsVR8ZcXXndpiABXlW7q9BUQzWiimvr8scgzfhFwp7aXxOaj+d
RUhVu1ESqeqo9tr3C9CV0lHEaXitoftvhpm4ptfL5ZGehngkudGtKamUL+OvKazQ
lbH+8Wu2omLlvlRuNNYG2dlIDKg+ONVCJp0EHf1qlKSKVoC5c/scus0uaPfLszeS
w2KLTJX26fGmRhRoQ1NXaHppbNzKWJTUTsI3tfdpbd1Eq4FiRbntaCptGGLDNWtQ
Oc4nClR/x3d2dcQ3e5Jt
=kuV6
-----END PGP SIGNATURE-----

--Signature=_Mon__29_Jul_2013_10_26_42_+1000_3Plo.flWVrPYw83N--
