Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756307AbaHHBdR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 21:33:17 -0400
Received: from ozlabs.org ([103.22.144.67]:52706 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755313AbaHHBdO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 21:33:14 -0400
Date: Fri, 8 Aug 2014 11:33:07 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stewart Smith <stewart@linux.vnet.ibm.com>
Subject: Re: linux-next: build failure after merge of the modules tree
Message-ID: <20140808113307.4f505bba@canb.auug.org.au>
In-Reply-To: <87a97gcus9.fsf@rustcorp.com.au>
References: <20140807132017.2ec9e2ad@canb.auug.org.au>
	<87tx5ocyz3.fsf@rustcorp.com.au>
	<20140807230342.52e3a52c@canb.auug.org.au>
	<87a97gcus9.fsf@rustcorp.com.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/WAf/iwj1xNJ1u6/qC3WMTLa"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/WAf/iwj1xNJ1u6/qC3WMTLa
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Rusty,

On Thu, 07 Aug 2014 22:37:50 +0930 Rusty Russell <rusty@rustcorp.com.au> wr=
ote:
>
> Stephen Rothwell <sfr@canb.auug.org.au> writes:
> > Hi Rusty,
> >
> > On Thu, 07 Aug 2014 21:07:20 +0930 Rusty Russell <rusty@rustcorp.com.au=
> wrote:
> >>
> >> Ah, crap.  I really hate that macro magic :(
> >>=20
> >> I amended to the minimal fix, so we can pretend that never happened.
> >
> > How about arch/powerpc/platforms/powernv/opal-dump.c as well?
>=20
> Hmm, I didn't see that one.

It was in the original report, but I guess a bit hidden by all the guff
the gcc spews out these days.

> I've done that as a separate patch.

Thanks.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/WAf/iwj1xNJ1u6/qC3WMTLa
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJT5CjYAAoJEMDTa8Ir7ZwV0uEQAJb9if9ScMmA6AbU8P13Vdsi
VLTedbLJluRO0XnlbQIBh87kWlAXl5BNyqg46rMNx4odHqUJz51L0jcM9TITjxup
DoZL/t03kRjJdpfFmhKdq/UJSjyeWmlQNBV7lquEYRLgwLkmgdGAE1omd6m8SVs1
6N3xAbW2KGH2fZM8POaQo22s9QTkFwOAkao7rYnQrWqBV+Ub4WPlEhPwxBaot7AA
a+Q2qdHE+UG8iDMQb7lXorzvHDhjMIlBs7/EoCzvOkHqowNrx+VtnFSKY2+88wFy
bGua2UXnTdnVkbPxqVBI5My+I6QhABQ5Ot+tbUu8Jo0vI+DQvewTMgEDAB/yQcKt
YnP5uwDaWsub9vOx+VSiEmlMs1iUtPs3JTeNBIeAVlYKuO9ymwcVtc8OzM6ZQX8p
5zl31/6Av8NMUBLUrtKViPc/9Lzh7vy8ljrHOL+JmjBE24fiu/at0ZTwTtQcMltI
JxSIEYTw/72f88CKpcQggD6R9/PiQyGoH0RFMHl7qNeV8xxkEles0NiB9iTLg7vX
7m5qikm53MbYkJ7WssZsapWC/Knl5DCHJEPP0UNWj8zhy0hbUk2jO8FAOW4QcUJm
6uSTSL3gAW6CYAC8gwLiW5KxtSl4rZpP+n3/DX1coKvSEnWFVbsj6nZ6aqo/Yf5t
QbJe2QS1NzxSMYl8fScP
=bQ5W
-----END PGP SIGNATURE-----

--Sig_/WAf/iwj1xNJ1u6/qC3WMTLa--
