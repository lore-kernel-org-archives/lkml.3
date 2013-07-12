Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753306Ab3GLGW5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 02:22:57 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:37619 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751616Ab3GLGW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 02:22:56 -0400
Date: Fri, 12 Jul 2013 16:22:41 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>
Subject: Re: [GIT PULL REQUEST] watchdog - v3.11-rc1
Message-Id: <20130712162241.08c8dd775abd0d6792b4927b@canb.auug.org.au>
In-Reply-To: <20130711203424.GE14258@spo001.leaseweb.com>
References: <20130711203424.GE14258@spo001.leaseweb.com>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.19; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__12_Jul_2013_16_22_41_+1000_cDJ0V1ZjNzCcPnQM"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__12_Jul_2013_16_22_41_+1000_cDJ0V1ZjNzCcPnQM
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Wim,

On Thu, 11 Jul 2013 22:34:24 +0200 Wim Van Sebroeck <wim@iguana.be> wrote:
>
> Please pull from 'master' branch of
> 	git://www.linux-watchdog.org/linux-watchdog.git

This was all rebased in the last day from what has been in linux-next for
some time.  All the patches are the same, so the rebase achieved nothing
positive at all.  Please don't do this (see I am still much nicer than
Linus :-)).  Just submit what you have in linux-next which has already
been tested (presumably) and Linus can fix up any conflicts (in this case
there were nothing significant anyway).

Also, you might like to consider using "git request-pull" to generate a
starting place for your pull request rather than sending all the commit
messages and the diff in line.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__12_Jul_2013_16_22_41_+1000_cDJ0V1ZjNzCcPnQM
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJR36C1AAoJEECxmPOUX5FEvkoP/3vms1xbUmQhFXlqDJWXnwlU
TXHFwKJSq5pTT3PO90nOvXFA1kFFRVXx9zelFqfQ0asce7sCijFf9ByMmIIMpJZi
se0u6zWhDm9kWM7JrJ3KxN39Wlp4CSFiylkvPdb+U6iOFYNWgwQvwnQkyywfmH9Y
vNRVreBsecLfjKqvTFFMMt1JuDHf6b6ET2HYv9oVjq856VJYHZFyYc0pCKafLOk4
EJc3nK7Y46fwdqDRoaz80JACMz42STXJjY9PqQS8XTvwKgnAVaPC9z+pcjKw7TjH
FWbu3adD21andPaaRoISW1eX3lLRB8e7koKXddLC3x248D+/LI/HgV/MLPVSPKFz
cfI4MyQBjHOgzvxkL/fgeXZCAztdxLKvDtkwjHCGZDCNf+D/f8bVuOn12sapoF+j
XH84QZn/tjaEnA7qQNNGFRuT80anKjVCpmsLzr13ts9xxEOZEq8CANZrW1q3k5ad
GSgNSsSrtcAWUBCD0hbBZJDc2jHqiHmblILlgOWRVKIgsO8QS+1Pns+aVDsGKDby
sYXAsAA2uKnP/dYsCYp2jR6ashOBNYA8yPJ2bgh3ZDZD9G2XD5WleLEgBifTioSY
Phfxa1ePucQGrDTr/BJyaZfPZVSYR96SmmRT1cFnjlnNuGiDFo+FlRVtaxknJlXi
4OIHToN6m/3wqBZCIAbJ
=hdxF
-----END PGP SIGNATURE-----

--Signature=_Fri__12_Jul_2013_16_22_41_+1000_cDJ0V1ZjNzCcPnQM--
