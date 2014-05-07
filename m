Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751773AbaEGV4S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 17:56:18 -0400
Received: from ozlabs.org ([103.22.144.67]:59522 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751071AbaEGV4N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 17:56:13 -0400
Date: Thu, 8 May 2014 07:56:06 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: linux-next: Tree for May 7 (argh)
Message-Id: <20140508075606.fd453d43546aef01b87e3ad1@canb.auug.org.au>
In-Reply-To: <536A9CF2.90906@infradead.org>
References: <20140507173341.753d8ccf4fe033abd513f98f@canb.auug.org.au>
	<536A9CF2.90906@infradead.org>
X-Mailer: Sylpheed 3.4.1 (GTK+ 2.24.23; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__8_May_2014_07_56_06_+1000_T+rdW/.2vei2hc4e"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__8_May_2014_07_56_06_+1000_T+rdW/.2vei2hc4e
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Randy,

On Wed, 07 May 2014 13:52:02 -0700 Randy Dunlap <rdunlap@infradead.org> wro=
te:
>
> I was away for one week.  Did I miss some new instructions about
> building linux-next?

Nothing that I know of.

>=20
> I get a thousands of messages like these:

What config?  What arch?  Did you just do "make oldconfig"?

> WARNING: "system_wq" [drivers/misc/bh1770glc.ko] has no CRC!
> WARNING: "__wake_up" [drivers/misc/bh1770glc.ko] has no CRC!
> WARNING: "sysfs_notify" [drivers/misc/bh1770glc.ko] has no CRC!
> WARNING: "kfree" [drivers/misc/bh1770glc.ko] has no CRC!
>=20
> Also there hundreds of messages like these:
>=20
> ps2mult.c:(.exit.text+0x8f): multiple definition of `cleanup_module'
> ps2mult.c:(.init.text+0xbc8): multiple definition of `init_module'
> ipack.c:(.exit.text+0x0): multiple definition of `cleanup_module'
> ipack.c:(.init.text+0x0): multiple definition of `init_module'
> mcb-core.c:(.text+0x40d): multiple definition of `cleanup_module'
> mcb-core.c:(.text+0x3fb): multiple definition of `init_module'

cc'ing Rusty just in case ...
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__8_May_2014_07_56_06_+1000_T+rdW/.2vei2hc4e
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTaqv8AAoJEMDTa8Ir7ZwVQggP/jfsISvFFrJvOLy7IXO0D2Bg
/Jwitr4h7sRe3/hwR8rjrsaXbvsDDFQSRatLgvjFWWP7KntRvAhDhlgE5St1mbRO
FCfLQ/ksGs+lYcQOKg4GFPv/Mgd6Sx+UUS/4N9RRuNH2kRqHgQC2CVGrXnvdutDL
gdQGXBGaWzqknGZ2wQRVqUQgXL+9t48YAf2bXZv+poxjK6F71K5Fvp24EHSAr3Le
UgVSGjkAcRfXuShYQXZpb7POQ7B/sIn3JClCgaRNBFnc0Oz2m+lRJ4Llq10xs61m
fFNIh7P8TxZeiBkmqer14DgN47FNa2rkRJHEiWjftGnqYeasminN2xDuchTBuhtE
pZbUvqzxhorztRMPDS5eD4LQPJ3wOdsBiyJL2kX+5gUHVeJSrYk5nS77FHr8CviC
HLw4OrYEM6xlS9OpLjeEl39FQLO66R6+5rQCOq2DJF5Fd60/ZAXA5mNiobscBkwx
0/2+RMBw5/iDbLxt+XDwG+HELRUKdtIoQPB4y69yGxwXxNNRQOoJDF+XMAn+etRj
kQIYSIixgPWDkmCLvXt72eJSV1GHf2FMrQV8X44WTq5F9vLPSzArbRTYBwbacdva
5hqVzN54EPpcmPta9ChczXcrlmfo6/KWNjeOnjV7UB7LG8I/YUMBYoOMe0s2/grT
CUF8FChgcn6kfsx/b29w
=miGH
-----END PGP SIGNATURE-----

--Signature=_Thu__8_May_2014_07_56_06_+1000_T+rdW/.2vei2hc4e--
