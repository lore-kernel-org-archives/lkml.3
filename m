Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756266AbaHGHqL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 03:46:11 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:57457 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754968AbaHGHqJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 03:46:09 -0400
Date: Thu, 7 Aug 2014 09:46:04 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        gnurou@gmail.com
Subject: Re: [PATCH] drm/panel: simple: Use devm_gpiod_get_optional()
Message-ID: <20140807074603.GA18359@ulmo>
References: <1406299645-29043-1-git-send-email-acourbot@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="G4iJoqBmSsgzjUCe"
Content-Disposition: inline
In-Reply-To: <1406299645-29043-1-git-send-email-acourbot@nvidia.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--G4iJoqBmSsgzjUCe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 25, 2014 at 11:47:25PM +0900, Alexandre Courbot wrote:
> Use the new devm_gpiod_get_optional() to simplify the probe code.
>=20
> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
> ---
>  drivers/gpu/drm/panel/panel-simple.c | 12 +++++-------
>  1 file changed, 5 insertions(+), 7 deletions(-)

For some reason I thought I had already applied this, but apparently I
was mistaken. Applied now, thanks.

Thierry

--G4iJoqBmSsgzjUCe
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT4y67AAoJEN0jrNd/PrOhZuAQAJ8gheTZyzRH7mo3Z+hw03eH
fUaWUXpG5Sy/bbvd2n/bg5Wc1UN+R7v/4f2N+fXgDwkKnOlYNZV0Lrs37LYEZY1B
MXmPNQNjzO9MtQJW5S0QxIvgPwRLhSh1viq362N6imxISkllHju26Tu3Lb9jIzOd
1+miuCvVzd4epjT+6eKLrQev2pZi4mXGj4dRPslple7TmNkP25pnJpayi14102wu
yVa9Jtevd9G35xTrgG5klJ4KuDviZbqtNwyijPSiG9URQPbW5/+VzQfOmOtRcX/W
2hgwpF5cQ+I75n28xULfseynk4qMdv0XB5x4J9ltwDksqES+XfvMJPqP7Khz2LsL
uKcKONDbrHyFjBbwKbeh2A6fSCmYS9Zbozm3HizpFfKSAA+DNZsn96kQvh3NeqCA
rLjkQ/55NrXw9Enq4BISTa1nEifbiSf6GGMNw1eRREDQwViJoqDvEvMvBNZL3Fzy
WrE6jCry5d5xBOb+x2Lp9ytLyUsCYnQcp0BSTWy5uo8dExMe3HAbAPN4ygXEKMBE
Afwwb3Mr2rPPclqgDoz8zqBamJ05XUtnleaYswJB27D0vYeJgOKt+0AI70az7SiA
fKGJJRdBnyou0jksM3Uq5GgYtvWhk/PJE/l9SJOirrIKRW7GvxQakhokQz2yzfyj
BYxLrsbVP9BW4pAD9Cbz
=XfW3
-----END PGP SIGNATURE-----

--G4iJoqBmSsgzjUCe--
