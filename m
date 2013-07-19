Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934999Ab3GSBEc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 21:04:32 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:40590 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934119Ab3GSBEa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 21:04:30 -0400
Date: Fri, 19 Jul 2013 11:04:16 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>
Subject: cpuinit tree (Was: Re: linux-next: manual merge of the cpuinit tree
 with the hwmon-staging tree)
Message-Id: <20130719110416.3046a799149465f33c41c47f@canb.auug.org.au>
In-Reply-To: <CAP=VYLr7fL4a8VTHdgX=GWT9kApP7e2NLHtftTL4_v9VJ097ng@mail.gmail.com>
References: <20130716152737.507bc6f1cc7cfe069e97d245@canb.auug.org.au>
	<CAP=VYLr7fL4a8VTHdgX=GWT9kApP7e2NLHtftTL4_v9VJ097ng@mail.gmail.com>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__19_Jul_2013_11_04_16_+1000_uu=ykntWEOGfWRRN"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__19_Jul_2013_11_04_16_+1000_uu=ykntWEOGfWRRN
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Paul,

On Thu, 18 Jul 2013 20:47:45 -0400 Paul Gortmaker <paul.gortmaker@windriver=
.com> wrote:
>
> > I fixed it up (see below) and can carry the fix as necessary (no action
> > is required).
>=20
> As the cpuinit tree was merged today, can you drop it from the
> linux-next process?   Thanks again for your help in testing this
> and dealing with the patch queue like an akpm/mmotm source.

No worries - it wasn't as problematic as I feared it might be.  Consider
it dropped.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__19_Jul_2013_11_04_16_+1000_uu=ykntWEOGfWRRN
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJR6JCUAAoJEECxmPOUX5FE3XAP/RMWSKxeywsccOAWkUZs9pyh
cOMzsXzgTTPjLDeY5JC/7GQ/XCDfXx9UVf9rjVDGIDbP3bxoCNkW827uC2Jg1FD3
u++j7Vtw6uoSIt9czZgx9uZODwx7I12LQfy8BueVRuSTcsYFB684jknYcSGVryYw
xy4dgO7n26rUZBy/BEPLZnVl7USfv7sdZOMrfI0wENX8y+V6iX5pi1FHw3VICn+z
8jtOYyF2exhob9nkwpsYa/r/jTSxMxTw3p3xiwUrzrTXGu4N4X+k3fOj4EBmzpeL
j8lc5Er0Qk4NOgRowHjfsou4ZCm0HvM8JlPzL2+LnX58zgIeEISgfm4u43RERQ3h
xVntn0477bKC7+vlhub/yfdict79jZ3ffgPmsvaZcQoAKsEaSSS0yXnxqGzYGlbK
tN3tsz0pxeIp4eo9cM+XSaHJ6QBRa3cEewQxuSk5QCiVP4mW+9XhLJntvrxO/Pmo
JFDowU4rVHXFIXqrBZ33DchMQ9DpGlQUhftNf6QiUoKhR9uXafuFnXh8CgdURE15
9Yu9F4MS4CY6QeQKDwLmikmO66j9qLRYlghWcT7hOxvbB3woWl9HuvUTsGCIrRGF
BcWGmP7fqcvQS50xLhBESaZqJDT4Yl4iu7WczO6+SYmgWPyXNULkAc8fM5SJFUk6
BKzOVOBYGmWarmDuokcZ
=H+Vv
-----END PGP SIGNATURE-----

--Signature=_Fri__19_Jul_2013_11_04_16_+1000_uu=ykntWEOGfWRRN--
