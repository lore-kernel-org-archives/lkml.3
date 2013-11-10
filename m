Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752296Ab3KJVdO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Nov 2013 16:33:14 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:59461 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752061Ab3KJVdG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Nov 2013 16:33:06 -0500
Date: Mon, 11 Nov 2013 08:32:51 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@infradead.org>,
        Dave Kleikamp <dave.kleikamp@oracle.com>,
        Kent Overstreet <kmo@daterainc.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Zach Brown <zab@zabbo.net>,
        Olof Johansson <olof@lixom.net>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: linux-next: manual merge of the block tree with the  tree
Message-Id: <20131111083251.c63d63e5eb3762c1b7b6aec8@canb.auug.org.au>
In-Reply-To: <20131108161508.GL10212@kernel.dk>
References: <527414DE.9090704@kernel.dk>
	<52756583.2030808@oracle.com>
	<527BE7FA.90904@oracle.com>
	<20131107192545.GA20624@moria.home.lan>
	<527C2AA9.9040608@oracle.com>
	<20131108125307.613427c04a7527c4359e6443@canb.auug.org.au>
	<20131108020805.GI3842@kmo>
	<527C4D35.8000907@oracle.com>
	<20131108073324.GA31662@infradead.org>
	<20131108152915.GI10212@kernel.dk>
	<20131108161508.GL10212@kernel.dk>
X-Mailer: Sylpheed 3.4.0beta6 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__11_Nov_2013_08_32_51_+1100_EAMeqg1sC2NkDZQc"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__11_Nov_2013_08_32_51_+1100_EAMeqg1sC2NkDZQc
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

On Fri, 8 Nov 2013 09:15:08 -0700 Jens Axboe <axboe@kernel.dk> wrote:
>
> On Fri, Nov 08 2013, Jens Axboe wrote:
> > On Thu, Nov 07 2013, Christoph Hellwig wrote:
> > > Btw, I have to state that I very much disagree with dropping the
> > > direct I/O kernel changes, and I also very much disagree with keeping
> > > the immutable iovecs in.
> > >=20
> > > For the latter I think the immutable iovecs are useful and do want to
> > > see them eventually, but they were merged at the latest possible point
> > > in the merge window and cause breakage all over the tree, so they very
> > > clearly are not ready at this point, and I fear even more breakage if
> > > they do get merged.
> >=20
> > I agree, I've had this very conversation with Kent as well. The merge of
> > it has gone a lot worse than I had feared, and the resulting series at
> > this point is a non-bisectable mess. The fallback plan was to pull it
> > from the 3.13 tree and shove it into a 3.14 tree with more for-next
> > simmering.
> >=20
> > It is in progress, just takes a while...
>=20
> And it's done and pushed out. for-3.13/drivers is still missing the
> bcache bits, those will get merged back in once they don't depend on the
> immutable changes anymore.
>=20
> Dave, this should make your life easier. And Stephen, if you pull the
> new for-next, it should make yours a lot easier as well.

I have added the aio-driect tree back for today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__11_Nov_2013_08_32_51_+1100_EAMeqg1sC2NkDZQc
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSf/uJAAoJEMDTa8Ir7ZwVGxIQAIkWxFDyS0QnAq8ncDYv4VHu
uMrSYOf+bSsziqOQ9f/nFAG3raq2F08hodo+5RNwkcaZGI/7rgh/VU86mOCaHXdy
F8/B//cGtiK5fp52ogrKU3eXQvQIUmMEW4MsDnRNtGielTox4On8uQ0JAh+o53kj
+0VUtGujKYfW9E24f0mxs87a7i2W2G90oI5VHmmlTlzKCIUwfnUYxXca8KhNWsXm
XBuWJrriY4eSpjtZLQoJcEMMwwinm6oSD5mmGb5XInyIWmS6qJ4zT8+ZWs4ncDEW
yH2zX4hkF4wTI87pI3d2G+AxuqtK8OjXpc9UM5U3yqhuNyEW2HG2e3oajEvY4tb3
vDb48MOYjgjkRiNs4+I+yCH+zzsx27S5KavwKbZUbrgxO2r5pPuIWUdK1Wk9cnuD
oFanwjWBlPeFsG0i0kVMr/cHBFUldNF4jjciLGD77lS3QRZIK7fnnvTqZE13RcDT
FG7Wvyc7eu9Raq3nSW0E0n3fNLEcVm7ptD583KvWPbEz3vpxNIEkK/Vt/tKzh8fW
3f4njGspuoqWETtXNJwhnoHO0izIJWAtyWaT3oylsCz971xdc3AJgyyeauUZTBn5
YFIR5K+BPLLJbXfFc+JSqScinVDEUSJxJuhG5hK78RhJCPX9ow4hndEGUwMFIvnU
672t/h2WdEnQG+DWDAVK
=ZH54
-----END PGP SIGNATURE-----

--Signature=_Mon__11_Nov_2013_08_32_51_+1100_EAMeqg1sC2NkDZQc--
