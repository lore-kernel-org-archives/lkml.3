Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753174AbaEZPft (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 11:35:49 -0400
Received: from romulus.wittsend.com ([130.205.32.3]:53640 "EHLO
	romulus.wittsend.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753180AbaEZPfn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 11:35:43 -0400
Message-ID: <1401118325.7572.82.camel@canyon.ip6.wittsend.com>
Subject: Re: [lxc-devel] [RFC PATCH 11/11] loop: Allow priveleged operations
 for root in the namespace which owns a device
From: "Michael H. Warfield" <mhw@WittsEnd.com>
Reply-To: mhw@WittsEnd.com
To: LXC development mailing-list <lxc-devel@lists.linuxcontainers.org>
Cc: "Michael H.Warfield" <mhw@WittsEnd.com>, Marian Marinov <mm@1h.com>,
        Jens Axboe <axboe@kernel.dk>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Date: Mon, 26 May 2014 11:32:05 -0400
In-Reply-To: <20140526091614.GA13666@ubuntu-mba51>
References: <1400103299-144589-1-git-send-email-seth.forshee@canonical.com>
	 <1400103299-144589-12-git-send-email-seth.forshee@canonical.com>
	 <537EE129.1020603@1h.com> <20140526091614.GA13666@ubuntu-mba51>
Organization: Thaumaturgy & Speculums Technology
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-Kfe4mcxTS8ZwNLMY4/4g"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
X-WittsEnd-MailScanner-Information: Please contact the ISP for more information
X-WittsEnd-MailScanner-ID: s4QFW6qp003751
X-WittsEnd-MailScanner: Found to be clean
X-WittsEnd-MailScanner-From: mhw@wittsend.com
X-WittsEnd-MailScanner-Watermark: 1401723130.09026@gkjpo6ee3Y8E+ASnmA++AA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Kfe4mcxTS8ZwNLMY4/4g
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2014-05-26 at 11:16 +0200, Seth Forshee wrote:
> On Fri, May 23, 2014 at 08:48:25AM +0300, Marian Marinov wrote:
> > -----BEGIN PGP SIGNED MESSAGE-----
> > Hash: SHA1
> >=20
> > One question about this patch.
> >=20
> > Why don't you use the devices cgroup check if the root user in that nam=
espace is allowed to use this device?
> >=20
> > This way you can be sure that the root in that namespace can not access=
 devices to which the host system did not gave
> > him access to.

> That might be possible, but I don't want to require something on the
> host to whitelist the device for the container. Then loop would need to
> automatically add the device to devices.allow, which doesn't seem
> desirable to me. But I'm not entirely opposed to the idea if others
> think this is a better way to go.

I don't see any safe way to avoid it.  The host has to be in control of
what devices can and can not be accessed by the container.

> Seth

Regards,
Mike
--=20
Michael H. Warfield (AI4NB) | (770) 978-7061 |  mhw@WittsEnd.com
   /\/\|=3Dmhw=3D|\/\/          | (678) 463-0932 |  http://www.wittsend.com=
/mhw/
   NIC whois: MHW9          | An optimist believes we live in the best of a=
ll
 PGP Key: 0x674627FF        | possible worlds.  A pessimist is sure of it!


--=-Kfe4mcxTS8ZwNLMY4/4g
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQEVAwUAU4NedcDrlnVnRif/AQglggf+Iu35K45u4EYY+LCEQdUPuokcXDkWWajp
rQr2A1BB7xBWz8SIG8seIMdYmMBEyFBEf8lIQDMg3tzrfK1evXaLv8DV9cRtAzDG
qcv5Y3g77zfTuH2G3v3qkA0m4+Mr0+iAFtWDpx2c5MqG8JikS958vWrI+zUkEzJe
QBIoKkGxrNsJMcbWPkalFaYPDRiDUSAi8pVfeSvtx3NZ3Svyp0Oq1IHAEBbHcCpr
sG5In/w4SqujbkXgw0McQqVlVXJ2co44ZdShHP8ObwB9BURlc+brKkiRslIHEze4
xFrZBblVeCnHMpCr7TTjmME8s86efOwkV0pSWB6plHtkHotq4kT2JA==
=Jpae
-----END PGP SIGNATURE-----

--=-Kfe4mcxTS8ZwNLMY4/4g--

