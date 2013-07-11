Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755507Ab3GKAh5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 20:37:57 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:57539 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755432Ab3GKAhz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 20:37:55 -0400
Date: Thu, 11 Jul 2013 10:37:52 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Simon Horman <horms@verge.net.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: rebase/rewrite of the renesas tree
Message-Id: <20130711103752.ccf481354c83001a4233cb68@canb.auug.org.au>
In-Reply-To: <20130711003133.GC22153@verge.net.au>
References: <20130711100851.14dc2f2c5c268a23486c89c1@canb.auug.org.au>
	<20130711003133.GC22153@verge.net.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.19; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__11_Jul_2013_10_37_52_+1000_+1GdasWyydH2JPi5"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__11_Jul_2013_10_37_52_+1000_+1GdasWyydH2JPi5
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Simon,

On Thu, 11 Jul 2013 09:31:33 +0900 Simon Horman <horms@verge.net.au> wrote:
>
> I am not planning to send any pull requests for v3.11,
> at least not for the branches that I rebased.

Then none of that stuff should be in -next at the moment (not until after
v3.11-rc1 is released).  It just mucks up possible tesing for stuff that
is still to be merged.

> I can rewind the next branch if you like. If so, would rewinding
> it to the point it was at for next-20130709 make sense?

See above.

> Also, on this topic, could you clarify when it would be appropriate
> to do any rebasing. Obviously I am not clear on this.

I notice that you seem to use topic branches that you then merge for
inclusion in -next (and presumably arm-soc).  You should endeavour to not
rebase those topic branches once they have been published.  Sometimes it
may be very necessary, but generally it should not (as you would have
done review and testing on them before publishing them, right? ;-)).

You should definitely *not* rebase those branches after you have asked
the arm-soc guys to merge them (unless that rebase is just to pick a new
starting point (though you should generally be able to get that by fast
forwarding into the arm soc tree after the spot where your stuff was
merged).  You should also not rebase them if others are using them as a
base for development.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__11_Jul_2013_10_37_52_+1000_+1GdasWyydH2JPi5
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJR3f5gAAoJEECxmPOUX5FEYWQP/iPX9v2fSMrLjLU5WB9FUY9Q
Lzy6RNhEmAwPbouao7TAbHtI3XghmKd07AdR7J6d4dtQL9r9iaLhC1izYGzLWZXY
1Pw/5UfRIvwT9uFSiChVyuj69yRIzkthXIuXbkxLChI2oz2aj4ll2F2MtfVN53Kn
BzdWkw4jlfsSvgnrmnOpHmvpEM5OwTm9UO+DtZ89CzvjDvyujjsXgQmErXfh7Qok
hkiA1zqJXj4xWK41sLgeQ00SnJ79Yxv6ARVJ/Sfoj5UIQwd90laMwN++cIOfJ6SL
uOq7yRwBzMvelTzSN6p3Y00ooJW1QEU91Iu969fQIgA7HmZhyp08AkGwT8GWzri3
1fNtzqxW2gs7Z/eYpan65+a9t+prxFZUmdG5c5T3nAAhOK6jq2P7Q3wo48Foms2w
bqL2beyq1xE5QsSKMzI9nhc+YTunux8KcT8V1R4LPBDhu0u2owWNr7CWzALyMfke
ryY/XkuLjLUCt8IS66Lf8OBD1qu1KRiaCVz7iGgliZnM/sFk4SKpG7VoczNS55pS
Av89vgulZD1i+c1yBGG/pjOEunOIEtc8FCxIetjnYTlYHir7VsLdyzhbjJo5oUzM
M6/2To9yYkrOgyNgyu527tyjsXus3eouc4PyAgiZmrgAd4+mi0Gn6hDxqqeNcpaz
Ru9WjyCgJlaNabJGsxeh
=VPyd
-----END PGP SIGNATURE-----

--Signature=_Thu__11_Jul_2013_10_37_52_+1000_+1GdasWyydH2JPi5--
