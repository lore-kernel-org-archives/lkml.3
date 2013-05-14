Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755564Ab3ENAI0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 20:08:26 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:43309 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754667Ab3ENAIZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 20:08:25 -0400
Date: Tue, 14 May 2013 10:08:23 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: comment on the xen-two tree
Message-Id: <20130514100823.09193b126d3742359997a717@canb.auug.org.au>
In-Reply-To: <20130513134818.GN6811@phenom.dumpdata.com>
References: <20130513095244.60176cad5e302c1156788096@canb.auug.org.au>
	<20130513134818.GN6811@phenom.dumpdata.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.17; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__14_May_2013_10_08_23_+1000_2U1ERBxyg_5+S7/Z"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__14_May_2013_10_08_23_+1000_2U1ERBxyg_5+S7/Z
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Konrad,

On Mon, 13 May 2013 09:48:18 -0400 Konrad Rzeszutek Wilk <konrad.wilk@oracl=
e.com> wrote:
>
> On Mon, May 13, 2013 at 09:52:44AM +1000, Stephen Rothwell wrote:
> >=20
> > Since the xen-two tree
> > (git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git
> > linux-next) seems to only consist of merges commits and some old (pre
> > v3.9) stuff, it might be a good time to reset it to be just v3.10-rc1 (=
or
> > rebase onto that) so you can start with a nice clean tree again.
>=20
> Done!

Excellent, thanks.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__14_May_2013_10_08_23_+1000_2U1ERBxyg_5+S7/Z
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRkYB3AAoJEECxmPOUX5FEtUEP/3tA++dEbE/xlgmwFkUVaVDN
+waX94mx47nr9kSQe/KoEhZEXakgVDfSt5qEpQ25S7pItwHjCElG0aab5vomnROZ
q2Nze6ipI3yQseTC3GEUjC4ZEY9AKqT9HGfD1qnoNunL2yh0+eUQMmqOpx4MNtB6
kotsxe8XdbzBFIYRWIpXhX6E/ovZOgiAULNV9NdfYFD1uN4qfCi2w0Ot8WjczBm3
r3VJ7rMGo+cNXIDAYwLyx5ndvPngwqLUldK2GDySZE32nnAxL39g4kie0NUUD0EF
EmufvGaH4CqLRjHGNAfC3F2NLjO6S8RJqtGhW2BPxoLv7Au4nDso2oMjhPaMcMCq
6WcvbVcQiRjjIrvuKsPVVW6qeXK+GrrIM+m8pW007xp4Jxiu/d5BE4yI0hWhfDJg
ua4qw9dwtIlzHrzj33kHecIHbn8qviQ3rp9HagpeTLiVH7Jd8i+Mq9VSfS8BvKMm
82wO+oj1BvCDeKxt2jB+bOgCiFbzT2psrDxgV6WGDDR26+yqr2tu1nefR9BdtH2Z
Tj4I+ZoQjdWzHeRgna6oidDm68fJSX05OQ1CzqLBkQljBaSN5HlbJvZ0zmtSOF+g
K8nbWS1Lwnz4AbFAzihJweY42ESehPls9riK/+3kd1GprZyNQxCDGU1mrEmGeVrV
ThuBkGUfpRR05GO+KDJF
=w57P
-----END PGP SIGNATURE-----

--Signature=_Tue__14_May_2013_10_08_23_+1000_2U1ERBxyg_5+S7/Z--
