Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755238Ab3IITBt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 15:01:49 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:52823 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752580Ab3IITBr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 15:01:47 -0400
X-Mailer: exmh version 2.8.0 04/21/2012 with nmh-1.5+dev
To: David Lang <david@lang.hm>
Cc: Matthew Garrett <matthew.garrett@nebula.com>, linux-kernel@vger.kernel.org,
        keescook@chromium.org, gregkh@linuxfoundation.org, hpa@zytor.com,
        linux-efi@vger.kernel.org, jmorris@namei.org,
        linux-security-module@vger.kernel.org
Subject: Re: [PATCH 00/12] One more attempt at useful kernel lockdown
In-Reply-To: Your message of "Mon, 09 Sep 2013 11:25:38 -0700."
             <alpine.DEB.2.02.1309091119330.2479@nftneq.ynat.uz>
From: Valdis.Kletnieks@vt.edu
References: <1378741786-18430-1-git-send-email-matthew.garrett@nebula.com> <19562.1378747124@turing-police.cc.vt.edu>
            <alpine.DEB.2.02.1309091119330.2479@nftneq.ynat.uz>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1378753264_1775P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 09 Sep 2013 15:01:04 -0400
Message-ID: <27562.1378753264@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1378753264_1775P
Content-Type: text/plain; charset=us-ascii

On Mon, 09 Sep 2013 11:25:38 -0700, David Lang said:

> Given that we know that people want signed binaries without blocking kexec, you
> should have '1' just enforce module signing and '2' (or higher) implement a full
> lockdown including kexec.

> Or, eliminate the -1  permanently insecure option and make this a bitmask, if
> someone wants to enable every possible lockdown, have them set it to "all 1's",
> define the bits only as you need them.

This strikes me as much more workable than one big sledgehammer.

--==_Exmh_1378753264_1775P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBUi4a7wdmEQWDXROgAQIX0xAAuoOiWQHKPd0PAvZL3IbV00dg2Npv4rh1
PZTCVa/DDaOzZCSblRF83sqo4ElKFt3Oe8rZ8ewxRzKR8/L3QYKCrCtRjfb76Yyr
NT92Ez3UA8H+qgyPmbMeN6u2ZQ22jjbznMpmf4jQCycFqW473TsAxk3cdQ3DhWdD
yJgXqeucxWLL9YYD1NkBB/A5iWIacjpRd3nW8m3++0kkTqYbW17nUGyyuq3H+M4U
M+3sIjMPaqzcTzeYti3criqhuudY2v1lO3kh65J5yZzRcO0zC974LYlkZQ4JEpsq
GXhClJtKcgSdn53Ki0JuIAVZtoy59mcAIJOEh3INMK+/zPz77d5ZoQHM3bpNLXoY
ow2vgWVfLxmVCtKGT8ohf4yE1T/w7Rc3xBQRxHM3mDPGc5/aEEkAGWSV/lBFNNwZ
xPuGlZwTrbhxn8CeaMbOkVUHYW/EUgd+r2niZ5fXSv62Kn1OQC2c6dnqzM5tJIkN
U7lUKqE2YnsAVbyF6MBGQH6yG7X8YQOG7valRbIRJFmZer1DXd2UHkZi2At7zUtO
vmPNXalio1HpsGVwIegklmo8td8CM0ZGWHeoWUZD9gPC95lJHVb6kXfLs1nD5eRT
KE+3bOEbR+hVaqh2skYjhmaVMfThIVOk1M2K7CoBmiEGtZswVFBuViVBUMKauZdw
ewt/FkYKfxU=
=M6sb
-----END PGP SIGNATURE-----

--==_Exmh_1378753264_1775P--
