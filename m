Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751474AbaKJEhB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 23:37:01 -0500
Received: from ozlabs.org ([103.22.144.67]:60197 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751158AbaKJEhA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 23:37:00 -0500
Date: Mon, 10 Nov 2014 15:36:53 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wolfram Sang <wsa@the-dreams.de>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: Re: linux-next: manual merge of the driver-core tree with the  tree
Message-ID: <20141110153653.5438f292@canb.auug.org.au>
In-Reply-To: <20141110152125.73e33634@canb.auug.org.au>
References: <20141110152125.73e33634@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/BIDJM0wZ1=7wBZr9K=qIYhX"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/BIDJM0wZ1=7wBZr9K=qIYhX
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Mon, 10 Nov 2014 15:21:25 +1100 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> Today's linux-next merge of the driver-core tree got a conflict in
> drivers/leds/leds-gpio.c between commit a43f2cbbb009 ("leds: leds-gpio:
> Make use of device property API") from the  tree and commit
> 81902d5f658f ("leds: drop owner assignment from platform_drivers") from
> the driver-core tree.

This involved the pm tree, of course.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/BIDJM0wZ1=7wBZr9K=qIYhX
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUYEDqAAoJEMDTa8Ir7ZwVgJsP/ivQVjpuAcBXdTlE6Iw0zEJk
UBs/aIE5LBDMLgeEqPsuv/j2Eqkyh6i84LBIxRB1tSanSv2Yy2gzLV7RHJ34ENav
a+XEHJMMsNJ5Km0pQJj9XWvxTJ8EFJ6UAi6P6s4mycG888RklHi8pX0SYkEYYtkW
vP348jXniN+GI9kaO+oye24gG6vZcIlffX/XV8GDSlxxNR0q3VzjO2jhsbEP2HtI
iSLppPcGZoyxw0ysYhcRc6mZosEes04TvEZghmUk57aq9uHrWZyHntZQ1j0NGurT
fxSSKRS5hBNRyYUf1tMdTwYwDfv1uW+YRuKAugWN4oUBzVMMRBr8fdmig7GG+jlU
64NT9hL98NSoPDWA9hxPXXxAgPF92f4v68Tw5BhzlJNROOznVh/YqajY+MNy9jrM
ogs4icliIRt6BFqKso572ca5Y5ByIr+HiYhSfbusqyhoUVXVVndHII2x1+ZkdC9K
SYAiGhvxclm2/Vw305yD9es5mLP82kjP4KQOWge2DyNCKQtpKjmXxksl6YjuyUWN
z1fA/iL4HkizgtiivwsFaLwalGa0KuFOTgIkvtmXdK1/per/C2eFBFUj7ZGGWPcV
q7TH23naLq3fsaZJvls5eo67Yr8esQpnoyUuVH9M/KBV+iQQ3Zje9LljQjiCCtHd
0Q6S4NeEmaFvkdFMxMmN
=WfGM
-----END PGP SIGNATURE-----

--Sig_/BIDJM0wZ1=7wBZr9K=qIYhX--
