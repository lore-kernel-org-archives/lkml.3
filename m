Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753336Ab3H0IPX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 04:15:23 -0400
Received: from mail-bk0-f52.google.com ([209.85.214.52]:42522 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753138Ab3H0IPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 04:15:20 -0400
Date: Tue, 27 Aug 2013 10:14:46 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Julia Lawall <Julia.Lawall@lip6.fr>, kernel-janitors@vger.kernel.org,
        Stephen Warren <swarren@wwwdotorg.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/7] PCI: tegra: replace devm_request_and_ioremap by
 devm_ioremap_resource
Message-ID: <20130827081443.GI8686@ulmo>
References: <1376911241-27720-1-git-send-email-Julia.Lawall@lip6.fr>
 <1376911241-27720-2-git-send-email-Julia.Lawall@lip6.fr>
 <20130819120249.GA5740@ulmo>
 <CAErSpo5oOnfhi+aRi-Z3kCwS1VpYSO6FX5O_MOZmWNLcfhhA9w@mail.gmail.com>
 <20130819201224.GC5191@mithrandir>
 <CAErSpo6U9i16gdaYGpWqgLaFteXpy1erCUw55SqkHLcbypP=vA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MFZs98Tklfu0WsCO"
Content-Disposition: inline
In-Reply-To: <CAErSpo6U9i16gdaYGpWqgLaFteXpy1erCUw55SqkHLcbypP=vA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--MFZs98Tklfu0WsCO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 19, 2013 at 02:49:07PM -0600, Bjorn Helgaas wrote:
> On Mon, Aug 19, 2013 at 2:12 PM, Thierry Reding
> <thierry.reding@gmail.com> wrote:
> > On Mon, Aug 19, 2013 at 02:04:24PM -0600, Bjorn Helgaas wrote:
> >> On Mon, Aug 19, 2013 at 6:02 AM, Thierry Reding
> >> <thierry.reding@gmail.com> wrote:
> >>
> >> > Bjorn, how do you want to handle patches to the Tegra PCIe driver in=
 the
> >> > future? Do you want me to prepare a branch and pull from that or wou=
ld
> >> > you rather just take simple patches?
> >>
> >> I'm in the habit of applying patches from email, so that's easy for
> >> me.  But a branch would be OK, too.
> >
> > Patches work for me too. Is this cleanup patch something that you'd be
> > comfortable with applying after 3.12-rc1 or would you rather defer it to
> > 3.13?
>=20
> I'm not really sure how we should manage drivers/pci/host/*.  Those
> files are mostly arch code, and I'm not sure it's useful for me to be
> in the middle of managing them.
>=20
> I assume Stephen or somebody has a tree with the pci-tegra.c stuff
> that's in -next right now; it seems like it'd be simplest to just add
> this patch there and merge in during the v3.12 merge window.

If Stephen's fine with it I suppose we could take pci-tegra.c driver
changes through the Tegra tree. But I think it'd be good if we could
still Cc you on patches so you're aware of what we're doing (that is
the same for all drivers drivers/pci/host/*). And we're going to need
your Acked-by on the patches as well.

Thierry

--MFZs98Tklfu0WsCO
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSHF/zAAoJEN0jrNd/PrOh4LcQAJvIRnYZFA6phiVFvyQON8YI
EinzYiHmV02pb5MDFKUivA2yDKSiy86MJRcVxNpRW/JxvXwFTdbpiN8B/7qtrCsC
2uwrtFlKo0WGktGYJsIVM57aarPEBl66GMcAliAmDTBD1x6z00QCOjwdbociDmWO
aZRUjn2IK+ZFvKAijiM8OZWForsiCriWNUUILGUZXggR8FNK8Tu3BtO0/1BNBJgA
LGbcqzSLd8KHJlXXSkXKvzESpvx9q4nhe1Q+D/r92CW3jlJDgu9FQ4IjVC0Z2dav
e+52ueTWOexlIT8lyf//hSn7W9EWvsuBxiWihwHg/nMUcHII8aUl3k9DzJz43yc0
m+it531Sbtcu+/PsMOti3+GWBwwqt6pb5JYlSyNLhUAtKVUw35bp/uR6mr072c3d
D2s4exsHRwHipB+GYNAEOMWVS76wE4ngNmCRViKNcIrHkNH7fDuJ1gJFyjNrCxtD
erx2i6GHs9cQahd69EBMoZhTxGhQJ5xT8VQyJ6VxuSwJFtVVZuTShN/n+b9jQJll
uDoCn2w6CYY2OSDvKLe9vBFBCtqIVjQePcKoJSoEiKzCtuOkeujMI44/kRY0qAUL
63vaPUu7RAnDscd61Ay5uS2aRyjy62Dre6Atohkzb4BtNxtrZW3v2XG27keaKe40
jcM6e+Iuq23A2UnHzW0O
=g8NQ
-----END PGP SIGNATURE-----

--MFZs98Tklfu0WsCO--
