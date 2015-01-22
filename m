Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753260AbbAVPzK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 10:55:10 -0500
Received: from down.free-electrons.com ([37.187.137.238]:44694 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751660AbbAVPzF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 10:55:05 -0500
Date: Thu, 22 Jan 2015 16:50:36 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Vishnu Patekar <vishnupatekar0510@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-sunxi@googlegroups.com" <linux-sunxi@googlegroups.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH v4 3/5] ARM: sunxi: dts: Add PS2 nodes to dtsi for A10
 and A20
Message-ID: <20150122155036.GQ4367@lukather>
References: <1421417021-3247-1-git-send-email-vishnupatekar0510@gmail.com>
 <1421417021-3247-4-git-send-email-vishnupatekar0510@gmail.com>
 <20150120200216.GV4367@lukather>
 <CAEzqOZsX-o9HqtjpBKH48S-R+GDzN=kzrfSqC54s4bGxpDf7kA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HbrDUOEqlDe4KvYA"
Content-Disposition: inline
In-Reply-To: <CAEzqOZsX-o9HqtjpBKH48S-R+GDzN=kzrfSqC54s4bGxpDf7kA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--HbrDUOEqlDe4KvYA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 21, 2015 at 04:40:28PM +0530, Vishnu Patekar wrote:
> On Wed, Jan 21, 2015 at 1:32 AM, Maxime Ripard
> <maxime.ripard@free-electrons.com> wrote:
> > Hi Vishnu,
> >
> > On Fri, Jan 16, 2015 at 07:33:39PM +0530, Vishnu Patekar wrote:
> >> Signed-off-by: VishnuPatekar <vishnupatekar0510@gmail.com>
> >> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> >
> > Why is there Hans Signed-off here?
> Hans has modified the A10 dtsi and also tested on A10 board.
> Shouldn't I add him as Signed-off?

Yeah, you should :)

Thanks,
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--HbrDUOEqlDe4KvYA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUwRxMAAoJEBx+YmzsjxAgEkUP/3cNgV0Z0UbZ0t+Wqp5TNrFB
wlBP1pZjNTcsEzD/fsaMM9zZ++RDSnCtD7dmq4K0n9cI0FHWip92MajmxhGF9vvb
lwOKlMgG1Io+68zHrNCMb+rCalDJG1jTBUTtnz/M3qrjusngiazbxpHj57v/Fv2f
goEbfBZPw8JuNW1nOYT2DTcDpW0oirryiw36XW85w5kZ7A/ka0mVQ/DSHfNyeSRj
+aUPVpAVkOmTP1r/RxowSvWCDkEQbrSgNe674C8jbhCtGMrR2eJmMcMRjFZmYetS
PpibHiuimKNuWZK9WwSxudnFfORKoSd30lXlHsKDW+BPx4LZNDNf0m92sPTB37uf
/K/d2DS/FbzpLMA1XtLpp1yDD5cgDiT6taG3Zu+Yx5tKBGnq+YqT81wN8sMXnUBJ
aBv62fwS/LbWYLaAej9XzRqYXkkuHn88YZ9OqsaIU8FRr6kY+gycQmpyJtqHKEpd
QZ3L0n3FE45ENe+UH8pb8qoTLhbJBHHVXv8gLokt3LpL0Qbndf19P5BIRygAu4ej
HVhmLo/VDlTqqw5UDND3u8jlOJ8HnL/yWrnKGS9v+UqhNRewMJZ61zQzRx/tZW44
a6g82FKA+GW8OGeH8abQoGWwjMhovYcYSSzuYfOypadn3yZCtiNs1Xa8XY8ogGPd
ERyG1xoLjQsoY8IycETP
=TZbk
-----END PGP SIGNATURE-----

--HbrDUOEqlDe4KvYA--
