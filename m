Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754732AbaDGBhR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2014 21:37:17 -0400
Received: from ozlabs.org ([203.10.76.45]:47160 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753111AbaDGBhP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2014 21:37:15 -0400
Date: Mon, 7 Apr 2014 11:37:06 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jeff Layton <jlayton@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel mailing list <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Bruce Fields <bfields@fieldses.org>, Matthew Wilcox <matthew@wil.cx>
Subject: Re: [GIT PULL] please pull file locking changes for 3.15
Message-Id: <20140407113706.d213ca01fed70e3367611197@canb.auug.org.au>
In-Reply-To: <20140404205624.521f67d5@ipyr.poochiereds.net>
References: <20140331093120.10aeaba6@tlielax.poochiereds.net>
	<CA+55aFy_o-wDrbQSRnrThGqo8mcBS-pVXM6Kj0LqH8PzRr_0Kw@mail.gmail.com>
	<20140404205624.521f67d5@ipyr.poochiereds.net>
X-Mailer: Sylpheed 3.4.0 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__7_Apr_2014_11_37_06_+1000_gJOEa_kywauN8iLA"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__7_Apr_2014_11_37_06_+1000_gJOEa_kywauN8iLA
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jeff,

On Fri, 4 Apr 2014 20:56:24 -0400 Jeff Layton <jlayton@redhat.com> wrote:
>
> Thanks for the feedback and for pulling this in anyway. I'll make sure
> to do all of that on subsequent pull requests.

Also, please don't rebase what you have in linux-next before sending it to
Linus (without good reason).  Especially if you then leave the linux-next
included branch as it was - since that may cause conflicts in my tree
(and so I notice the rebase).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__7_Apr_2014_11_37_06_+1000_gJOEa_kywauN8iLA
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTQgFHAAoJEMDTa8Ir7ZwVia4P/j0c6tgxhw4uAk8RJYYRZ35g
7zrmUS4X3Ijm2CTRob90omPqscjPAIyArOzWFBs2b22SR24pR86nhZkUya6kXCfK
doJz6RoOEdUyuPV3izLeKL63SG1nFjOxk0vvPCBbzp7U3+M//KYz/dsGNGbhfDeq
pIAbbCReQ3U/SUOALDVUE08XSpoYnbOD3xvAp+MWz/ct5nxKfLY2PVYEy2ExIWpI
O3Lv5pJYKXgj/xafBKgnafcC8cYR50u793tbTyCBJocg5bOERHfAeNi3aERuQlxD
P3vsPryIYvrzc7X4ObDNRQcE/jrbedsAhzaTQBOhwKPXAWxlisr7KdY2tiGBmPsb
Zw9uxmFp/XeV/lxKgTShgxFnWwlAPoGMPNvJbeJOwpjE22hCuhJ3Ee2yRu2JVZ0Y
3qgjvTQd4LBTacZj4dBwHZyz2xjuhsJqINYdH0yt8OoUJjQ50+AjZRXT3FqhKwGB
x8CPv0CbwsQUmYUoUBk776KcFnSkoE1bD46IVUDtZNNpjPEN1KeUZoIeZdf2gveX
svNuRfDv5gm7juhEk5vF+TrMdjyLsLFWxo36oA3/FpfxSEghK8Z+om0C89SR866D
vHhVAHUPPcIXH8yd04NPMMLoSnJWNZoEbaB0MpIojptL3i6OTqEn+zvcZQ4QXrmH
gKhpXzzcvbVvkivtg153
=oz8F
-----END PGP SIGNATURE-----

--Signature=_Mon__7_Apr_2014_11_37_06_+1000_gJOEa_kywauN8iLA--
