Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755761Ab3JJPj0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 11:39:26 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:46090 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755260Ab3JJPjI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 11:39:08 -0400
Date: Thu, 10 Oct 2013 10:38:51 -0500
From: Felipe Balbi <balbi@ti.com>
To: Andreas Larsson <andreas@gaisler.com>
CC: <balbi@ti.com>, <linux-usb@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <software@gaisler.com>
Subject: Re: [PATCH] usb: gadget: Add UDC driver for Aeroflex Gaisler GRUSBDC
Message-ID: <20131010153851.GJ28375@radagast>
Reply-To: <balbi@ti.com>
References: <1376316310-27989-1-git-send-email-andreas@gaisler.com>
 <20130918171506.GQ21559@radagast>
 <524A8927.6090500@gaisler.com>
 <20131001141958.GQ1476@radagast>
 <524BDEB6.8060404@gaisler.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="apbmkPN6Hu/1dI3g"
Content-Disposition: inline
In-Reply-To: <524BDEB6.8060404@gaisler.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--apbmkPN6Hu/1dI3g
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Oct 02, 2013 at 10:52:06AM +0200, Andreas Larsson wrote:
> >hmm, there are two ways to look at this.
> >
> >a) we have KERN_CONT to continue printing messages
> >b) you might prefer using debugfs and seq_puts() for dumping large(-ish)
> >amounts of debugging data ;-)
>=20
> I just found print_hex_dump_debug that takes care of everything
> including dynamic debug support, so I'll use that.

fair enough, although it's a little odd to have that always in the
driver. As long as it's hidden under VERBOSE_DEBUG I guess we can accept
it.

thanks

--=20
balbi

--apbmkPN6Hu/1dI3g
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSVsoLAAoJEIaOsuA1yqRE17wP/1VGqQFrp1QnDoFXNkiqyEcp
kNA37XOjPl7HNi2e81Il/3p555XDLs1zBD1qJdP994UzmMycH7xpZ7IFMJ+z32f/
uw4+mRP9XLbDyKHyDP1asrZCVWYHxB8X1l6/X45pDXEX2F1OPhU4kFcbphTBeJnp
uV4ql4VzmYYTn4/6X9n/7npWHF6A7eJl2eWx8kBIcWpQMWr7AbOVfcMSdvXNYc0/
qjVZt8M+60rlShUiXJHp22u+2WOnSlqOf/hoqyqkTrNZFvyivEXHeoEVRjIKz8yx
pvpQyXTtUgCD/5E3MIOSWlxxU/HUskHqaLSsylFvPaqCDqsmJsvXQ1b75Gg00JWf
GT3MWkKIVWHitNYexXTvwfeycbvk2/uzYkqkjawBJrA5tg4ijgOIwL5UTK4L8BVn
HOiUfZS69KqJhztDDcb/HIfOHEOGrWqCOHwQMrtfQuudkZScGU8Vkzy919yg/yYJ
2pJk6cDQ86r2KvCPUAyNRuJnl0Hjqwwym7ad4lJ45iMk5p9Nr48zHu5NQEEn302j
mRD9Rfg/oSEmFSn6f14mBpOdj7CwZOMf9I6qCCsHGThVfZ9KR5tp21mgxyNioAiq
UYTOVB06CNCFdX3NCzvFNpBES4sCCZHf9+6XsqmhinlaWmEXL4UvOUCjqRZEWWXo
7fChzo2w2InCYD7iPqPE
=MGda
-----END PGP SIGNATURE-----

--apbmkPN6Hu/1dI3g--
