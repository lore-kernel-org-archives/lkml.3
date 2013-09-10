Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751946Ab3IJUOw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 16:14:52 -0400
Received: from catbert.rellim.com ([204.17.205.1]:49977 "EHLO
	catbert.rellim.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485Ab3IJUOv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 16:14:51 -0400
X-Greylist: delayed 690 seconds by postgrey-1.27 at vger.kernel.org; Tue, 10 Sep 2013 16:14:51 EDT
X-DKIM: OpenDKIM Filter v2.6.7 catbert.rellim.com r8AK2ZG9028308
Date: Tue, 10 Sep 2013 13:02:34 -0700
From: "Gary E. Miller" <gem@rellim.com>
To: Rodolfo Giometti <giometti@enneenne.com>
Cc: Paul Chavent <Paul.Chavent@onera.fr>, linux-usb@vger.kernel.org,
        gregkh@linuxfoundation.org, jhovold@gmail.com,
        fschaefer.oss@googlemail.com, jslaby@suse.cz, max@suse.de,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] Enable PPS reporting for USB serial devices
Message-ID: <20130910130234.5106a5bc.gem@rellim.com>
In-Reply-To: <20130910073105.GB5030@enneenne.com>
References: <1378742480-2146-1-git-send-email-paul.chavent@onera.fr>
	<20130910073105.GB5030@enneenne.com>
Organization: Rellim
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.17; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/J/GK1Vgcy9PykKEOOXx7.VW"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/J/GK1Vgcy9PykKEOOXx7.VW
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Yo Rodolfo!

On Tue, 10 Sep 2013 09:31:05 +0200
Rodolfo Giometti <giometti@enneenne.com> wrote:

> I have nothing against with this solution but consider that reporting
> a PPS signal through USB bus may add unknown delays that may vanish
> clock stability... as far as I know you should not use USB serial port
> with PPS. Have you some statistics about clock stability in a real
> implementation?

gpsd project has been using PPS over USB 1.1 for over a year.  Typical
accuracy and repeatability in the range of +/- 1 milliSec.  This is much
better than you can get using simple ntp over gigabit ethernet to an
adjacent stratum 1 server.

Sure PPS over a local UART is 10 to 100 times better, but often PPS
over USB is your best second choice.  As serial ports become extinct
it may become your best choice.

RGDS
GARY
---------------------------------------------------------------------------
Gary E. Miller Rellim 109 NW Wilmington Ave., Suite E, Bend, OR 97701
	gem@rellim.com  Tel:+1(541)382-8588

--Sig_/J/GK1Vgcy9PykKEOOXx7.VW
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQEcBAEBAgAGBQJSL3raAAoJEA0O2UlB0XnYih8IAISSauU3exhI0UtPLX/0IHPF
uX+c7ZboqXxbZ5Fid7zS+7mf3BVzkpmIeQOYQ23VP0mAiZ19BjvZAvqR199uq1mR
YoCuiypWSfZyYv3UbgMdhSC6SQOuFNartZzswnVA0YvYImsOI1Qlw1/3/Sd5SrCt
6D/+4MaJEDe8yX/3aJ06a0ro9Som7DLJEXV3WRlKrSni6rwtEbIva0uhvIjgbllw
123MCtpYDuT2HQpLiBWONeO7ma5uvf+5DsYjE2mnr9ozMd/8LXtZF0Nuzcp9B3ZP
HMvU3NOebnN/WS6ackpsmBFsdMgZiTfcJccN1ThdNRq6myk6vGl6sCC9qcXSGq4=
=CJgr
-----END PGP SIGNATURE-----

--Sig_/J/GK1Vgcy9PykKEOOXx7.VW--
