Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754113AbaI2RiO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 13:38:14 -0400
Received: from omr1.cc.vt.edu ([198.82.141.52]:59049 "EHLO omr1.cc.vt.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753249AbaI2RiM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 13:38:12 -0400
X-Mailer: exmh version 2.8.0 04/21/2012 with nmh-1.6+dev
To: Andy Lutomirski <luto@amacapital.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Tightening up rdpmc permissions?
In-Reply-To: Your message of "Mon, 29 Sep 2014 09:39:16 -0700."
             <CALCETrU3nNvG6+-7iScYT8LDRFnq8kYnpK0cdW1bgW5O4EGrUg@mail.gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <CALCETrU3nNvG6+-7iScYT8LDRFnq8kYnpK0cdW1bgW5O4EGrUg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1412012181_2318P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 29 Sep 2014 13:36:22 -0400
Message-ID: <9930.1412012182@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1412012181_2318P
Content-Type: text/plain; charset=us-ascii

On Mon, 29 Sep 2014 09:39:16 -0700, Andy Lutomirski said:

> Would it make sense to restrict rdpmc to tasks that are in mms that
> have a perf_event mapping?  After all, unless I misunderstand
> something, user code can't reliably use rdpmc unless they've mapped a
> perf_event object to check the rdpmc bit and figure out what ecx value
> to use.

Wouldn't that be trivially easy for an attacker to bypass? Just map a dummy
perf_event object  and then go to town?

--==_Exmh_1412012181_2318P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBVCmYlQdmEQWDXROgAQJyFA//enFNilqa4+HBkAK48ZG9i2YmyojtcGTL
AXAuT3XHq979DYzlZcxnaKnWD4DV87fUZgig10Sk5ziAecLhzI7wRcSLpbje/aBN
mPwyzD4Qt8DH2kw+4rkNliZQI163fcpGHhxMArHgs2U95PKkeP+1ZTdNqsiTamTp
ziPf1wcdIxZqc87G/KwEgYALbjVb5Nzdj061FxFDbBOyEMLWmSQvLWhPMFNKljpp
m1IB7udKHr1Z+suOrhwPkKLNBppEiE8FSjuxEJpgJKn1+bE037dB3kRi+P+/CKBS
xUoOsO31d4Mp446tDlqBbZkp4aIR3lnTU7WcgYYvYmC2nF42y+5E5P0W558yXnJ1
gEF4m90o392/9EnVB3InTC0c6KxKHt1zNEoJIIB/TWSHXTxpzKVt+JkblK80T7WH
JIDQTL2Xn21lMX7fGeEBm9wlvHKU29zAT/A8ISzPNUACtxKAyzcQJ2YIOjYZSSON
uRUbufgIZdMF1uukp13g8XRedsfQ8aPc04B2PCe1WZoeRZNW/b93thdDeZPKU7ZB
Svlip91Rd3AOMq1Ts0naMQfc4au44hnsHSap29iFRSNCGDJ0RAzC3sUjzoVSZw2O
FHam8IW2tlphvf8fb6dkrlRWeQGMSOUFBoyENwCPhcTTQRiK093cj8kfWJJ48/1f
oQmWlIkSfYs=
=zAL1
-----END PGP SIGNATURE-----

--==_Exmh_1412012181_2318P--
