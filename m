Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753622AbaHZSv3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 14:51:29 -0400
Received: from omr1.cc.vt.edu ([198.82.141.52]:41012 "EHLO omr1.cc.vt.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752371AbaHZSv2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 14:51:28 -0400
X-Mailer: exmh version 2.8.0 04/21/2012 with nmh-1.6+dev
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Samuel Thibault <samuel.thibault@ens-lyon.org>,
        Hugh Dickins <hughd@google.com>, akpm@linux-foundation.org,
        Sabrina Dubroca <sd@queasysnail.net>,
        Vincent Donnefort <vdonnefort@gmail.com>,
        Bryan Wu <cooloney@gmail.com>, linux-leds@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH][input-led] Defer input led work to workqueue
In-Reply-To: Your message of "Tue, 26 Aug 2014 10:01:35 +0200."
             <1409040095.2489.3.camel@jlt4.sipsolutions.net>
From: Valdis.Kletnieks@vt.edu
References: <20140826015453.GA5235@type.youpi.perso.aquilenet.fr> (sfid-20140826_040254_816162_A52F1B31)
            <1409040095.2489.3.camel@jlt4.sipsolutions.net>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1409079070_3277P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 26 Aug 2014 14:51:10 -0400
Message-ID: <4017.1409079070@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1409079070_3277P
Content-Type: text/plain; charset=us-ascii

On Tue, 26 Aug 2014 10:01:35 +0200, Johannes Berg said:
> On Tue, 2014-08-26 at 03:54 +0200, Samuel Thibault wrote:
>
> > +	vt_led_wq = alloc_workqueue("input_leds", WQ_UNBOUND, 0);
> > +	if (!vt_led_wq)
> > +		return -ENOMEM;
>
> Does this really need a separate workqueue rather than just using
> schedule_work()? There doesn't seem to be much point in having its own
> workqueue really, to me.

As I noted in another email, the patch works. Whether it's *correct* I can't
tell. :)

--==_Exmh_1409079070_3277P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBU/zXHQdmEQWDXROgAQINFQ//dWiwOqohKLs4RbmF9EHitZl7R3T3K5e1
Mt2fmsqi923zNt7AsIZPOZ6d5H3u4LIjs0U27zb9Wv2FJ2hJ4/6JZGBr12xsq5WG
opOBLwOzYmWxo+ADJiNp5r05Y2NlCY8Ab6x9ba855TjUGp4wOO4PjAON33bY3H8e
qL7HrQb77fQXFauRbY9Wl3ZeIo7xmYwDg9PsXynRrJw1RsatvjpRU01+3uL8KZzc
VaVEiAGgFJ7kM4/8qgLs6y/h3MHtw60zDG8SGNAKgqfvShbYoryJcUnuhABPj4wC
4e0Ch4gGg3WL6MpU+Q8/ErDNbyB14YFeEtgyzKOMhhzvAvE8wcEgCzdITtCmpqH3
PhdgADNgBht3uw0Uau+M7PZveopYUX+LcP8HKPu0mgEWLHyqJRX6IMOfcLENGPQd
I1oBBoQPoC0WyVw+/FjTavm05VXSXqZ2GMgI2/EN+7j17nMYrSaIU4NZG3/mzXlc
8AsCrcn/y8Js9nOcySRiiaZM9CaL0I5uTRZsS1H2Lt2sPDLnP/83Nn0A0vNtovI2
ByQ1a2Rup8f4GRdlYd1X7sWFWGL4E7J36LOrwEYcas0MHbe7ZbBJDilFK9AisX6y
7tcGhtNCWKvGo1fmt63TbIuSrJQiwtew27JuAQsttwSi4e96BedsW+JPt+Zh5Rz1
rhB9FxDFwWU=
=F1N7
-----END PGP SIGNATURE-----

--==_Exmh_1409079070_3277P--
