Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935743Ab3FTDtL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 23:49:11 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:47528 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935637Ab3FTDtJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 23:49:09 -0400
Date: Thu, 20 Jun 2013 13:49:04 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: Ming Lei <ming.lei@canonical.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: Re: linux-next: manual merge of the driver-core tree with the
 driver-core.current tree
Message-Id: <20130620134904.a621b5ebf28fb102a40ae9c2@canb.auug.org.au>
In-Reply-To: <20130620032812.GA24385@kroah.com>
References: <20130619153225.9ff68f0984bfa54333c4df10@canb.auug.org.au>
	<CACVXFVMhVs7Wy1A=TfczYzHLFwyRPhEGW9Yo9hTERekaxSnpdQ@mail.gmail.com>
	<20130619143918.GC8413@kroah.com>
	<CACVXFVObBDwaounzZ7RyF=+QrQCBoEd0s-uLYFokksOzKgZSjA@mail.gmail.com>
	<20130619163628.GA28672@kroah.com>
	<CACVXFVNsbBunNzYecUG34sFjPqRuzMHRTBD2Siy9d4RhqPnr3A@mail.gmail.com>
	<20130620110610.7d245d88b70620fa271a29f7@canb.auug.org.au>
	<CACVXFVN-B7ZrqjoA_QNkWKjM0XdM-S08h-d6JuRjsYOX0YPt=A@mail.gmail.com>
	<20130620032812.GA24385@kroah.com>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.18; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__20_Jun_2013_13_49_04_+1000_AoCvR_4gpWq=NAhl"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__20_Jun_2013_13_49_04_+1000_AoCvR_4gpWq=NAhl
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

On Wed, 19 Jun 2013 20:28:12 -0700 Greg KH <greg@kroah.com> wrote:
>
> Thanks, that helped out a lot.  I've now merged this together, and
> pushed it out to my driver-core-next branch, can you verify that I got
> it all correct?

And I have refetched the driver-core tree for today's linux-next so it
includes that merge.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__20_Jun_2013_13_49_04_+1000_AoCvR_4gpWq=NAhl
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJRwnuwAAoJEECxmPOUX5FEzWEQAJxhukISHEmtFNVoB6m3oJav
1pTak37hq00S+l98qrIhu/kXmnYf/3kFdW8ZxS97FRI0Zj40y8uyt1UxgTyNcvnb
Be9+0CxFPei1Ny8mOrULM8XhYPtQosrAq/9fsSjJQy+DOuawAjNFUbycLupfH6Cz
xpZh24zc+MKG8CQUwQRKjveMARtSWSqtBxAVMxj7xTaXfaMWmQCX1xnDrRTaZPlS
Q2teU9cz7bAF2AttXC7EY8IR3QtoEciyeLHNru5P2U7WzKbgiQ6ks8HzTsVDHUha
Q93WucNYNFh6ubNamAcFX2X0ZjomD0DScT9EPlKgLlQh9sak6qCy0LejvfqGe176
S21S1/4SCb546f6wu5wlpo3zaGNCpBwsu/Zv0vagO4nfAcGdF74TwqT/fsk2/4fc
NRJc4rS0tCwyW9hqJETOxy/RJXGJkinxzXeFd9NhGKBQzXjFQwPYYeSSvQ2Ga5aj
COYrbCOCnqqyLtK/Zdf7BlnOZucNC5y8i3461Yqop1+Wtqmsy4rGP7L0Zt8+Pxik
f4Hk5SwW3FeKzKBm0vyrthf63QYc7Tib1Kyarkb9ExZDuC4we/0hfotSca69MMZJ
qpbDWxdbNJDc6qrSK5ouHLc20qpJMTlRNe0AeJwbW19v8q3NudVG1l33GH5Ifj/q
NhyTJM9eaAMNONVSH0nh
=kCYp
-----END PGP SIGNATURE-----

--Signature=_Thu__20_Jun_2013_13_49_04_+1000_AoCvR_4gpWq=NAhl--
