Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755776AbaHYNYP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 09:24:15 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:62756 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753582AbaHYNYN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 09:24:13 -0400
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Subject: Re: Linux UDF support
Date: Mon, 25 Aug 2014 15:24:05 +0200
User-Agent: KMail/1.13.7 (Linux/3.13.0-32-generic; KDE/4.13.2; x86_64; ; )
Cc: Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org
References: <201408241446.47042@pali> <53FB2FD9.7060406@gmail.com>
In-Reply-To: <53FB2FD9.7060406@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3672375.lnrZU4Mugm";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201408251524.05443@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart3672375.lnrZU4Mugm
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Monday 25 August 2014 14:45:13 Austin S Hemmelgarn wrote:
> On 2014-08-24 08:46, Pali Roh=C3=A1r wrote:
> > Hi,
> >=20
> > I would like to know what is state of linux UDF driver. It
> > is experimental or is now suitable for storing data?
>=20
> I know that read support works for every version I have
> tested, but I've only tested it reading data from DVD's and
> Blu-Ray discs, so I don't know how well it works for other
> purposes.
>=20

Ok. I'm thinking about using UDF on HDD and usb flash disks (not=20
on optical medium). And here I need write support too.

> > According to wikipedia [1] UDF has open specification format
> > and can be used also for HDDs (not only optical discs).
> >=20
> > In OS support table is written that all major and other
> > minor OSs support UDF FS (without needs for additional
> > programs).
> >=20
> > So it looks like UDF is good candidate for multi OS
> > filesystem. Are there any disadvantages for using UDF on
> > e.g USB flash disk? (when I want read/write support on
> > Linux, Windows 7 and Mac OS X)
>=20
> If you are going to go that way, make sure to use the Spared
> Build, as otherwise you will run in to the same media
> wear-out issues that NTFS and FAT have.  Also, keep in mind
> that pre-Vista Windows and pre-10.4 OSX don't have very good
> support for the newer formats.
>=20

What is Spared Build? And how to use it?

Problem with NTFS is that linux driver has write support marked=20
as experimental. FAT has problems with big files and for exFAT=20
there is no driver in linux kernel yet...

> > Because lot of manuals say that FAT32 (or NTFS) is only one
> > solution for using USB flash disk on more OS.
> >=20
> > On wikipedia there is one note about linux: Write support is
> > only up to UDF version 2.01. Is this restriction still
> > valid?
>=20
> I do know that we support reading UDF 2.60 (I've used linux to
> read Blu-Ray discs), but I have no idea about write support
> for versions above 2.01.
>=20
> > What will happen if I try to mount FS with UDF version 2.60
> > in R/W mode on linux? It will fallback to R/O mode? Or
> > newly written files will be in previous (2.01) versions?
> >=20
> > And last question: Is there some fsck tool for UDF? Or at
> > least tool which print if FS is in inconsistent state?
>=20
> Most Linux distributions have a package called udftools, the
> upstream URL given by portage is
> http://sf.net/projects/linux-udf/
>=20

That project does not have udf fsck tool :-(

> > [1] - http://en.wikipedia.org/wiki/Universal_Disk_Format

Ok, I will wait for response from maintainer Jan, he probably=20
would know more...

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart3672375.lnrZU4Mugm
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlP7OPUACgkQi/DJPQPkQ1JsXACfQRNCUNAjKOhJsVEBGT1jZcu0
gnwAn201MAthTHsKX06ibr+3tzGEKNj7
=9Mgc
-----END PGP SIGNATURE-----

--nextPart3672375.lnrZU4Mugm--
