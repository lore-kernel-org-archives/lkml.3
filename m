Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751298Ab3HSUMc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 16:12:32 -0400
Received: from mail-bk0-f53.google.com ([209.85.214.53]:55812 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750958Ab3HSUMa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 16:12:30 -0400
Date: Mon, 19 Aug 2013 22:12:25 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Julia Lawall <Julia.Lawall@lip6.fr>, kernel-janitors@vger.kernel.org,
        Stephen Warren <swarren@wwwdotorg.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/7] PCI: tegra: replace devm_request_and_ioremap by
 devm_ioremap_resource
Message-ID: <20130819201224.GC5191@mithrandir>
References: <1376911241-27720-1-git-send-email-Julia.Lawall@lip6.fr>
 <1376911241-27720-2-git-send-email-Julia.Lawall@lip6.fr>
 <20130819120249.GA5740@ulmo>
 <CAErSpo5oOnfhi+aRi-Z3kCwS1VpYSO6FX5O_MOZmWNLcfhhA9w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="t0UkRYy7tHLRMCai"
Content-Disposition: inline
In-Reply-To: <CAErSpo5oOnfhi+aRi-Z3kCwS1VpYSO6FX5O_MOZmWNLcfhhA9w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--t0UkRYy7tHLRMCai
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 19, 2013 at 02:04:24PM -0600, Bjorn Helgaas wrote:
> On Mon, Aug 19, 2013 at 6:02 AM, Thierry Reding
> <thierry.reding@gmail.com> wrote:
>=20
> > Bjorn, how do you want to handle patches to the Tegra PCIe driver in the
> > future? Do you want me to prepare a branch and pull from that or would
> > you rather just take simple patches?
>=20
> I'm in the habit of applying patches from email, so that's easy for
> me.  But a branch would be OK, too.

Patches work for me too. Is this cleanup patch something that you'd be
comfortable with applying after 3.12-rc1 or would you rather defer it to
3.13?

Thierry

--t0UkRYy7tHLRMCai
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJSEnwoAAoJEN0jrNd/PrOhx20QAIwr3hlyHjSAHygspXmUjK6r
pl1JBXNWSn4XitgPpxnS6ilYqNOPYJrbtXX5GnZxU0N1SJtRDNKGhLpzRQPdvPSP
I++VFwZknhUlWY26IAI5Jy7icJ+LGhBxMUsIQzVke6wH+uuJPx1Sl4aBDI78D9D/
XUNDqBw4mtF1BdfWsABtkIY7dGzLkG6eukgQs1fLYOvEkcto+nehqM/zIjwkdKuK
G2dKAJDXgUDnQR+xycN2Z2vn94OYKJSijrIg2KpP0qkH3Q3tJN+oKfv/Qslp+xYJ
KT7jtCe1qAgFN7kl00pmpWxXPLtXSRQCv1Z9VYOyDXDCNi8u2ZxZuNeq5YSnzzRq
87GzzzI8V2YvJ9RI7l/c7d6QAcmRsP8BaEFrByHXXcTQiEkWK2jw9Rz3/Dn8M63j
VtGovmjwh0krdUPQceieYWBMkXfn7QRTxwQ7BNHivBdEAAaN2i1lq8BoQriGn4S1
sAaNvfL8DnzxtHekSVj/C7gU2LR+dQCSUYnR3JwdhiRoy9Dg9zZ60Gh5WDs0Xoew
NPbHSGX+VsgfCRk5FODDKMJN5shsO1WTJvlV6F/qHFrRZ7WQgQ9/raVjlfIrMnRo
09idZ5H+UhwLgtqE8gdVFM3zxKnAXmZTQvNaOdOuU1uCL5JKY35NFS1p3/Ld1pSd
Ve0cQ78VJXQCSiJCwq0r
=a3ZP
-----END PGP SIGNATURE-----

--t0UkRYy7tHLRMCai--
