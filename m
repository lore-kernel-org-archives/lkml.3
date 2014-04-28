Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932075AbaD1Kqf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 06:46:35 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55204 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754260AbaD1Kqc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 06:46:32 -0400
Date: Mon, 28 Apr 2014 20:46:20 +1000
From: NeilBrown <neilb@suse.de>
To: Jeff Layton <jlayton@redhat.com>
Cc: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        "Stefan (metze) Metzmacher" <metze@samba.org>,
        Rich Felker <dalias@libc.org>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, samba-technical@lists.samba.org,
        Ganesha NFS List <nfs-ganesha-devel@lists.sourceforge.net>,
        "Carlos O'Donell" <carlos@redhat.com>,
        libc-alpha <libc-alpha@sourceware.org>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] locks: rename file-private locks to file-description
 locks
Message-ID: <20140428204620.01c102c2@notabene.brown>
In-Reply-To: <20140428062321.7442881d@tlielax.poochiereds.net>
References: <1398087935-14001-1-git-send-email-jlayton@redhat.com>
	<20140421140246.GB26358@brightrain.aerifal.cx>
	<535529FA.8070709@gmail.com>
	<20140421161004.GC26358@brightrain.aerifal.cx>
	<5355644C.7000801@gmail.com>
	<20140421184640.GD26358@brightrain.aerifal.cx>
	<535573E0.9080106@gmail.com>
	<20140421155520.3b33fbef@ipyr.poochiereds.net>
	<53558A73.3010602@samba.org>
	<5355F60C.8010004@gmail.com>
	<20140427145125.21e7e6c6@notabene.brown>
	<20140428062321.7442881d@tlielax.poochiereds.net>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/2hVPHcY4=ri0v8__7d5_HK="; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/2hVPHcY4=ri0v8__7d5_HK=
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 28 Apr 2014 06:23:21 -0400 Jeff Layton <jlayton@redhat.com> wrote:


> I sent a pull request to Linus last week and he merged the patches over
> the weekend. So yes, this ship has sailed unless someone feels strongly
> enough about it to roll up the patches to change it.
>=20
> I think we'll probably come to know these as "O.F.D. locks" over the long
> run. Not a wonderful name, but I can live with it.

I've managed to train my brain that "of_" means "device tree".  Coping with
"ofd" meaning "per-open" should be too hard.

:-)

NeilBrown

--Sig_/2hVPHcY4=ri0v8__7d5_HK=
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU14xfDnsnt1WYoG5AQL8GBAAkCoPlKKP5vGtTtOy25ehAZof58HOkcGO
Oaqs5Osfb2mRxTz8d7jW30nUMxlTfc/UypPFPEzIMjo1ZCCZ9c3/ZsH0APFaom6m
N8J12vEzySiTVWBstYxv1j1QhlA4ch+KYH0Ty9cBOBNgf9agwr+MYy2lJecW7ZtF
o+4DXYU4sgSU7ZGAD/2nSSnln3MoGDJjtlMKsdYyPSNbI7Ls+NNI45UW0GmPa/+/
lai+BitfucStOg/xGu9yI4WOblwrtAoC6/JmF4PJ+q1TvDuVhJZv6BUH8MfkrGon
QIzTG1mqK6z/mAdZQ4XW93mn3u0wIbKSXummWYDzopeTnW+duYQahCItuSV1cT5X
TbHxcSifzAewF40DTXwt9XWy/RTumoiOttbgPYs3l6GamlONtoDdEuRvJwue9ERB
Tkd2TMs1QMgXvg6tbFc57n66K7CuWg4LX5qxm5cWVbXHrvZ2DW2PN+jPBbQxXFoC
wsB8x6i7HdEngpvgMUSif+gTmU2sFBC8NrFGrgH/2vqVjrcIasz8EnotlFuyhUqw
EQ9lcZEVxPyqR7zE389nJuYl3rhPczmjnYpU/IWNBScCyRA1WvWQutuuNRgW3tgj
XGPri1IjCSWodZ3fiwqTQbIu9Wu/XIwboLvuPcqNtjH1qYPObReSItSqaeCudt3I
7xrpACLEDH0=
=sWxo
-----END PGP SIGNATURE-----

--Sig_/2hVPHcY4=ri0v8__7d5_HK=--
