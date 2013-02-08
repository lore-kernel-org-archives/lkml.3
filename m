Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760165Ab3BHO1i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 09:27:38 -0500
Received: from ngcobalt07.manitu.net ([217.11.48.107]:49956 "EHLO
	ngcobalt07.manitu.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758550Ab3BHO1h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 09:27:37 -0500
X-manitu-Original-Sender-IP: 127.0.0.1
X-manitu-Original-Receiver-Name: ngcobalt07.manitu.net
Date: Fri, 8 Feb 2013 15:27:24 +0100
From: Roland Eggner <edvx1@systemanalysen.net>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: tmhikaru@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: Linux 3.2.38
Message-ID: <20130208142724.GA31038@mobil.systemanalysen.net>
Reply-To: Roland Eggner <edvx1@systemanalysen.net>
Mail-Followup-To: Ben Hutchings <ben@decadent.org.uk>, tmhikaru@gmail.com,
	linux-kernel@vger.kernel.org
References: <1360160863.32217.30.camel@deadeye.wl.decadent.org.uk>
 <20130207173630.GA8355@roll>
 <1360285890.5374.76.camel@deadeye.wl.decadent.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TB36FDmn/VVEgNH/"
Content-Disposition: inline
In-Reply-To: <1360285890.5374.76.camel@deadeye.wl.decadent.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--TB36FDmn/VVEgNH/
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2013-02-08 Friday at 01:11 +0000 Ben Hutchings wrote:
> On Thu, 2013-02-07 at 12:36 -0500, tmhikaru@gmail.com wrote:
> > 	Hmm. I'm not sure what's going on here but ever since I upgraded to
> > this kernel my CPU use has always been at 100% - various apps (top, pid=
stat,
> > conky) give different reasons for this, conky&pidstat claims things like
> > X/the most active X application are cpu hogging, while top seems to thi=
nk
> > the majority of cpu use is being done by 'sys' - the interesting thing
> > though is that my loadaverage is staying very close to zero.
> >=20
> > 	I know that this is far from a useful bug report, but to be honest I
> > don't even know where to begin checking, so I'll start a git bisect of
> > 3.2.37 vs 3.2.38 tonight and see what happens.
>=20
> There weren't any scheduler changes in 3.2.38 so I can't make any better
> suggestion than to do that bisection.
>=20
> Ben.
>=20

Just an almost blind guess:

Colin Ian King (1):
      PCI: Allow pcie_aspm=3Dforce even when FADT indicates it is unsupport=
ed


--=20
Roland Eggner

--TB36FDmn/VVEgNH/
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAlEVC0sACgkQdN/hKfT7G/IQmgCgiHku0djkicxpXXQ3xuwhDbLv
hxIAn0wlqZmtJSQ9Cejn4uHqf21tiwZH
=VFcy
-----END PGP SIGNATURE-----

--TB36FDmn/VVEgNH/--
