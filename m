Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751414AbaKDH2t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 02:28:49 -0500
Received: from sauhun.de ([89.238.76.85]:52088 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750753AbaKDH2q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 02:28:46 -0500
Date: Tue, 4 Nov 2014 08:29:52 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PULL REQUEST] remove .owner for most platform_drivers
Message-ID: <20141104072952.GA1887@katana>
References: <20141021165441.GA1619@katana>
 <20141104035707.GA8718@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SUOF0GtieIMvvwua"
Content-Disposition: inline
In-Reply-To: <20141104035707.GA8718@kroah.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--SUOF0GtieIMvvwua
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

> Just to be sure, the 4 other patches you sent also need to go in here
> for 3.19, right?  They were not included in this pull request?

Yes, they are bugfixes and should go into v3.19 IMO. I sent them as
seperate patches so people could review them (which was not necessary
for the patches in the pull request).

Thanks,

   Wolfram

--SUOF0GtieIMvvwua
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUWIBwAAoJEBQN5MwUoCm2YowP+QEWTtPsr0KRzAOeBsMChJtr
H/Wj8eNWOFZjH74uQQMZTvdNf8SbRARHXyyyWmpLHZmpCVUfkpoEhpLLEB/+kkIi
VLoQrIneAs8RriUmVfE6bsFfrfoFxwHmXQejabMTAMGajfQ1cpWGHNBk3RdC5z+6
oSw/v3mIjQCI7U6zONjtfyNdJrDJX4rHHiQP0VAHAyzM8suFt0JHX2baEN6FSUGD
IhJLncnMkjCLRs3Gm0miuY83AhlZWTMHRNh8CUvL6qO4t1ZKn58uotvVG/2ToTm3
ZaoviKqGo67ciO6jThBw1Zos4uq9fa041gY3v2IWkJySuVdYTBLyP+UpasnJQkAj
oApnmiluK01FovsJZPx1vKlNVtP5VLW5KgyJany44WCToJxLVK4tBCe2C4Z6VGEp
27OGpzJ59fa9ce662DY4V5TbaYOKihgpib7ITWMZ25veA/RAFw/KxvU4qA/2kwKv
GbL3YXRB2lJuWLKSJudHwYN6F4ckH+rGpZ68cX9ISluQl1e5GFTsWjbDL4MYOK/i
A41YWX876VvIP45KSkw5o7ZoYDR/gahlcZS+KXju9qjPJQH1X3HG2cpfaVb8jzkq
jYmMadWAmBC9Ux6jJvYPf307bUc4U9agW6CyNUeJ17pEvpI8+UfxsXtYGgrnCR9B
gf/wFfexln6nDt6PyT/V
=lL03
-----END PGP SIGNATURE-----

--SUOF0GtieIMvvwua--
