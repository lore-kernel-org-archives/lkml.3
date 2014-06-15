Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751257AbaFOKuW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2014 06:50:22 -0400
Received: from thejh.net ([37.221.195.125]:46354 "EHLO thejh.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750889AbaFOKuV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2014 06:50:21 -0400
Date: Sun, 15 Jun 2014 12:50:14 +0200
From: Jann Horn <jann@thejh.net>
To: David Herrmann <dh.herrmann@gmail.com>
Cc: linux-kernel@vger.kernel.org, Michael Kerrisk <mtk.manpages@gmail.com>,
        Ryan Lortie <desrt@desrt.ca>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org,
        Greg Kroah-Hartman <greg@kroah.com>, john.stultz@linaro.org,
        Lennart Poettering <lennart@poettering.net>,
        Daniel Mack <zonque@gmail.com>, Kay Sievers <kay@vrfy.org>,
        Hugh Dickins <hughd@google.com>,
        Tony Battersby <tonyb@cybernetics.com>,
        Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH v3 3/7] shm: add memfd_create() syscall
Message-ID: <20140615105014.GA8856@debjann.fritz.box>
References: <1402655819-14325-1-git-send-email-dh.herrmann@gmail.com>
 <1402655819-14325-4-git-send-email-dh.herrmann@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="d6Gm4EdcadzBjdND"
Content-Disposition: inline
In-Reply-To: <1402655819-14325-4-git-send-email-dh.herrmann@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--d6Gm4EdcadzBjdND
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jun 13, 2014 at 12:36:55PM +0200, David Herrmann wrote:
> +asmlinkage long sys_memfd_create(const char *uname_ptr, unsigned int flags);
[...]
> +SYSCALL_DEFINE2(memfd_create,
> +		const char*, uname,
> +		unsigned int, flags)
> +{

Shouldn't uname_ptr and uname be "const char __user *" instead of "const char *"?

--d6Gm4EdcadzBjdND
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTnXpmAAoJED4KNFJOeCOopPYQALj+Vm8+Sg6YXj6/wAsznNN4
DwlnBNIt6mUTlXAMEpHonnEcSGE/YlaUQfwWLaVXvE++YosBqic4vA59PxFpAOvM
kX+JULj1e9lVtklp88jk8ZFC98mc0/mndLQkLceurnGDoOPTtT0qD2DkO+bdJP8Z
n+V3zqYp8Nv1gRpGnI37l07RGAyfCgI3nAmy/bA+O0jOh6EqX0OGP5HCRatCWrcN
Xk3Ojx/3MUQWnRH5sR734F77L1znE+7SBGyvsA7orAQeKygEXqh+CKKyrvedG41i
uKQcmBdrzlteyWB0GRkUnreiZ9GAc6P0MFOXwRZOgMGqQsRnPpY5Nrecigfi/XDi
shQq++85x38wUXu4UJ3RKftqTJGSIrNeBTjdxfcCtRzDL1y3QUoDs4fdaMAHTlHi
4vcrEQQ1aDMsZN6phL/NJ4Jg2q0xYIdbPOgiRSVL6UWtqdukyQIwIQhznpPOqsAf
9yYov31M5VzCngJhejwwvX1KtNuAa6AeyTOYobP0Ek0BSDkEUCQdBufbELBSrpnY
fGJ4HCEvoPUhZ8qVrFgpvLytz5h6/+Z8KHvMol8Rr/yC8pSusLcZO4L2EdF5eIAT
q/xxJzblX4KgIDVpLRIlgoUG8+tVZk5ItsCTajfOVte5P6xYajwdebPP8XkqeKk0
UmifGhoTM2F4xdNiTzH3
=H7oB
-----END PGP SIGNATURE-----

--d6Gm4EdcadzBjdND--
