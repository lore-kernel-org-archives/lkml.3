Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754775Ab3BRPwa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 10:52:30 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:51987 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752232Ab3BRPw3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 10:52:29 -0500
Date: Mon, 18 Feb 2013 17:52:15 +0200
From: Felipe Balbi <balbi@ti.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: Felipe Balbi <balbi@ti.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: SYSFS "errors"
Message-ID: <20130218155215.GB2663@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <20130218153316.GA2663@arwen.pp.htv.fi>
 <20130218155012.GA30974@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TRYliJ5NKNqkz5bu"
Content-Disposition: inline
In-Reply-To: <20130218155012.GA30974@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--TRYliJ5NKNqkz5bu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Feb 18, 2013 at 07:50:12AM -0800, Greg KH wrote:
> > If it helps in any way, I have printed below only the filenames
> > (without path) so I could pipe it through uniq:
> >=20
> > act_mask
> > audit
> > autosuspend_delay_ms
> > bind
>=20
> This one the driver core creates, I'll fix that up.
>=20
> The rest need paths to determine who to blame :)

wanna see the full list ? It's 1602 lines :-p

--=20
balbi

--TRYliJ5NKNqkz5bu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRIk4vAAoJEIaOsuA1yqREfnEQAKvPptvKmG+5UjoqoY4BR1iU
4Q3ZLQGrYd32WO0x8Rd4/EijjsfKNxMWibKBKlgrLFar4AP8DhBCsvbwlUV42AlX
WTNjZ8vZb+EPbD6Twv8jbL74En0gWyMo6HxqyksFItpqjUl1KU8diX8/okxSmAWA
BqudGodq1wzhw0ikgDxVk5M3eic4vluhsTcjObJihexQ2pXZFjWOmIUMBbFdUbSS
Cd1ju1LNsz4d8Ov/D9NthdteHy0o3xf5hlqTSCI1L/78dCgBvs51R8fItiQPwtMV
RXG9+gaoGlN+fExASXluFJbXAGqaQOFWEXpsNo8HHgqJnW14QPR34FsumWED7Pmx
RhjlO7AHF0TXCQyh82InHJUC/XmtH+RejDN8MkUzcMoVNskehV4tjRunn4AygXzF
psXxfZkFr9+SDioERG3SHtRREso36WZtOEcSF0a2UTtIh2KZtmzug85i9K++zL8D
WI9IfmcVkYYA7tvD9yycJYPt7IHaferXrSVPQUsCKwYwe2oT3Y536pdPUecq8Q+4
fE4dyTZbIqqMTuO5eLLDVk8PiY0qoIgdu4GH+CRgC6o5NCcLIpO2pyKtCwJk4vn4
l3XuKReQg/2/s9xX9FqPQonvWugAxSTtNnoJH8O/qAQ5kz2wyGDcBGE3Z8RwG4mY
t+rGO3/aB62PCiLC3MFL
=Xrjp
-----END PGP SIGNATURE-----

--TRYliJ5NKNqkz5bu--
