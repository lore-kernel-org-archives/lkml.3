Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754413Ab3G3A23 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 20:28:29 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:48157 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752750Ab3G3A2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 20:28:20 -0400
Date: Tue, 30 Jul 2013 10:27:54 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tomas Winkler <tomas.winkler@intel.com>
Subject: Re: linux-next: manual merge of the char-misc tree with Linus' tree
Message-Id: <20130730102754.749949a5d53c54e4c6c72d53@canb.auug.org.au>
In-Reply-To: <20130729192649.GA9191@kroah.com>
References: <20130729150129.76a9fab4023ee22c940b7920@canb.auug.org.au>
	<20130729192649.GA9191@kroah.com>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__30_Jul_2013_10_27_54_+1000_PHdWH+Gtq.oE2RHC"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__30_Jul_2013_10_27_54_+1000_PHdWH+Gtq.oE2RHC
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

On Mon, 29 Jul 2013 12:26:49 -0700 Greg KH <greg@kroah.com> wrote:
>
> On Mon, Jul 29, 2013 at 03:01:29PM +1000, Stephen Rothwell wrote:
> >=20
> > Today's linux-next merge of the char-misc tree got a conflict in
> > drivers/misc/mei/init.c between commit 99f22c4ef24c ("mei: don't have to
> > clean the state on power up") from Linus' tree and commit b950ac1dabfc
> > ("mei: don't get stuck in select during reset") from the char-misc tree.
> >=20
> > (Unrelated white space changes are a pest :-()
> >=20
> > I fixed it up (see below) and can carry the fix as necessary (no action
> > is required).
>=20
> Thanks, I've merged the char-misc-next branch into 3.11-rc3, so this
> merge problem should no longer be there.

Unfortunately, I think this is exactly the sort of back merge that Linus
hates.  He and I are quite capable of coping with relatively complex
merge conflicts, so ones like this are really not a problem (and "git
rerere" takes care of it once I have resolved it the first time).  That
is why I added "no action is required" to my notification messages.
These messages are really more "this is what I did, please tell me if I
did something wrong", not "please fix this up"  (I know this message from
me has changed over time - we can all learn, even us oldies :-))

Also, if you are doing a merge of fixes that you have submitted to
Linus, it is probably better to merge your fixes branch rather that
Linus' tree after he has merged it - that way you are not dragging
irrelevant stuff from Linus' tree into yours and complicating the git
history/bisecting so much.

Of course, if you need something from Linus' tree that someone else put
there to continue development, then you need to back merge Linus' tree,
but after rc2 or 3 that should be rare.  And, of course, such a back
merge needs a good changelog explaining exactly why it was done.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__30_Jul_2013_10_27_54_+1000_PHdWH+Gtq.oE2RHC
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJR9wicAAoJEECxmPOUX5FEJj0QAKgBIIvBk6vjiRsqzjhOCAHv
bMEi/0PBbrYpRqwIrY0UqARdrCyh5fsxe0azgIP4PeFE3x6ZAdNmhPBa8A8lpKFq
GiicIOLYdtuFtEGdg3XMbBEWsZ2fBKk4KmXqWIgpuifl9UX91uWRFk9WswjbAd/5
xZxxrTcnPsUiGZ76YtGkvntjTuAVpBes2TdykLmzWvHzIlFKzf+4Y0Pf8BXaTgKm
arhztujVxGGdQG37V/nyjCo/3Fh5pwVvl9ElqJHf9z7m02SrVcuvg0gLUlHcl7Ip
4jRrYLQW6k+cMLTRvF7/jyG5eyi4MpScNd8A0SpftimSdWh+BL7Yvo4dBP4GLVmi
k1gj44Y9YBxUn3g2EcEFfz0SRP49nCXQ/gqGM88+M4tCikRo+jqGel4MX6DpLptm
eL4ty/tjABNruKCk+bwhedToMdewdwBaBchJt15Een1ZFa4zJk6F2Fs7VrKUc5bS
0XAGOehNeZYwtnEybHAPFZJwq2UTCNpIsENhAly0oJgC0LN455cfWiNT22bT9YKK
MZIkiSQUpYWn8LrTiYBKFKN8kzZfrZFREOVsmQzDXnW9ZvZFP9IsoJdZ2TUGjCmy
2VS0x2YvlaCS//fk4A7sji1C7nVUZkjK7No58Q3lObpTpIxYNQZ5WaZ2p4p0v31k
f6IpdxeQsAZFlV4+0xpG
=5NGf
-----END PGP SIGNATURE-----

--Signature=_Tue__30_Jul_2013_10_27_54_+1000_PHdWH+Gtq.oE2RHC--
