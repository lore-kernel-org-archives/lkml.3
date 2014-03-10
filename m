Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754430AbaCJTjb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 15:39:31 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54690 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754360AbaCJTj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 15:39:29 -0400
Message-ID: <1394480354.23624.7.camel@deadeye.wl.decadent.org.uk>
Subject: Re: perf: Add support for full Intel event lists
From: Ben Hutchings <ben@decadent.org.uk>
To: Andi Kleen <andi@firstfloor.org>
Cc: acme@infradead.org, mingo@kernel.org, linux-kernel@vger.kernel.org,
        peterz@infradead.org, eranian@google.com, namhyung@kernel.org,
        jolsa@redhat.com
Date: Mon, 10 Mar 2014 19:39:14 +0000
In-Reply-To: <1394048978-15909-1-git-send-email-andi@firstfloor.org>
References: <1394048978-15909-1-git-send-email-andi@firstfloor.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-60GZ2KD/5FkmIB5peU6F"
X-Mailer: Evolution 3.8.5-2+b3 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.245
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-60GZ2KD/5FkmIB5peU6F
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2014-03-05 at 11:49 -0800, Andi Kleen wrote:
[...]
> I implemented an automatic downloader to get the event file for the
> current CPU.  The events are stored in ~/.events.
[...]

This directory should be placed under $XDG_CACHE_DIR (default:
~/.cache), and should have a more specific name like 'perf-events'.

It might be useful to also support a system directory for these,
under /var/cache.

Ben.

--=20
Ben Hutchings
Computers are not intelligent.	They only think they are.

--=-60GZ2KD/5FkmIB5peU6F
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUAUx4U4ue/yOyVhhEJAQr5rRAAlkcHDHt1bAo4RbFbEPCjuPy88nMmFF79
EWvu1wpHdwiGzgHQNwKGW9R3QuFbxjFmwrrR5IHKTKHnBT96wq5PODGuD2LMPom6
N+I5tcNHKqpUF7Bi46pnaOJ3GQJh+UOWt3Ip5b38aHBELNyZsQor3Tu+HZ88/0qt
HbfC8WOcxHSX5FjE009Q3YsUsDgTA0eTFRSu0eGQqrUyAoPgK2hGBbi+TD30DyHE
yHKL0kOeOpLPOaiWUNJJCfw/rs5F7sQZYhO/xB/CCsFXDiyTTZcr/L05MMAAnimk
OO0+Skc1rcQgzKoLl+x9f0K5fdpuCfhSkezQUlvB+SkHEpLIjAwjfp7LLmaaJB4n
N4k5Og00dtp+pP9q66XB+mITXZwYyIIJuHYTv41WdQiJTHX16m26CBTEjSsKF61q
8MHsjYn1ym+trQXDj3d13MyVmncKMPr/96uqlsJGY52DhPKIQEguRW5F899mA70y
q6qQRa3hS6qATkcamXO8XlWPW20b83ZuTKbqiBS87w1Pu/cApDT1WFttHEEEsdZr
oLLB9ojw74+Q+3hEGegEDoW84NINVLjmwl59q8SGhHuFEKqQcyya1mHPMIud8Nx9
UDfxwuxtC1CpFiyNHrfHUXRuZpvB9YOCVXEt2ziDuLjMsGx+82B920rKE06NOOxG
tH13cYaYLsI=
=n1O+
-----END PGP SIGNATURE-----

--=-60GZ2KD/5FkmIB5peU6F--
