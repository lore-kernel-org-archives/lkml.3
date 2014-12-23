Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756562AbaLWXpF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 18:45:05 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:57850 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751256AbaLWXpD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 18:45:03 -0500
Date: Tue, 23 Dec 2014 17:44:36 -0600
From: Felipe Balbi <balbi@ti.com>
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
CC: "balbi@ti.com" <balbi@ti.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peter Chen <peter.chen@freescale.com>,
        Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 06/17] net2280: Remove restart_dma inline function
 definition
Message-ID: <20141223234436.GA32702@saruman>
Reply-To: <balbi@ti.com>
References: <1417182662-7405-1-git-send-email-ricardo.ribalda@gmail.com>
 <1417182662-7405-7-git-send-email-ricardo.ribalda@gmail.com>
 <54788AC3.9090808@cogentembedded.com>
 <CAPybu_1R+L91kGTG1sHhKiChd3v7=wa70v2VWDrQ-TH1FYyxSQ@mail.gmail.com>
 <5478D810.3060101@cogentembedded.com>
 <20141223184407.GK9147@saruman>
 <CAPybu_2gkQ0TzkO+twAnvp8WJzdWsPkdCvALoHauB223V0-yWQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VbJkn9YxBvnuCH5J"
Content-Disposition: inline
In-Reply-To: <CAPybu_2gkQ0TzkO+twAnvp8WJzdWsPkdCvALoHauB223V0-yWQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--VbJkn9YxBvnuCH5J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

(top-post :-)

On Tue, Dec 23, 2014 at 09:20:23PM +0100, Ricardo Ribalda Delgado wrote:
> Hello Felipe
>=20
> I was waiting for more comments for the other patches and I forgot to
> resend this patch.
>=20
> I am on holidays and without access to a computer with the right
> tools, nevertheless , since the changes are only on the commit message
> I have modified the patch with vi.
>=20
> I have been very careful, but I cannot try to apply it. If it does not
> work, please feel free to modify it yourself (if you want) or wait
> until I am back

I very much like this series, quite a bit of code removed and things
which were already default are now only option. Very good work. It's now
all on my testing/next

cheers

--=20
balbi

--VbJkn9YxBvnuCH5J
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUmf5kAAoJEIaOsuA1yqREmw0P/RuEbz20YLpGZRK/feg1bBP0
0PZKY5aX4seOS+yNiorGlvXnfVf65YM+bkE0bW+hZE6CF8wqNcyqNKNKpY1zSmAI
LUJyQiBsjB4OuNCnnpyvk6YNRXTUIkEfnobZl8oLZAN61NC/UqpvgdKSVDjAJr/u
bjcQ/VHAlWLG15Iyo6ewZATmd5BOEu0rLGPmbPM6/1qQy0Ay5Wo0mGR3qSfJkRnb
zFAtXCVtpEYtwmJ6qQsuXtTLHlB+62lFKvcWK35C0COquPsUenaxWLJsV88Y5HX6
Ze2C5YjgszPkQBs5ttXdJZlDZ3/mUH1RmYF82mcmNX+O/yVTjACboFeRk75DNFqH
SyM/xxQzsiGIPz4jTEW3Z/2c1FRfB/5aQy5AL/5JBC2ZWFcLpDaKIWVcNMPseHJq
AQCZpx+uBh6qW9fmOTHFn9lfVseoJnxCGeGkMnJQsLgo+sSgNk7j6jB+lbCNegJL
Qf5Hplqld0kdSBNru2xE/WCM27b8n2jdIGz2zDH3UAgXI/K5Y4SMk1DKpk2uSXck
FEB2rcZMo1+gmsotjASAqy/84fQI0fWUR+kRBBCbebjZmj8vFEi/kr8OtsUsv9v2
/cSG1Xm3lodnTEC7HnFRbqIHPcwYXE2H3YqP0fv0KDN7mizy6Z8XH83+v/4eEPXs
q5iTuxJnuGYBpzySURZ2
=i9hT
-----END PGP SIGNATURE-----

--VbJkn9YxBvnuCH5J--
