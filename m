Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752380AbaBSCX2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 21:23:28 -0500
Received: from ozlabs.org ([203.10.76.45]:39970 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751643AbaBSCX0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 21:23:26 -0500
Date: Wed, 19 Feb 2014 13:23:19 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Miklos Szeredi <miklos@szeredi.hu>, Al Viro <viro@zeniv.linux.org.uk>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>, Rob Landley <rob@landley.net>,
        Christoph Hellwig <hch@infradead.org>, Karel Zak <kzak@redhat.com>,
        "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: [PATCH 03/11] vfs: Don't allow overwriting mounts in the
 current mount namespace
Message-Id: <20140219132319.79bc3b26bad00a513880d207@canb.auug.org.au>
In-Reply-To: <CA+55aFx8nksLjQt3aECVk2Ni5FNPXxL988mEqfFgqbbubZho6w@mail.gmail.com>
References: <CAJfpegsxgnSRUW-E5HM3uT5QfGyUtn_v=i4Ppkkkutp34287AA@mail.gmail.com>
	<87a9kkax0j.fsf@xmission.com>
	<CAJfpeguv+7giYNpAuXE9Ja_9BEwB0-fZBVgRSeVqpzSXgQYZ6Q@mail.gmail.com>
	<8761v7h2pt.fsf@tw-ebiederman.twitter.com>
	<CAJfpegtT7y-1HhbEVAMKkdQugTG_w7G_epGtQHGvQLpcZB5FVA@mail.gmail.com>
	<87li281wx6.fsf_-_@xmission.com>
	<87ob28kqks.fsf_-_@xmission.com>
	<8761ogkqhl.fsf_-_@xmission.com>
	<20140218171252.GC4026@tucsk.piliscsaba.szeredi.hu>
	<87ha7wrtyz.fsf@xmission.com>
	<CA+55aFx8nksLjQt3aECVk2Ni5FNPXxL988mEqfFgqbbubZho6w@mail.gmail.com>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__19_Feb_2014_13_23_19_+1100_8kwtE0TyrFPxwpwl"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__19_Feb_2014_13_23_19_+1100_8kwtE0TyrFPxwpwl
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, 18 Feb 2014 14:20:29 -0800 Linus Torvalds <torvalds@linux-foundatio=
n.org> wrote:
>
> For this kind of function return value it actually tends to work very
> well, and in fact often generates slightly better code than "int". So
> I don't _hate_ bool, and we've certainly had a lot more use creep in
> lately, but I also don't really see "bool" as much of an upside.

And in function declarations, it makes it very obvious that the function
is not one of our "return 0 or -ERROR" ones.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__19_Feb_2014_13_23_19_+1100_8kwtE0TyrFPxwpwl
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTBBWcAAoJEMDTa8Ir7ZwVPAAQAJSCWuo/D0ShCFS9Aaq7aRRy
j3oHGeKQ1Zxj4IXvCFe8xWdPyzHWg71oLvCKCzHnsqO9Bw61v/l5R0BOqV+TdL8A
f7UW1fBplZ0lhwWCS41yX2vjEj+2IWnA4eq6i/yUVCH85cGqH9Yn2c7NeHY+glEH
Sn53twhD8P6Bq5aU3VMAqNVyl2FdeOuSykCFg4LFo2cW1RA/UkngegdxjQwlui2e
im9qb3BMSivl+E6LHLxqlNqkMEY6SCNhIbWXZx5kuc2TsWaAXkUeJrdv4BuSejDS
BgW4+7eQ9/DAD/uWTI0tDBKJVPICnPGOOp5m3d58ccBXlzW8cgjhvKHGnYPx/mPy
X8kX16UD62v1akJ//YKdRGAAP/rYZ4al1TOMs3Y5MMGf6JZ8Kyjx79d6ouSf4TaD
t+H679VVzazENWGyaozHjBwOfJZK0SGYzjbmnblev8fK5Xd/2RW8hiIVgBNnefi6
u+z2//HiFeTqzNm3rFJQXn+wCR9mKFMR15UdF4o3kqmF74DwzkGRawKS+XzurLnc
eIl3z59A1SSPPTyl7GESuAmp7tEaKD8d4tjGEhL94ROFD0JzvtCYv6TL4rGYQ2fF
xDwqdwb0ET+U1+0btxqWwl30tsDpxN8VSBLEccT7l5iTPfRlrcixuDs26dWd4aJD
8uHHrbe2hhE+RV2YWvpl
=BpZY
-----END PGP SIGNATURE-----

--Signature=_Wed__19_Feb_2014_13_23_19_+1100_8kwtE0TyrFPxwpwl--
