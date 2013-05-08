Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753371Ab3EHCnV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 22:43:21 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:54167 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752186Ab3EHCnT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 22:43:19 -0400
X-AuditID: cbfee690-b7f136d000000fea-99-5189bbc63c7d
Message-id: <1367980935.16581.46.camel@kjgkr>
Subject: Re: [PATCH 2/2] f2fs: remove alloc_nid_done/fail for performance
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Date: Wed, 08 May 2013 11:42:15 +0900
In-reply-to: <1367974571-29255-2-git-send-email-jaegeuk.kim@samsung.com>
References: <1367974571-29255-1-git-send-email-jaegeuk.kim@samsung.com>
 <1367974571-29255-2-git-send-email-jaegeuk.kim@samsung.com>
Organization: samsung
Content-type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature"; boundary="=-B0k+nJn5b+xCNRtDrqms"
X-Mailer: Evolution 3.2.3-0ubuntu6
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrFIsWRmVeSWpSXmKPExsVy+t8zI91juzsDDU6v4LK4tMjdYs/ekywW
	l3fNYXNg9ti94DOTx+dNcgFMUVw2Kak5mWWpRfp2CVwZh2/OYirYGl3RuukaYwPjH88uRk4O
	CQETiUOzGtghbDGJC/fWs3UxcnEICSxjlDjycCtzFyMHWFHHbnOI+CJGiRlPTrFDOK8ZJZZP
	P8YKUsQroCvxYr8zyCBhAU+Jb7eugvWyCWhLbN5vABIWElCUeLv/Lli1CJB9+b0TiMks4CGx
	61gpSAWLgKrEth3fWEBsTqDwgVkLmSEWtTJK/DxxlgkkwS8gKnGy9RMjiM0sUCVxbdVKJojz
	lSR2t3eCvcIrICjxY/I9FpBmCYG37BJH7z5mg9ggIPFt8iEWiLdkJTYdYIbolZQ4uOIGywRG
	8VlIxs5CMgoirinRuv03O4StLbFs4WtmCNtWYt2691A1NhKbri5ghLDlJba/ncO8gJF9FaNo
	akFyQXFSepGJXnFibnFpXrpecn7uJkZIhE7YwXjvgPUhxiqgEycyS4km5wMjPK8k3tDYzMjC
	1MTU2Mjc0owqwkrivOot1oFCAumJJanZqakFqUXxRaU5qcWHGJk4OKUaGBc9fNtZcbhncbHZ
	XYcTym/VF4iaSLeuXGh5VHclY252A5v0Zt5OIe/9U9wT7zg3r3dbEv9lrYI2m8C/lWK77e7c
	C99Q++2l4Y4HiW971E+eEFJcafXTWn6brkHrg8nMvpeZ1jquud/BGR7qvEWj4tj36EBu/84v
	Pk/PSFvqT+hf57/rker+QiWW4oxEQy3mouJEAGMip/P9AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNKsWRmVeSWpSXmKPExsVy+t9jAd1juzsDDVp3slhcWuRusWfvSRaL
	y7vmsDkwe+xe8JnJ4/MmuQCmqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3Ml
	hbzE3FRbJRefAF23zBygHUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwjrG
	jMM3ZzEVbI2uaN10jbGB8Y9nFyMHh4SAiUTHbvMuRk4gU0ziwr31bF2MXBxCAosYJWY8OcUO
	4bxmlFg+/RgrSAOvgK7Ei/3OIA3CAp4S325dZQYJswloS2zebwASFhJQlHi7/y5YtQiQffm9
	E4jJLOAhsetYKUgFi4CqxLYd31hAbE6g8IFZC5khFrUySvw8cZYJJMEvICpxsvUTI4jNLFAl
	cW3VSiaIM5Ukdrd3soPYvAKCEj8m32OZwCg4C0nZLCQpiLimROv23+wQtrbEsoWvmSFsW4l1
	695D1dhIbLq6gBHClpfY/nYO8wJG9lWMoqkFyQXFSem5hnrFibnFpXnpesn5uZsYwfH/TGoH
	48oGi0OMAhyMSjy8FtydgUKsiWXFlbmHGFWA5jzasPoCoxRLXn5eqpIIb1kBUJo3JbGyKrUo
	P76oNCe1+BDjREZgeExklhJNzgcmrbySeENjEzMjSyMzCyMTc3NaCiuJ8x5otQ4UEkhPLEnN
	Tk0tSC2COYqJg1OqgVFjK/t+oW2OnuUzlvg2duq0rQiXCnquJWCeU+Y6U/OTkXfs/DoFxoAv
	OYwVXd+31M0Kq+PLkRBzDOHarMuq2VVzq/XBhHMPOB/NUqg5+iHON2ezw0Pu8H02hnvr4/1P
	Wsr3Nmt7yMmvfWzro+A6k/v/Sq3lH1hDHzyfvE5GMOxV/VsZy6N/lFiKMxINtZiLihMBAaON
	/X4DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-B0k+nJn5b+xCNRtDrqms
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Sorry, please ignore this patch.

