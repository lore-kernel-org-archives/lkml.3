Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757196Ab3D2Ixe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 04:53:34 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:50895 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757161Ab3D2Ixc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 04:53:32 -0400
Date: Mon, 29 Apr 2013 18:53:22 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Matt Fleming <matt.fleming@intel.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Linux-Next <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-efi@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Luck, Tony" <tony.luck@intel.com>
Subject: Re: linux-next: Tree for Apr 26
Message-Id: <20130429185322.afaed9fd11269fba9bb09a54@canb.auug.org.au>
In-Reply-To: <517E2B21.8070009@intel.com>
References: <20130426180357.7599d1b6b7965470905dcdf3@canb.auug.org.au>
	<CAMuHMdWQ0rMuoH+peGMZ3=AdsYrMPpeV4_vSsLD3kaJukx=83w@mail.gmail.com>
	<20130429093628.b739ef3b879b6f8759bd31af@canb.auug.org.au>
	<517E2B21.8070009@intel.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__29_Apr_2013_18_53_22_+1000_gV90cMuZJ3LM=K/J"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__29_Apr_2013_18_53_22_+1000_gV90cMuZJ3LM=K/J
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, 29 Apr 2013 09:11:13 +0100 Matt Fleming <matt.fleming@intel.com> wr=
ote:
>
> On 29/04/13 00:36, Stephen Rothwell wrote:
> > Commit e29c2de5f591 ("Merge tag 'v3.9-rc8' into efi-for-tip") by Matt
> > Fleming from the tip tree merged v3.9-rc8 (which has 0635eb8a54cf) with
> > the branch that contains 048517722cde but lost the "select UCS2_STRING"
> > which should be in drivers/firmware/efi/Kconfig.
>=20
> Eek, yes. Sorry about that. How should we resolve this?

You should probably add a commit that puts the line back in your tree and
get that merged into the tip tree.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__29_Apr_2013_18_53_22_+1000_gV90cMuZJ3LM=K/J
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIbBAEBCAAGBQJRfjUCAAoJEECxmPOUX5FEfkoP92Oji3PIqDoIu5x0669xM7bC
azbDd7U8PFmwaiFGSpfhtpLXuzZai7B9gDGHmPuUU8F0vjXUdVUDnkBYp421FPDa
uEnUe/Tjghx/W+/NIS5/vDMQQu46bEhswJlgrt9iNHogyfB/dqJLxvKP7rYPe5V1
gcgwQMBIEAk6zbDXNyCkeh0hZeTRjDe3gUBNI7oPTNXYFP2MGUqHuenP1anaUPeK
Frd6+gGVu+6veuCVmDE+KXs0tHZ7orhQfI6x6TDy70VKfYpLIxk+/p+iWGiQ2y6W
FJq/19mvs1vLZTTiLhXthzv42H17ZfxSqn1WH/cKSkJgXa7MG3yH6xfF9UNvHtEk
OE/fi8YbfQVyGEiuqnxNPnt5fRQr/Bmy0oqVEH4vKcGc/EZxT6sq3Ca7f3oX/PS2
PV4JQUKoML/GVjLboaFGYaDu3n1fcbkU5eHlInqw/qXLfvlYNhbeylshGL9SBlyz
4e9uFsveo4eY9qzXPAt4u5LSn7BWOplCDq/1jfABCTF7E2RkIn67Wny/8kyaFb5T
xgKJBUxlm+JhgYSiD37WxnoPGvuyfdRLvNRCfLaWjG+OO9daAj7izkElVrGhEXKl
9/J+02Mnvc55f0ai/t7P5+kCM73TtyKpbzXfvrfL9M1ckoQNlg65F1jghlJXYCNM
M/rNSIiT/FjYDHv4IGY=
=ZYgd
-----END PGP SIGNATURE-----

--Signature=_Mon__29_Apr_2013_18_53_22_+1000_gV90cMuZJ3LM=K/J--
