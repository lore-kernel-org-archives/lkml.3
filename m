Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751480AbaDXCYX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 22:24:23 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44062 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751047AbaDXCYV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 22:24:21 -0400
Date: Thu, 24 Apr 2014 12:24:07 +1000
From: NeilBrown <neilb@suse.de>
To: <balbi@ti.com>
Cc: Nishanth Menon <nm@ti.com>, Greg KH <gregkh@linuxfoundation.org>,
        <marcel@holtmann.org>, <gustavo@padovan.org>,
        <johan.hedberg@gmail.com>, <jslaby@suse.cz>, <grant.likely@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        <linux-bluetooth@vger.kernel.org>, <linux-serial@vger.kernel.org>,
        <devicetree@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH 10/13] tty: serial: omap: remove some dead code
Message-ID: <20140424122407.106384bc@notabene.brown>
In-Reply-To: <20140424014334.GD13374@saruman.home>
References: <1398265117-11793-1-git-send-email-balbi@ti.com>
	<1398265117-11793-10-git-send-email-balbi@ti.com>
	<5357DDA8.4040206@ti.com>
	<20140424084305.20c7f301@notabene.brown>
	<20140423230121.GC10924@saruman.home>
	<20140424101329.02e6a62f@notabene.brown>
	<20140424012100.GB13374@saruman.home>
	<20140424114115.51ab3f98@notabene.brown>
	<20140424014334.GD13374@saruman.home>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/X34t7Wbc9mHYz7pv8U.Qbv."; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/X34t7Wbc9mHYz7pv8U.Qbv.
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 23 Apr 2014 20:43:34 -0500 Felipe Balbi <balbi@ti.com> wrote:

> so, Ack for $subject or not ?
>=20

Just at the moment I'm finding it hard to care.
So
 Acked-by: NeilBrown <neilb@suse.de>

Whatever....

NeilBrown

--Sig_/X34t7Wbc9mHYz7pv8U.Qbv.
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU1h1yDnsnt1WYoG5AQK/fBAAju+nejoMEvj1BptVeWVrZdHGPFUk/VGb
9qVki2U5fkBC9kcPd1/5OzPnB7Kyztgh+XmDWwwBLCIhoAW8kdmi/sLWkxxppBf3
3L5tkqPIfrxqTFbpGiog/lcmjwZ0lnpP5Ew9fpI3XqpMfQFiEtZEgiqV5wdiEpO9
t1FIenW48PtiJnj3F3qh+p7Ghp/0xwHvdRDQkGGFkgKE40tMEgPKwBlFvRpeXawE
IIcrHY9Mmmo6VOa+pV/STD8Eeuor+V8i8ZcVwLVksP5YY9cxCmXRjUCUkw0BI/4P
jit7eDGDVW+9g5KdZK1PRIGg69JVBXRHUqn03Gd3JwP2becXv37KV7Sn4tQPk7ls
JzkCVEqqDvFyAaVDGKv1ylz3HAIfGZsQ+HN+BSQfySDyOohuapJfBkpLESGkqUmZ
/aCnWRa6BckaZcn6n//UiY91evvu5YGHb2+NchNg/WLftEf/nBuvoH2CO06gSp6j
FdqWfMpALDekPitbHMkj9zvAiwPhArce7bswmXKWBa9r8XKvmHdSOKuV23ajV3y3
qNcZKWzLold7etMiCNSTJllQF99n8SUJ6tjWUel0MKavau8FzBJzkcNWUMtGdEuy
WCPoG17b0A2ex3awDeWybnPcETE7e+rsHhFtnIrD2C7TMRoXASGfJx9YX/UTbpfX
xZbIlCrSkss=
=tmpn
-----END PGP SIGNATURE-----

--Sig_/X34t7Wbc9mHYz7pv8U.Qbv.--
