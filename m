Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754134AbaHNCYy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 22:24:54 -0400
Received: from mga14.intel.com ([192.55.52.115]:45583 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754638AbaHNCYj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 22:24:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,859,1400050800"; 
   d="asc'?scan'208";a="576430969"
Date: Wed, 13 Aug 2014 21:52:36 -0400
From: "Chen, Gong" <gong.chen@linux.intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Randy Dunlap <rdunlap@infradead.org>, Borislav Petkov <bp@alien8.de>,
        Tony Luck <tony.luck@intel.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RESEND 0/5] PCIe, AER: Misc cleanup
Message-ID: <20140814015236.GB28066@gchen.bj.intel.com>
References: <1407910961-7798-1-git-send-email-gong.chen@linux.intel.com>
 <CAErSpo4DZboL75xa1Ahxr9aoDg_wyad1gZpXeAAiqcmx=8N8sg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tjCHc7DPkfUGtrlw"
Content-Disposition: inline
In-Reply-To: <CAErSpo4DZboL75xa1Ahxr9aoDg_wyad1gZpXeAAiqcmx=8N8sg@mail.gmail.com>
X-PGP-Key-ID: A43922C7
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tjCHc7DPkfUGtrlw
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 13, 2014 at 07:52:45AM -0600, Bjorn Helgaas wrote:
> I haven't responded because I've been on vacation for the past three
> weeks.  If there's no change in the patches themselves, and if they
> are still in http://patchwork.ozlabs.org/project/linux-pci/list, the
> only thing reposting them does is make more work for me.
>=20
There is one difference existed in Patch 1. I add more explanation in
the comments as Boris suggested.

--tjCHc7DPkfUGtrlw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJT7BZjAAoJEI01n1+kOSLH+icP/iBxgWLwYEecN2bBkdBb1qhq
nufgUGZ69HaLt3J+hbELoeuYZIoIBjd5THPKzXJM9yKSNVgAXePWMdOENPukjUCC
Nx6eAfa47j5z1VfBY2u8M91zaxNXbuJBtZW5ZAGi23cAQbVuEvFnlfi0+V7TDxYe
qj1C7vtC815oOgV4iSTZEIsoSgh2+yxyHxKF1r3SgOv5pski2LZKBWk5unKq0U65
4TvEquaB0LuU8tR01V3GdPdCojmO/XTENmxxvA6A2xlYFajVjdnASvV87ET4UVZP
/sEVopQFAc8DNByoBk7xkZFTNi1njkM8lFGznOTysxW5vle9eirXdJcrTB9jATfW
LMb/4tg+av1GmLZ1ijO2pvAafkDh8wayRzMZou/r2cdGoxDE7jjQWhgy5ufYMF4h
SjZ1F7SE7v2BjXDehVDaKIeRjQHW2k+fwUR4FjOyVOnRiOSp6Aq268KTip/0KkY5
dxKtSoPUrcfx8rExzLi8ySKM8vmneQfdzfQl6aMv1tRymqZOWYu22iRnS8zpvZM6
dOSjON+N4RAqn5H2PqNf+6UQykBFhF3sgcB8Xtd5Y9ynDRSOky+NsME6lsnu7QLR
vzbCBSGp52lA0uk8KeOEOPOkT5JrhW36pq78iZ0dOvEPo+QQRErOolbjjTRNoYuh
XY2HTtsvtJxqq3q9if1/
=O9o3
-----END PGP SIGNATURE-----

--tjCHc7DPkfUGtrlw--
