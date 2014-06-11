Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932646AbaFKQIa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 12:08:30 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:37273 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755864AbaFKQIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 12:08:12 -0400
Date: Wed, 11 Jun 2014 17:07:26 +0100
From: Mark Brown <broonie@kernel.org>
To: Matt Porter <mporter@linaro.org>
Cc: Jassi Brar <jaswinder.singh@linaro.org>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Jassi Brar <jassisinghbrar@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        lkml <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Anna, Suman" <s-anna@ti.com>, Loic Pallardy <loic.pallardy@st.com>,
        LeyFoon Tan <lftan.linux@gmail.com>,
        Craig McGeachie <slapdau@yahoo.com.au>,
        Courtney Cavin <courtney.cavin@sonymobile.com>,
        Rob Herring <robherring2@gmail.com>,
        Josh Cartwright <joshc@codeaurora.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Kumar Gala <galak@codeaurora.org>,
        "ks.giri@samsung.com" <ks.giri@samsung.com>,
        Devicetree List <devicetree@vger.kernel.org>
Message-ID: <20140611160726.GJ5099@sirena.org.uk>
References: <1400134260-3962-1-git-send-email-jaswinder.singh@linaro.org>
 <7978295.UBGxYvcnvH@wuerfel>
 <CAJe_Zhe_VFTpPW0sKBsqit347MR7QmEDvzvQTyh1DWr3v991tg@mail.gmail.com>
 <20140529154348.GH32082@beef>
 <CABb+yY2PiGpqy2uevCFexAKeS4aZxJxZHEDJTRN1SW6VVjBzGQ@mail.gmail.com>
 <20140602151454.GK32082@beef>
 <CABb+yY3ZYqtT+R0PwZDtpW0O0SsbxTyiYmXaseZHoj4Nr6UBPQ@mail.gmail.com>
 <CAPKp9uZTnWCojeZHyvrm=vTuY15dAHiW1CWP18JUfuKU-mfH0Q@mail.gmail.com>
 <CAJe_ZheA_2PwzFGwx2rdba0oVsAKRnwK02XE-8nPY6K5NKpdTw@mail.gmail.com>
 <20140605111205.GD32082@beef>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oQ95xoC0NK0Hccgk"
Content-Disposition: inline
In-Reply-To: <20140605111205.GD32082@beef>
X-Cookie: Ditat Deus.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCHv5 2/4] mailbox: Introduce framework for mailbox
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--oQ95xoC0NK0Hccgk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jun 05, 2014 at 07:12:05AM -0400, Matt Porter wrote:
> On Tue, Jun 03, 2014 at 03:51:55PM +0530, Jassi Brar wrote:

> > BTW, here we at least have a hardware resource to specify in the DT
> > node, there are examples in kernel where the DT nodes are purely
> > virtual. For ex, grep for "linux,spdif-dit". So I think we should be
> > ok.

> There's a bit of a difference between my concern over a virtual node and
> this example you've cited. In the dummy spdif transmitter, it's defining
> a virtual device that plugs in for a codec, a hardware concept well
> defined in the audio bindings. I agree that there are many examples of
> this type of virtual node, including dummy phys, but in all cases they
> are stubbing out a real hardware concept.

Well, really it's an actual physical thing - it's something that appears
in the schematic and can be pointed at on the board but just doesn't
have software control.  From that point of view if the software that's
being interacted with on the remote processor is in ROM/flash which
won't or can't be realistically be updated (which seems to be mostly the
case) then you can reasonably say the same thing.

--oQ95xoC0NK0Hccgk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTmH67AAoJELSic+t+oim9Bt8P/160qN+CPShJ28IiDzmny6PA
AVGJksSE68Q5wbWYyvV0058YND8nksw1E9fm+QeXMjNyk8Et2p/Wle882EIMRo6b
BgpiMxz5yU1Pl49VEUmhit9HIbt0Fi/acibc2YcDHmcxNxjyiuMPC9FL6as9ZBs/
fAkjSL3CXsQaKBhVj5QVJdsvgU7/i1GPrF9wH820NAXDXqDY2aDbKKAFPEV/xJby
03GZ6nrF00+ql2lerazQNqtvPljmEjbU/sLsdO0zdjXnfgZdUtRkILnOBiYT2q+b
0GK9FoNG5LqihQ47I2qa6s0UMyWmPVHgLr5G641845TuGIWnsJrdPB4wF7AkP9Co
bT2ozwOhm4tAK/rsLYUX6WVVX7LSyAN9LgdxouVT6Lr6xwkMgREPJVFFzQ2VKfJf
uSFhNyXyZZzgxuX1JHQkIxq7/sPRp5EYyoIKf0RDJZfu/wnp6PBNu3B1VAKvhEzQ
bCFJen+MG3O+tDgts37qIewR4yErUXwN3zBtnZ6JvTJ/eA5tPo24/E+IAuiyBWK0
6zJmcqK7OIRK9iaAmpju9RMTuPzfxNFKosqPENpaJn/5h9vm+VZpCkukFtCvlBmD
zL4HkyI+hEa8iir46jdhNnMG2QzwBs2m26KIHvT6NWKNuKPpbUDJJ/krD/paiDkB
NTQ6gRwb2wI8LWiLr5LE
=UeEw
-----END PGP SIGNATURE-----

--oQ95xoC0NK0Hccgk--
