Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753520AbaJHHrp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 03:47:45 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:46991 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858AbaJHHrn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 03:47:43 -0400
Date: Wed, 8 Oct 2014 09:47:39 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Vidya Sagar <vidyas@nvidia.com>
Cc: bhelgaas@google.com, swarren@wwwdotorg.org, kthota@nvidia.com,
        linux-tegra@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] PCI: tegra: Enable root port specific features
Message-ID: <20141008074738.GE4999@ulmo>
References: <1412677678-12011-1-git-send-email-vidyas@nvidia.com>
 <20141008074404.GC4999@ulmo>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="M/SuVGWktc5uNpra"
Content-Disposition: inline
In-Reply-To: <20141008074404.GC4999@ulmo>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--M/SuVGWktc5uNpra
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 08, 2014 at 09:44:05AM +0200, Thierry Reding wrote:
> On Tue, Oct 07, 2014 at 03:57:58PM +0530, Vidya Sagar wrote:
[...]
> > +static inline void rp_writel(struct tegra_pcie_port *port, u32 value,
> > +							 unsigned long offset)
> > +{
> > +	writel(value, offset + port->base);
> > +}
> > +
> > +static inline unsigned int rp_readl(struct tegra_pcie_port *port,
>=20
> readl() returns u32 and so should rp_readl().
>=20
> > +							unsigned long offset)
> > +{
> > +	return readl(offset + port->base);
> > +}
>=20
> I don't see much use in these, but if you really want to add them,
> please also replace any of the open-coded occurrences of this. Also
> please fix the alignment of function arguments on subsequent lines.
> They should align with the first argument on the first line.

Oh, and perhaps make it a separate (precursory) patch so that this
patch can focus on the PM features.

Thierry

--M/SuVGWktc5uNpra
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUNOwaAAoJEN0jrNd/PrOhST4QALUDzJ6d7NRI7w2XTnK8cYPQ
Ws9LgIoVDlh2374mkuzcBJPy2z1fSY6sScR0Ng+mj/KYKyU3F6mT4pOCu0iioTTA
S+RZTPVqymbTpxzfqKiI+EWuOBGisy3E0BunoSDiVgTbbnER5Vl3XUKd4vQvGdZY
NyD5f1rio8JBMyu84yqPDrmgrw6iQ8q1+S4IrHmrO1+B1uTXt2ICMoBF52df0SNo
Q+WUwx8yo+mCtdLJ+yGVfx6uZ8pvO4pTCOX6ndLfshFMRuL1WmtfC9LaHUzCpNXs
i12bRL1NMgWfnWd8LTphjmrZhPTORrftiHi4axPjKCu594ShF25XCl4EZ2sOKGwQ
eoD159GkZKeHgMPTSjE0eq3kBYj+QS8EsCAbFSMucZ8O9T+VHeEqUyGL8zueDCG1
PFTd27rS+gtKRWnUYpJwxvPNYufM78ByT3mG1uleaRlbN7D1oSOKkuen08hjIoWk
r0CcSQicHt8mMo8nPikrEGwSgd5XGs7ItcKJk9bVKXPM8Q7mXxsgDSDizfcBkMmZ
x4P7VSK3q1/LqXjkYxd7HIy7JIbBjqpotgAtoE+OSiCkgYGGEBXDKibqz0x4nIrx
QGqoMjcsizcM+dE9YY2DTENy7pcQwnbTxOL3O1LSZ6EJtwNRqjY+ZViKERcJU89G
gr7BpX/kPE8bpVa1fojN
=UX7i
-----END PGP SIGNATURE-----

--M/SuVGWktc5uNpra--
