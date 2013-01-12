Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753049Ab3ALJzQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2013 04:55:16 -0500
Received: from mail-wg0-f52.google.com ([74.125.82.52]:61694 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752639Ab3ALJzN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2013 04:55:13 -0500
Date: Sat, 12 Jan 2013 09:55:07 +0000
From: James Hogan <james.hogan@imgtec.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH v3 00/44] Meta Linux Kernel Port
Message-ID: <20130112095507.GA1738@balrog>
References: <1357831872-29451-1-git-send-email-james.hogan@imgtec.com>
 <20130111103442.b80ddbfb11ef322ed28ca3b3@canb.auug.org.au>
 <50EFD824.3010502@imgtec.com>
 <20130112000336.1f24c42237fab4fe0c305ff6@canb.auug.org.au>
 <50F0296E.2000704@imgtec.com>
 <20130112120957.36df3412c9d6cca089a0340a@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3MwIy2ne0vdjdPXF"
Content-Disposition: inline
In-Reply-To: <20130112120957.36df3412c9d6cca089a0340a@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3MwIy2ne0vdjdPXF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Stephen, Al,

On Sat, Jan 12, 2013 at 12:09:57PM +1100, Stephen Rothwell wrote:
> On Fri, 11 Jan 2013 15:02:06 +0000 James Hogan <james.hogan@imgtec.com> w=
rote:
> >
> > Okay, I've rebased the metag tree from linux-next onto the master branch
> > of Al's signal tree (to get Vineet's GENERIC_SIGALTSTACK fix and
> > GENERIC_SIGALTSTACK's eventual removal).
>=20
> OK, but I hope you mentioned not rebasing to Al.

I'm still rebasing the metag tree, and it's not quite ready for -next so
I don't mind if Al's tree rebases at this stage tbh.

Al: I don't know if you normally rebase your tree, but if it's okay with
you I'll let you know when I need it not to be rebased.

> > git://github.com/jahogan/metag-linux.git
> > branch: metag-core
> > tag: metag-core-v3.1
>=20
> When you think it is sufficiently ready (and I am guessing that it is
> getting pretty close), please send me a request to add it to linux-next.

Thanks, will do.

Would "sufficiently ready" normally mean "in a state ready to send a
pull request to Linus"?

Thanks
James

--3MwIy2ne0vdjdPXF
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQ8TL7AAoJEKHZs+irPybfbcgQAJG5Ej/nvNFRNNKobP4BbHvK
f45nuoAR5Uo/9szhiXUPkiIy4eiHu0D0ZGdVOBTXsNA9XXYyo+JvYMd939s3KLoR
ak6jt0215phuEx94Deokf3ajiH+iF+edng6s+MOz3H/Nvsth8hmbbHp/k96YiF3f
72XAomoRXX0kIOl8L69G/srDrKO8Z0bj9nw8GX4pO0HUyA0vyd+GlpahRWHUIMDk
dBAOi6QCGuVkH0reex18zODc/h2ou2U8ejR1/Hwee04wowenkDniS+fCM8NgIwQM
nNwznd/zdkG7B4j1MZMFl2QGoih8nPTRdB1NfxdZysw6xwldJlWO6ARaTJHX15fc
9Y89FiCz7YLJwqoe+wszQ8ouoWSUSIvxCcS8YwfUCDRY2cK8C1E7Kxe2bnYyGx2J
fBd1Sat4UzOAe372/ySy6WWq9ZlyoLI0wXo+9r/x3+6CfM2KFIBJFSMJrxUr4VQ5
l5pekr22PumTxMa1wYHXU+RQgUfM4LpuWp1t7pJr1AX6DpGwDWv2+JS/DDoOCvic
0+vcshAkeNpTIQ6gnLm00uZeuOK/4ksTib3ZZRX04JXlusrHS0j82SjxJQc4UiBN
Omxg3Rpr+8FHlxnOIWpGxQC8vgRlnNUolWQ4JB+qEc/9PRW/edlJiB586W5yQ0EY
k71zDwTj82SmIB0/EYyK
=2/BE
-----END PGP SIGNATURE-----

--3MwIy2ne0vdjdPXF--
