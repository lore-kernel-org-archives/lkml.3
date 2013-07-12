Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756987Ab3GLG6D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 02:58:03 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:53969 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752994Ab3GLG6B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 02:58:01 -0400
Date: Fri, 12 Jul 2013 09:57:34 +0300
From: Felipe Balbi <balbi@ti.com>
To: Julius Werner <jwerner@chromium.org>
CC: <balbi@ti.com>, LKML <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-samsung-soc@vger.kernel.org>,
        Vivek Gautam <gautam.vivek@samsung.com>,
        Praveen Paneri <p.paneri@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Tushar Behera <tushar.behera@linaro.org>,
        Doug Anderson <dianders@chromium.org>,
        Olof Johansson <olofj@chromium.org>,
        Vincent Palatin <vpalatin@chromium.org>
Subject: Re: [PATCH] usb: phy: samsung-usb2: Toggle HSIC GPIO from device tree
Message-ID: <20130712065734.GE31802@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1373416455-30358-1-git-send-email-jwerner@chromium.org>
 <20130710052534.GB15674@arwen.pp.htv.fi>
 <CAODwPW9dmwpXeyBeVER9azsh2uW3NXLTbDtz3mJaXrvSwb6opg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+jhVVhN62yS6hEJ8"
Content-Disposition: inline
In-Reply-To: <CAODwPW9dmwpXeyBeVER9azsh2uW3NXLTbDtz3mJaXrvSwb6opg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--+jhVVhN62yS6hEJ8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Jul 10, 2013 at 10:42:27AM -0700, Julius Werner wrote:
> Hi Felipe,
>=20
> This is intended to pull down a reset signal line, not to switch power
> to the device. I could implement that with the regulator framework
> too, but I think that would just be confusing and harder to understand
> without providing any benefit. It's really just a plain old GPIO.

alright, in that case how about using drivers/reset/ ?

--=20
balbi

--+jhVVhN62yS6hEJ8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR36jeAAoJEIaOsuA1yqREPkgP/isbYeG4jRaimYMNBWfhFKpI
9ZA3AWoO9oYP9W8iFd0Ss4xnbDpUzp2iKlyux+7D2brMmUihwforDJjGYhGs70P7
KW3bO1JuUyvjGc2T+Zu/RsRdwfOr/m0YaRvVIuRs5BtvB1qPVpdGi3TLD758+stV
tRW+UX30KARKnClQXnTrnXeeArd2Wie7IOI05c2+y9PK6/RCWgENsC3qZQxxTQZR
mDBUxe+Xtna7ZM7xGvBcKrrMUlc/796LJP8DKK5j5of4FaKOWcP8aZN4o9d1Fez4
CdB7rv8BJcu/Pa6VUjl3VRvo+My7cnhvAnWxobclyPVoj1hkXU4o5KMH4ydH0WnQ
hx0YKm4Kf/5k2LZRUhFnUE6KujR7R7AJrcOlNyfvJ3EKdbllWESuls+umMIRfvlT
CLun+XMGMqk8AqkUD/orYKJC1LsDCTtyRfXPFTvleAuR2/v2zusv/XBfjOTyp5LA
wNGEoWt1/QY8SoKfIOSNcYNLHVJJAf3/E+neCKwBaqQOW8HDJzx+oXVRIORaJUVD
VvRBDEt07S4/q5lCaKhTouliCyEDOolh8CXVc0/GovQfYv6eheddfgj4gPbwUFR3
TWfrUImfuJzmZeggbPb271lMrPaMyC80IWb03s83q9Q9CDOr6/OiE3DboWZvx31/
+8mbayC5LH6iUxbCSbRb
=rrdx
-----END PGP SIGNATURE-----

--+jhVVhN62yS6hEJ8--
