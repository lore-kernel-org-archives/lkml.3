Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756181Ab3EHAMI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 20:12:08 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:50036 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755229Ab3EHAME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 20:12:04 -0400
Date: Wed, 8 May 2013 10:11:54 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: intel-gfx <intel-gfx@lists.freedesktop.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        linux-next <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ville =?UTF-8?B?U3lyasOkbMOk?= <ville.syrjala@linux.intel.com>
Subject: Re: linux-next: manual merge of the drm-intel tree with Linus' tree
Message-Id: <20130508101154.05cd9327d7ebb0e7b9f82378@canb.auug.org.au>
In-Reply-To: <CAKMK7uEr4Fs00nM3iuwwBdd+LV3_6w2sarR+i8tk02BrTHQmNA@mail.gmail.com>
References: <20130507112751.195757b78defdbea58aa6134@canb.auug.org.au>
	<CAKMK7uEr4Fs00nM3iuwwBdd+LV3_6w2sarR+i8tk02BrTHQmNA@mail.gmail.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__8_May_2013_10_11_54_+1000_=0NLpcgQz7.Pqml="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__8_May_2013_10_11_54_+1000_=0NLpcgQz7.Pqml=
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Daniel,

On Tue, 7 May 2013 10:43:17 +0200 Daniel Vetter <daniel.vetter@ffwll.ch> wr=
ote:
>
> On Tue, May 7, 2013 at 3:27 AM, Stephen Rothwell <sfr@canb.auug.org.au> w=
rote:
> >
> > Daniel, I assume all this stuff being added to the drm-intel tree is
> > going upstream very soon?
>=20
> Oops, no that is stuff for 3.11. Lazy me hoped I could sneak stuff
> through (since we just keep on merging features to
> drm-intel-next-queued to avoid stalls), but that's obviously not what
> you want for linux-next. My apologies for that mess. I've now created
> a for-linux-next branch which will not contain patches heading for
> 3.x+1 while 3.x-rc1 hasn't been released yet.
>=20
> Can you please switch over to that branch for inclusion into linux-next?

Done.  Thanks.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__8_May_2013_10_11_54_+1000_=0NLpcgQz7.Pqml=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRiZhKAAoJEECxmPOUX5FEHfYP/i9T1NEZgwsSA9PKpARo149/
jBTt9i4R5XkXIE3s3rqi9DA7qMRT3Dz8/ueEmna+iIAXGo2eq/rkOfm0jUI4Hh8n
ZFlL0IwqagrOOJYrBK6KIc8CLJRNFgRCvUSav3yrrG5zFxWgnpJBYIqd424t41VE
cCC9MEtiXMjvPz4Ju5TaRjfJWcUPSU3UuJz7PTGtsNqj72bDMga/jpX1QXBjolRN
gF/0Wo9rKbN2QHQZMn4F8ByVf9s2XReA4OkhLNI0VZeMSNuDdhlnmzbkuKuuWsme
WAuQnGOvYJNcwAf96EF0jUQ3+4VxhlUSkdy0zQCI2qEgRIziNyxnhQzo2ROJvmVm
Q1PXznNnc19/HpTCIpQNha8rNQPfl2QhU9pQ1zqxThnkOMQUc5hbcrzsyNOpfEPb
AcwyexVYjXfzB45sxldwZxbImn7WT9BTLzyGM8yMc0A+lC1POKWRMqwqXpPnb0KU
VXqFhl88leXRCarhCYOggIEEQzjio/cpXA0wnhtvQm/pfrqhrdNSdfpWe+f7O8V2
t6Kt7hAz3rxi/5Wg11HeGjK6BFujvHirQb73c42ScxbVRh2heriefD3TiGpwVyYf
iFadgTnAnNYA3wBjVIZxF7+w4leAgbwO9ypAlfhroQFoRBDefa/i6C9JE6ASaW3u
mskalv1GAhxpsQxt8Rt5
=cCsb
-----END PGP SIGNATURE-----

--Signature=_Wed__8_May_2013_10_11_54_+1000_=0NLpcgQz7.Pqml=--
