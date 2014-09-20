Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757699AbaITVh1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2014 17:37:27 -0400
Received: from mail-qa0-f51.google.com ([209.85.216.51]:59661 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755718AbaITVhZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2014 17:37:25 -0400
From: Ben Gamari <bgamari.foss@gmail.com>
To: Boris BREZILLON <b.brezillon@overkiz.com>
Cc: Rob Landley <rob@landley.net>, Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Jiri Prchal <jiri.prchal@aksignal.cz>,
        Mark Rutland <mark.rutland@arm.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-gpio@vger.kernel.org,
        devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [RFC PATCH] gpio: add GPIO hogging mechanism
In-Reply-To: <20131219164109.GB27409@kroah.com>
References: <1387463671-1164-1-git-send-email-b.brezillon@overkiz.com> <1387463671-1164-2-git-send-email-b.brezillon@overkiz.com> <20131219164109.GB27409@kroah.com>
User-Agent: Notmuch/0.18+69~g2295f35 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Sat, 20 Sep 2014 17:37:19 -0400
Message-ID: <87fvfmynw0.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain

Hi Boris,

I'm just returning to this now.


Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:

> I don't understand what makes GPIO's "special" enough to get included in
> the driver core like this, and called for each and every device that is
> added to the system.
>
I'm also a bit confused why GPIOs ended up in the driver core but
perhaps I'm missing something. What was your motivation here?

Cheers,

- Ben

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBAgAGBQJUHfOPAAoJEErkyLZmeNiD/ucIAKfJqb41jB7GYeFrwAQ6nP0L
M7s45uYdzwLj4OSd2UAxqZ+4wOcFRs8pim78cGIhelnVa/da94WYLiUARLW80OPq
yZQ4xZY5c1O1tI882lvsiE1lmHLKtlm4mzfQPjJ0xHgmBnF/kfkbsOIL3qHofiau
Tvd5GBBEIc2KpIk7pN8QR1X1sNS5QUembBeVARA8QDZeEiOuLUUYA1UZbRQr2iFd
jrwW1W6E3yji31Get4SB7TDTMtsunu5o8XnX0KSaEeqK5TZylHVTELcJX8gehetJ
XrMO1Z9H20+sION0d4M8gHyfIC04G1q+aSsIrqje3iQuFlQDqMBr7VP0otxW4/4=
=KM9x
-----END PGP SIGNATURE-----
--=-=-=--