2013-05-08 (=EC=88=98), 09:56 +0900, Jaegeuk Kim:
> This mechanism revealed two issues: bug and performance.
>=20
> Now, iput() doesn't guarantee that the inode is freed completely due to t=
he
> linked f2fs_drop_inode().
> So, in the case of failure on f2fs_new_inode(), we should not add the fre=
e nid
> again to the list even though iput() is called before then.
>=20
> Second thing is for performance.
> When allocating a free nid, we scan to find a new NID_NEW candidate, and =
after
> allocation, we need to scan again to remove the free nid.
>=20
> So, this patch resolves the issues by removing this mechanism.
> Just do this with a simple basic list control.
>=20
> Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
> ---
>  fs/f2fs/f2fs.h  |  2 --
>  fs/f2fs/namei.c | 15 ------------
>  fs/f2fs/node.c  | 76 +++++++++++++--------------------------------------=
------
>  fs/f2fs/node.h  |  6 -----
>  fs/f2fs/xattr.c |  2 --
>  5 files changed, 17 insertions(+), 84 deletions(-)
>=20
> diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
> index 20aab02..2fe2567 100644
> --- a/fs/f2fs/f2fs.h
> +++ b/fs/f2fs/f2fs.h
> @@ -956,8 +956,6 @@ struct page *get_node_page_ra(struct page *, int);
>  void sync_inode_page(struct dnode_of_data *);
>  int sync_node_pages(struct f2fs_sb_info *, nid_t, struct writeback_contr=
ol *);
>  bool alloc_nid(struct f2fs_sb_info *, nid_t *);
> -void alloc_nid_done(struct f2fs_sb_info *, nid_t);
> -void alloc_nid_failed(struct f2fs_sb_info *, nid_t);
>  void recover_node_page(struct f2fs_sb_info *, struct page *,
>  		struct f2fs_summary *, struct node_info *, block_t);
>  int recover_inode_page(struct f2fs_sb_info *, struct page *);
> diff --git a/fs/f2fs/namei.c b/fs/f2fs/namei.c
> index 4aa26e5..077ead1 100644
> --- a/fs/f2fs/namei.c
> +++ b/fs/f2fs/namei.c
> @@ -26,7 +26,6 @@ static struct inode *f2fs_new_inode(struct inode *dir, =
umode_t mode)
>  	struct f2fs_sb_info *sbi =3D F2FS_SB(sb);
>  	nid_t ino;
>  	struct inode *inode;
> -	bool nid_free =3D false;
>  	int err, ilock;
> =20
>  	inode =3D new_inode(sb);
> @@ -60,7 +59,6 @@ static struct inode *f2fs_new_inode(struct inode *dir, =
umode_t mode)
>  	err =3D insert_inode_locked(inode);
>  	if (err) {
>  		err =3D -EINVAL;
> -		nid_free =3D true;
>  		goto out;
>  	}
>  	trace_f2fs_new_inode(inode, 0);
> @@ -73,8 +71,6 @@ out:
>  fail:
>  	trace_f2fs_new_inode(inode, err);
>  	iput(inode);
> -	if (nid_free)
> -		alloc_nid_failed(sbi, ino);
>  	return ERR_PTR(err);
>  }
> =20
> @@ -146,8 +142,6 @@ static int f2fs_create(struct inode *dir, struct dent=
ry *dentry, umode_t mode,
>  	if (err)
>  		goto out;
> =20
> -	alloc_nid_done(sbi, ino);
> -
>  	if (!sbi->por_doing)
>  		d_instantiate(dentry, inode);
>  	unlock_new_inode(inode);
> @@ -156,7 +150,6 @@ out:
>  	clear_nlink(inode);
>  	unlock_new_inode(inode);
>  	iput(inode);
> -	alloc_nid_failed(sbi, ino);
>  	return err;
>  }
> =20
> @@ -287,8 +280,6 @@ static int f2fs_symlink(struct inode *dir, struct den=
try *dentry,
>  		goto out;
> =20
>  	err =3D page_symlink(inode, symname, symlen);
> -	alloc_nid_done(sbi, inode->i_ino);
> -
>  	d_instantiate(dentry, inode);
>  	unlock_new_inode(inode);
>  	return err;
> @@ -296,7 +287,6 @@ out:
>  	clear_nlink(inode);
>  	unlock_new_inode(inode);
>  	iput(inode);
> -	alloc_nid_failed(sbi, inode->i_ino);
>  	return err;
>  }
> =20
> @@ -324,8 +314,6 @@ static int f2fs_mkdir(struct inode *dir, struct dentr=
y *dentry, umode_t mode)
>  	if (err)
>  		goto out_fail;
> =20
> -	alloc_nid_done(sbi, inode->i_ino);
> -
>  	d_instantiate(dentry, inode);
>  	unlock_new_inode(inode);
> =20
> @@ -336,7 +324,6 @@ out_fail:
>  	clear_nlink(inode);
>  	unlock_new_inode(inode);
>  	iput(inode);
> -	alloc_nid_failed(sbi, inode->i_ino);
>  	return err;
>  }
> =20
> @@ -375,7 +362,6 @@ static int f2fs_mknod(struct inode *dir, struct dentr=
y *dentry,
>  	if (err)
>  		goto out;
> =20
> -	alloc_nid_done(sbi, inode->i_ino);
>  	d_instantiate(dentry, inode);
>  	unlock_new_inode(inode);
>  	return 0;
> @@ -383,7 +369,6 @@ out:
>  	clear_nlink(inode);
>  	unlock_new_inode(inode);
>  	iput(inode);
> -	alloc_nid_failed(sbi, inode->i_ino);
>  	return err;
>  }
> =20
> diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
> index 3df43b4..fa5e8dc 100644
> --- a/fs/f2fs/node.c
> +++ b/fs/f2fs/node.c
> @@ -432,13 +432,11 @@ int get_dnode_of_data(struct dnode_of_data *dn, pgo=
ff_t index, int mode)
>  			dn->nid =3D nids[i];
>  			npage[i] =3D new_node_page(dn, noffset[i]);
>  			if (IS_ERR(npage[i])) {
> -				alloc_nid_failed(sbi, nids[i]);
>  				err =3D PTR_ERR(npage[i]);
>  				goto release_pages;
>  			}
> =20
>  			set_nid(parent, offset[i - 1], nids[i], i =3D=3D 1);
> -			alloc_nid_done(sbi, nids[i]);
>  			done =3D true;
>  		} else if (mode =3D=3D LOOKUP_NODE_RA && i =3D=3D level && level > 1) =
{
>  			npage[i] =3D get_node_page_ra(parent, offset[i - 1]);
> @@ -1243,10 +1241,18 @@ static struct free_nid *__lookup_free_nid_list(ni=
d_t n, struct list_head *head)
>  	return NULL;
>  }
> =20
> -static void __del_from_free_nid_list(struct free_nid *i)
> +/*
> + * should be covered by free_nid_list_lock
> + */
> +static void __del_from_free_nid_list(struct f2fs_nm_info *nm_i,
> +						struct free_nid *i)
>  {
> +	if (!i)
> +		return;
> +
>  	list_del(&i->list);
>  	kmem_cache_free(free_nid_slab, i);
> +	nm_i->fcnt--;
>  }
> =20
>  static int add_free_nid(struct f2fs_nm_info *nm_i, nid_t nid, bool build=
)
> @@ -1280,7 +1286,6 @@ retry:
>  		goto retry;
>  	}
>  	i->nid =3D nid;
> -	i->state =3D NID_NEW;
> =20
>  	spin_lock(&nm_i->free_nid_list_lock);
>  	if (__lookup_free_nid_list(nid, &nm_i->free_nid_list)) {
> @@ -1299,10 +1304,7 @@ static void remove_free_nid(struct f2fs_nm_info *n=
m_i, nid_t nid)
>  	struct free_nid *i;
>  	spin_lock(&nm_i->free_nid_list_lock);
>  	i =3D __lookup_free_nid_list(nid, &nm_i->free_nid_list);
> -	if (i && i->state =3D=3D NID_NEW) {
> -		__del_from_free_nid_list(i);
> -		nm_i->fcnt--;
> -	}
> +	__del_from_free_nid_list(nm_i, i);
>  	spin_unlock(&nm_i->free_nid_list_lock);
>  }
> =20
> @@ -1382,8 +1384,6 @@ static void build_free_nids(struct f2fs_sb_info *sb=
i)
>  bool alloc_nid(struct f2fs_sb_info *sbi, nid_t *nid)
>  {
>  	struct f2fs_nm_info *nm_i =3D NM_I(sbi);
> -	struct free_nid *i =3D NULL;
> -	struct list_head *this;
>  retry:
>  	if (sbi->total_valid_node_count + 1 >=3D nm_i->max_nid)
>  		return false;
> @@ -1392,17 +1392,13 @@ retry:
> =20
>  	/* We should not use stale free nids created by build_free_nids */
>  	if (nm_i->fcnt && !sbi->on_build_free_nids) {
> -		BUG_ON(list_empty(&nm_i->free_nid_list));
> -		list_for_each(this, &nm_i->free_nid_list) {
> -			i =3D list_entry(this, struct free_nid, list);
> -			if (i->state =3D=3D NID_NEW)
> -				break;
> -		}
> +		struct list_head *flist =3D &nm_i->free_nid_list;
> +		struct free_nid *i;
> =20
> -		BUG_ON(i->state !=3D NID_NEW);
> +		BUG_ON(list_empty(flist));
> +		i =3D list_first_entry(flist, struct free_nid, list);
>  		*nid =3D i->nid;
> -		i->state =3D NID_ALLOC;
> -		nm_i->fcnt--;
> +		__del_from_free_nid_list(nm_i, i);
>  		spin_unlock(&nm_i->free_nid_list_lock);
>  		return true;
>  	}
> @@ -1417,41 +1413,6 @@ retry:
>  	goto retry;
>  }
> =20
> -/*
> - * alloc_nid() should be called prior to this function.
> - */
> -void alloc_nid_done(struct f2fs_sb_info *sbi, nid_t nid)
> -{
> -	struct f2fs_nm_info *nm_i =3D NM_I(sbi);
> -	struct free_nid *i;
> -
> -	spin_lock(&nm_i->free_nid_list_lock);
> -	i =3D __lookup_free_nid_list(nid, &nm_i->free_nid_list);
> -	BUG_ON(!i || i->state !=3D NID_ALLOC);
> -	__del_from_free_nid_list(i);
> -	spin_unlock(&nm_i->free_nid_list_lock);
> -}
> -
> -/*
> - * alloc_nid() should be called prior to this function.
> - */
> -void alloc_nid_failed(struct f2fs_sb_info *sbi, nid_t nid)
> -{
> -	struct f2fs_nm_info *nm_i =3D NM_I(sbi);
> -	struct free_nid *i;
> -
> -	spin_lock(&nm_i->free_nid_list_lock);
> -	i =3D __lookup_free_nid_list(nid, &nm_i->free_nid_list);
> -	BUG_ON(!i || i->state !=3D NID_ALLOC);
> -	if (nm_i->fcnt > 2 * MAX_FREE_NIDS) {
> -		__del_from_free_nid_list(i);
> -	} else {
> -		i->state =3D NID_NEW;
> -		nm_i->fcnt++;
> -	}
> -	spin_unlock(&nm_i->free_nid_list_lock);
> -}
> -
>  void recover_node_page(struct f2fs_sb_info *sbi, struct page *page,
>  		struct f2fs_summary *sum, struct node_info *ni,
>  		block_t new_blkaddr)
> @@ -1747,11 +1708,8 @@ void destroy_node_manager(struct f2fs_sb_info *sbi=
)
> =20
>  	/* destroy free nid list */
>  	spin_lock(&nm_i->free_nid_list_lock);
> -	list_for_each_entry_safe(i, next_i, &nm_i->free_nid_list, list) {
> -		BUG_ON(i->state =3D=3D NID_ALLOC);
> -		__del_from_free_nid_list(i);
> -		nm_i->fcnt--;
> -	}
> +	list_for_each_entry_safe(i, next_i, &nm_i->free_nid_list, list)
> +		__del_from_free_nid_list(nm_i, i);
>  	BUG_ON(nm_i->fcnt);
>  	spin_unlock(&nm_i->free_nid_list_lock);
> =20
> diff --git a/fs/f2fs/node.h b/fs/f2fs/node.h
> index 0a2d72f..2f226a4 100644
> --- a/fs/f2fs/node.h
> +++ b/fs/f2fs/node.h
> @@ -74,15 +74,9 @@ static inline void node_info_from_raw_nat(struct node_=
info *ni,
>  /*
>   * For free nid mangement
>   */
> -enum nid_state {
> -	NID_NEW,	/* newly added to free nid list */
> -	NID_ALLOC	/* it is allocated */
> -};
> -
>  struct free_nid {
>  	struct list_head list;	/* for free node id list */
>  	nid_t nid;		/* node id */
> -	int state;		/* in use or not: NID_NEW or NID_ALLOC */
>  };
> =20
>  static inline int next_free_nid(struct f2fs_sb_info *sbi, nid_t *nid)
> diff --git a/fs/f2fs/xattr.c b/fs/f2fs/xattr.c
> index 0b02dce..5675920 100644
> --- a/fs/f2fs/xattr.c
> +++ b/fs/f2fs/xattr.c
> @@ -337,13 +337,11 @@ int f2fs_setxattr(struct inode *inode, int name_ind=
ex, const char *name,
> =20
>  		page =3D new_node_page(&dn, XATTR_NODE_OFFSET);
>  		if (IS_ERR(page)) {
> -			alloc_nid_failed(sbi, fi->i_xattr_nid);
>  			fi->i_xattr_nid =3D 0;
>  			error =3D PTR_ERR(page);
>  			goto exit;
>  		}
> =20
> -		alloc_nid_done(sbi, fi->i_xattr_nid);
>  		base_addr =3D page_address(page);
>  		header =3D XATTR_HDR(base_addr);
>  		header->h_magic =3D cpu_to_le32(F2FS_XATTR_MAGIC);

--=20
Jaegeuk Kim
Samsung

--=-B0k+nJn5b+xCNRtDrqms
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJRibuHAAoJEEAUqH6CSFDSO7kP/2a2soS4qehdEzuLtvx1c9TC
H5WBb6xsfRZbnYGfeLrS4I41EPfL7tu4CBg4BTnUW0lv2EvbePqBecMbSGZ8xC/2
UZ3HXGc/oviaYoQoiyqAEpu5oYpfO0Q3rA2gNqby0M/aQZBwTND2NUJLR69nH3dM
/7cb7uLMTDxOXonntmkRjJtLramoA3r3KVycKLimmOdAWDEyr8mGyzSyJBJjRUNk
Cl371hDgJm2SjWBfQHB7bXbUpCP+OKjpERfcknVL8Q4uEZ+91qCT86y39aVbFslN
3KwVf1/eiIEX0JkxJ2WjZKaL79HXmxipWjv0OqPBO5iDM1xtfNsstMIK7/7O66q6
8UloDM076XNLB9yDR3X5c5UaTA8v1w7ZYxezYB30EI6Kb3rPSA16pRvqO4o0a/2T
6H/W/xHY3L8aXS3UH6jgvW9AO4EQ/PkaYrpBumm0jhhqZ1EWv9ZeM/nJY0xszQS5
QbpMFs9NBOPzvs3c75U4/hq/oKTDyiOTeOXev9RksEmXzQgC4Pbj0V6elZl43z2C
XhP++07oeh9NaM/sxSzsouWh8oYyFQF3JwQY8qyvNr3uB93Hyc83JtmWfA0IecLf
z6QnDwBsnVDFWBqnI7U1ymsNo7OAR8064pc/Uy60GgNu25dYgDMmn3UJ9McGok+v
b4HZxFZ+YrRMNAqLBZbe
=w9p4
-----END PGP SIGNATURE-----

--=-B0k+nJn5b+xCNRtDrqms--

