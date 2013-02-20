Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751412Ab3BTWtM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 17:49:12 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:34962 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026Ab3BTWtK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 17:49:10 -0500
X-Mailer: exmh version 2.8.0 04/21/2012 with nmh-1.4-dev
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Wonky PS2-USB converter issues...
From: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1361400518_1911P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 20 Feb 2013 17:48:38 -0500
Message-ID: <21767.1361400518@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=dagger.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020201.512552C6.0153,ss=1,re=0.000,fgs=0,
	ip=0.0.0.0,
	so=2011-07-25 19:15:43,
	dmn=2011-05-27 18:58:46,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1361400518_1911P
Content-Type: text/plain; charset=us-ascii

Quite some time ago, I posted about a problematic PS2-USB converter
that I used to connect an old PS2-connector keyboard to my laptop
dock, where the keyboard wouldn't be recognized at boot unless
I unplugged and reconnected it.

Well, I've recently figured out (partly by obtaining a converter
from a different vendor) that the converters both work correctly
when plugged into a USB port that's physically on my Dell Latitude
laptop - but they have issues and require a reconnect cycle when
plugged into the docking station for the laptop. (It took a long time
to figure this out, because *of course* you plug this sort of stuff
into the docking station specifically so you don't have to plug it
in every morning).

So obviously, it isn't the converter that is the problem, but the docking
station is doing "something stupid".  Anybody have suggestions on figuring out
what it's doing wrong?


--==_Exmh_1361400518_1911P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBUSVSxQdmEQWDXROgAQJ6TQ//ft0djWqMTAuMpYylSTYMNeh2OXyOsqib
YXlEKA7/mYrwryXYja1TLyJx+ZcbE5FEKgcW6LBlmvOBEEUGIw9bLp/IKMRu2igU
YCg0eKm+BrCBzpZFV8AZwJkM27QF1EbWI+F1urXuKoIyPvw8AX2s50Z1zAodhg6J
vkM3AG2zzWtpM2o1nchTnVGaAIvcBtY6G1b4X1gMtHW9VZ8VNs5oLoXWHLr7VhPt
gH9nrHoAuTLI5btSpk3lV0QCCrFahUYleNv3xMZmcQ2ya/CX7BP+UDDX+kcv/i8p
j6lbrq1uKW/XoHvcnoLoc2Jv5bLuEgSGM3M9rNjotqpjP7SDG4DcT9YB3M8sAQFJ
ke0/fCbG7tWqYeOnPAh0Zk8eiCY6iErXVUWFsG6iBRb9xu0Sdc2dJ6v/ur8lyDN/
xBCkCMbNpNYEudtjdClDwr0u/U621J6LQX2iYBMEoX6qKlPyo1g4oUlcrsxWl/OU
VZBQcOjbPiOefY1mK/1bgvGN5lcpw2i7RjJOGEZQCSI7VIoR89MY19+qJs31YKEL
crvz9WHteH5VnV6BaYnWPDyXtsuz0uSovZ41OXvWl1p5I62FoE7uMLiIkSzVSfEz
cuicst7TZ08AjttXq1qoLlHOjdjaOtc53MMz0djidUzojo2jyJAhc9smg02sJ9uA
8055ws36VPU=
=/2hU
-----END PGP SIGNATURE-----

--==_Exmh_1361400518_1911P--

