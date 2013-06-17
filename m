Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752688Ab3FQWWa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 18:22:30 -0400
Received: from rrcs-24-173-105-85.sw.biz.rr.com ([24.173.105.85]:47780 "EHLO
	mx1.mthode.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751784Ab3FQWW3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 18:22:29 -0400
X-Greylist: delayed 548 seconds by postgrey-1.27 at vger.kernel.org; Mon, 17 Jun 2013 18:22:29 EDT
Message-ID: <51BF8A15.5090506@mthode.org>
Date: Mon, 17 Jun 2013 17:13:41 -0500
From: Matthew Thode <mthode@mthode.org>
Reply-To: mthode@mthode.org
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130520 Thunderbird/17.0.6
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: setting the kernel log console at runtime
X-Enigmail-Version: 1.6a1pre
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="----enig2LUQSKAXVUMKAPKRHKCPA"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2LUQSKAXVUMKAPKRHKCPA
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

I have a server I wish to debug, but wish to set the console at runtime
(I boot with it set, but it gets reset somehow).

I boot with the following on the cmdline
console=3DttyS1 console=3DttyS0 console=3DttyS2 console=3Dtty0

But end up with the following in /proc/consoles (I need to log to ttyS0
in particular).
tty0                 -WU (EC p  )    4:1
netcon0              -W- (E     )
ttyS1                -W- (E  p a)    4:65

Here's my printk just in case you ask as well :D
8	4	1	7

How would I go about setting the kernel log console without a reboot?

--=20
-- Matthew Thode


------enig2LUQSKAXVUMKAPKRHKCPA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRv4obAAoJECRx6z5ArFrDPj4QAK6mWYTufu0LnoIwY5PM46Jg
/pdC/4W37lppiY7mV9JJK1sYiq0oBmj/3jYsJopop1+Bf4/BASnL0SGK7ARa653x
WyzHInqjhRzRNcbPLBugQD8eMbGliamdK14MqJIcp4gK3/VUMcoVGktrFHqnkKHj
TOGUEvT5ZBaf8mzsGND4S1dlYCy6TYqn+y8J1kpX39esPedlCaRNzOmhlhs5Kt5o
LgUXq1rSX3HrR9kZr0wOZW++r6Y+a5z7+Yl5LrbPNpfAquzL4dwdueU5SyFELR8K
N9jGdgW61w5DNf9WVVf9jcXC+HpQM5Ggsup2yibyFhVKXlzTUo46Yg7DinVgSD57
xEGfM3Ex53aHMY5224tDKlLynXk2rJ+cu7rSkXOPD44HmR03ZDySzFMWxBg1fOcZ
jhIPF7bS3ztTbYjiWcIK8h2NN3rJtlGGrSRECbIjHqb+/J+ViVma3trEipxtpSKL
Gd7+cTxiHR8Ulbe3if8GQ9WoXNaHerIi8dbb9AujKaVkngKOAX9Z7YIJCAcATEy2
EdRBnAfNjS8jhsDjvRoUPCqxu5GUMLZa9tGiYoZM301O0Bg12Utba97zzJ560DOr
+HR+AO19LSl9F2hjbhlCmdVPyGcI9JBMxAhp5ISBjhOgAQJytdYRAjphindmJ/hL
ySQxavwPW6iw9bE9rnSs
=eFyG
-----END PGP SIGNATURE-----

------enig2LUQSKAXVUMKAPKRHKCPA--
