Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751439AbaAPWlt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 17:41:49 -0500
Received: from ozlabs.org ([203.10.76.45]:37269 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751246AbaAPWlq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 17:41:46 -0500
Date: Fri, 17 Jan 2014 09:41:31 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Fries <David@Fries.net>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg KH <greg@kroah.com>, Evgeniy Polyakov <zbr@ioremap.net>
Subject: Re: pull w1 updates to linux-next?
Message-Id: <20140117094131.4379cba0c7f5b18744f95311@canb.auug.org.au>
In-Reply-To: <20140116045100.GB29560@spacedout.fries.net>
References: <20140116045100.GB29560@spacedout.fries.net>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__17_Jan_2014_09_41_31_+1100_XiEU_orDgQNhc08l"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__17_Jan_2014_09_41_31_+1100_XiEU_orDgQNhc08l
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Davis,

On Wed, 15 Jan 2014 22:51:01 -0600 David Fries <David@Fries.net> wrote:
>
> I've not submitted to linux-next before, would you pull the one wire
> changes to linux-next?  It has been posted and reviewed by one wire
> maintainer Evgeniy Polyakov, and the 15 patch series was posted again
> ready to go for GregKH to pick up.  This is my one wire tree not
> maintainer, and once merged upstream won't be updated unless I have
> another set of changes.
>
> cd5f76716a37ebef3e8b771d672ba552a25dafd5
> git://github.com/dfries/linux.git w1_rework

If this is meant for v3.14, then you should probably just ask Greg to
merge them (though it may be too late already for the next merge
window).  If its for v3.15, then ask me again after v3.14-rc1 is released
and I will add your tree then.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__17_Jan_2014_09_41_31_+1100_XiEU_orDgQNhc08l
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJS2GAnAAoJEMDTa8Ir7ZwVyAUQAI2XLgRj7fvXF7a1bG6n7blE
4k8eu8RZRcoADXkxAy6WGj7+4WaSR+1aglDRhB8SeDTlnJcbaYL4TunrPkd0NMnl
P38Jem2n5AfXXPMVtcnJLAtcFhOpXjhd0cfLeP1PwhJYOdymoSXJINfxe1KHbT9h
cJU9BKCZd9CRKSCdFHNeQsbl3dOSYt3O5O06+QgS/xR65XuLMNhFRZ4DBTjZAvEi
jPeWzs6NRuW1kYgv6vm05q7TQ1CEu4NEc+ce+UM+BKxGnvZzz5VpB46p8Jc14+5y
ABcXh+ojVVpxtS8Nb15iGjfCtmzuTLs05+91tzxc2HRnwyeN13ca7Gy4uYJcg1Nf
h5d8qWQgb0oW9oB1z2CMBRSIG2XsbdFUSFqj5VZmEfO7KxO/7nwq5IaMaXhQ1zq+
gFx5JakZ53ePqixtCTkZjSx8yJVs+B/d5w97meVbPxt6jVv//PsprAO3ugcbcwXo
CYiI1Jn4TSlzGn/UPpSxrThxcfSWcOhWmjDk9MJT0vflyKEd8Gy+WZxcg0ZAb3aA
LkOZiOADzkuGhfy+/SBAfEptw52M6eKMO6p152rWuwyjVNdVTdg04+6h8oR5Ygny
J18EdGtBfkdtlUsCcBGZyOnT7Tz8Yq4QYGoaL4EHdxk67PIGn1fFfNb9pEvZDi8i
pTqfzLjuxHELrbUEBWMt
=CKev
-----END PGP SIGNATURE-----

--Signature=_Fri__17_Jan_2014_09_41_31_+1100_XiEU_orDgQNhc08l--
