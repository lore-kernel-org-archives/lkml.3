Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755377Ab3ARXkv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 18:40:51 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:36382 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754976Ab3ARXkt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 18:40:49 -0500
Date: Sat, 19 Jan 2013 10:40:45 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: Linus Walleij <linus.walleij@linaro.org>, <linux-next@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the gpio-lw tree
Message-Id: <20130119104045.80e588ed651f40d8c567b7d6@canb.auug.org.au>
In-Reply-To: <20130118080211.GA8706@S2101-09.ap.freescale.net>
References: <20130118140346.3f9b182aa7daa175b4f136bf@canb.auug.org.au>
	<20130118080211.GA8706@S2101-09.ap.freescale.net>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Sat__19_Jan_2013_10_40_45_+1100_+SoZu7QF06O1Q5_p"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__19_Jan_2013_10_40_45_+1100_+SoZu7QF06O1Q5_p
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Shawn,

On Fri, 18 Jan 2013 16:02:13 +0800 Shawn Guo <shawn.guo@linaro.org> wrote:
>
> My bad, sorry for that.  I just sent a v2 in reply to this message
> for fixing the error.  I spent some time trying to install a ppc64
> toolchain for testing, but unfortunately with on luck.  So Stephen,
> I have to rely on linux-next to give it a test again.  Thanks.

Cross compilers suitable for building kernels are available at
http://www.kernel.org/pub/tools/crosstool/ .  However, in this case, you
probably just need to get the right combination of CONFIG options.  I
will give it a spin early next week.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Sat__19_Jan_2013_10_40_45_+1100_+SoZu7QF06O1Q5_p
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQ+d19AAoJEECxmPOUX5FEvKAQAKSSiAhS460KpmyrD9YAb0dk
bXcIhIY1JzmWzaa1XPYOibhADzwyc9hIe6dulNlmO/4A9r79HeLa3/o+Dx04oV8G
vfduhKfSERdiTazaJ1LhHN/Ig4xfH5ZDQrCtskkngouaP7VYO52ny1iTjsN5z21/
FnqcaZY6uIU4SoceNwxzE/nsQfPeEr986jjkGkkTfGiynaBEejAGF//U7sQhjcJi
Vea6JvI14mtf3suZdWbk7PaO8WtfReqKYNzEyrU49I25fraxAJy2Tr5d06ZD8/O/
xQFcfMLcF/I9MIFxSit+R1zuEJ0/Zqr90QNRfRWuNd0F/mVHyKstoHu9frywS9ZU
Lt9QexSWMXcVaPQBAVUmYzzfWpJdpQ0ykEpgOKBfbmOtFmFkhcx0Kk7qopjOcAYx
JfS9RckIY24UJGRH1VVNVjKICOwYrHG3OejviuErz2Fdt3ZKEvT47hc3n/OTJGtN
BheedfJKzvSvWZRI1iVhq89sggGyX4HCrPLGL7uOte+fifzGh0ZrO6OBsHTyT8my
jGp9hLEMJSHKWBnRfHI4eVh0su8XZQ13TUmpteC9L5XImx2mvtMjJPOLxfgKTRdo
vC4+X0Nk59MldAfV8DoEqJy4UnLuyyRG3ZX7/nVbU5G8lE75MogK4OJNN/upmu9m
/2ZjsI3sBgE1gKpBsyVh
=YlLY
-----END PGP SIGNATURE-----

--Signature=_Sat__19_Jan_2013_10_40_45_+1100_+SoZu7QF06O1Q5_p--
