Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752884AbaHSHAh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 03:00:37 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43950 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752754AbaHSHAg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 03:00:36 -0400
Date: Tue, 19 Aug 2014 17:00:26 +1000
From: NeilBrown <neilb@suse.de>
To: Ian Kent <raven@themaw.net>
Cc: autofs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] autofs: the documentation I wanted to read
Message-ID: <20140819170026.5a8600a5@notabene.brown>
In-Reply-To: <1408356832.2533.5.camel@perseus.fritz.box>
References: <20140818062844.9860.43007.stgit@notabene.brown>
	<20140818063301.9860.35420.stgit@notabene.brown>
	<1408356832.2533.5.camel@perseus.fritz.box>
X-Mailer: Claws Mail 3.10.1-123-gae895c (GTK+ 2.24.22; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/jpEzJjcs=gn9bdv3e93VVx_"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/jpEzJjcs=gn9bdv3e93VVx_
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 18 Aug 2014 18:13:52 +0800 Ian Kent <raven@themaw.net> wrote:


> > +The available ioctl commands are:
> > +
> > +- **AUTOFS_IOC_READY**: a notification has been handled.  The argument
> > +    to the ioctl command is the "wait_queue_token" number
> > +    corresponding to the notification being acknowledged.
> > +- **AUTOFS_IOC_FAIL**: similar to above, but indicates failure with
> > +    the error code `ENOENT`.
> > +- **AUTOFS_IOC_CATATONIC**: Causes the autofs to enter "catatonic"
> > +    mode meaning that it stops sending notifications to the daemon.
> > +    This mode is also entered if a write to the pipe fails.
> > +- **AUTOFS_IOC_PROTOVER**:  This returns the protocol version in use.
> > +- **AUTOFS_IOC_PROTOSUBVER**: Returns the protocol sub-version which
> > +    is really a version number for the implementation.  It is
> > +    currently 2.
> > +- **AUTOFS_IOC_SETTIMEOUT**:  This passes a pointer to an unsigned
> > +    long.  The value is used to set the timeout for expiry, and
> > +    the current timeout value is stored back through the pointer.
> > +- **AUTOFS_IOC_ASKUMOUNT**:  Returns, in the pointed-to `int`, 1 if
> > +    the filesystem could be unmounted.  This is only a hint as
> > +    the situation could change at any instant.  This call can be
> > +    use to avoid a more expensive full unmount attempt.
> > +- **AUTOFS_IOC_EXPIRE**: as described above, this asks if there is
> > +    anything suitable to expire.  A pointer to a packet:
> > +
> > +        struct autofs_packet_expire_multi {
> > +        	int proto_version;              /* Protocol version */
> > +        	int type;                       /* Type of packet */
> > +        	autofs_wqt_t wait_queue_token;
> > +        	int len;
> > +        	char name[NAME_MAX+1];
>=20
> These fields have leading <spaces><tab> StGit complains about on import.
> Think it should be <tab><tab>.
>=20

I think I did that because I thought it would work better for markdown
processors (e.g. markdown_py).
However I just tested, and it works best if I turn all the tabs to spaces.
So that is what I have done.

And no rush with testing etc - I just wanted to make sure you had current
code now that -rc1 was out.

Thanks,
NeilBrown

--Sig_/jpEzJjcs=gn9bdv3e93VVx_
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU/L2Cjnsnt1WYoG5AQJdcg//QlgF9Bx8IdpfVY1ustYEewGDPlY9yB9m
q7fp/KRo5mTC70kc6JC7QwwpBQ42F2Wtd0i0po3WWB7DsKWJviA5roTz9uLWRCly
0nf26MTxDDiU9hkZGQHSJfkkf4gn4XKYlxRDZh8slEAUxLSOYsZLJCA1NEX1aUE1
W9yaiY3PYcmpJtgJ0HHJp/YWoiFl0o9miZqLy1DIkHYBmP6cV0dLe6L/j+7+cIe7
lcHMqx/xA2u71cv1roPJUxSu2deVif8ML1EStURqoS0yjPWBSp/+eMrtHaN8AwlB
OR0mlAKm8+a4vKE+x3u0OCI/KljfZS3NAh6rNMUY94/zcD5OA5XZclW7EtrGcCv2
4hS+prpH7ojqs2lb+DD8xFSOFkm3no3ZtrxQGExZxINMWr8L9DMHSXF0cleOgcJD
xnX8qFefGBfDCg9G9sCn7OzykAQ8xgvjzyQDB1PZiojqF0DHR/ZP8x51/ysD+qb1
TlLcrC5lw9OXM5Nb/v30NVoywlwesqoTI62K0HQyLeO2ewob7k6SYL2522485ifo
36D4X8sliL1C/gpVvDwID8M3t/o/Ug7/vAc+hF9/uRIp4j+ZzvbH+8eimqKDfNPV
AK8c0VdDGfrg1ezb/GGamDrGo5daaWh5krsje3aU6tp/7L2NC5daR8LRed34TV6/
cdnlOqqqCpI=
=Mqq5
-----END PGP SIGNATURE-----

--Sig_/jpEzJjcs=gn9bdv3e93VVx_--
