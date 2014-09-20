Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751374AbaITW1D (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2014 18:27:03 -0400
Received: from mail-qc0-f175.google.com ([209.85.216.175]:62935 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750889AbaITW07 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2014 18:26:59 -0400
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
In-Reply-To: <87fvfmynw0.fsf@gmail.com>
References: <1387463671-1164-1-git-send-email-b.brezillon@overkiz.com> <1387463671-1164-2-git-send-email-b.brezillon@overkiz.com> <20131219164109.GB27409@kroah.com> <87fvfmynw0.fsf@gmail.com>
User-Agent: Notmuch/0.18+69~g2295f35 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Sat, 20 Sep 2014 18:26:54 -0400
Message-ID: <87a95uylld.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain

Ben Gamari <bgamari.foss@gmail.com> writes:

> Hi Boris,
>
> I'm just returning to this now.
>
>
> Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:
>
>> I don't understand what makes GPIO's "special" enough to get included in
>> the driver core like this, and called for each and every device that is
>> added to the system.
>>
> I'm also a bit confused why GPIOs ended up in the driver core but
> perhaps I'm missing something. What was your motivation here?
>
Somehow I overlooked the message in which you responded to this. Ignore
the above.

Cheers,

- Ben

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBAgAGBQJUHf8uAAoJEErkyLZmeNiDA3QH+wRXGjXScBmI5Urn09LLfQX+
XSkYi9g9MB93LRhdpHdJ5RINzR4BdfqmUXn6M8oia16OiaoxMHdA/o5HmJGUWYBr
5+gf4wAkc7xtefV2KMmkeH44u7tpdpLvyRv/NALdSjsl68fefk8k+q6/LqrSOmOH
0Dqz6rq6TvEHoONoX6yzs1cgl3zTXdIxmQYgL44w/+q6vQRjEkOiXUV/0LRY+EkD
jex4wmKbfPVdHATLw5Rn9CIaLFMBXHb/GaynSEOtpzLicClKgwgUQn4iVuniMvp/
/gbymKQy5dxfztLqmdD8H46YWC1CtbWQNUqlOue3EMkH2edAQ/mRC/pPWFnIcGY=
=UOUS
-----END PGP SIGNATURE-----
--=-=-=--
