Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751583AbaC1HVg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 03:21:36 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:42258 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751077AbaC1HVe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 03:21:34 -0400
X-Sasl-enc: jIEQZJCV9URN2O/AyRwmH63+Go5cD1S6T63mdHQpMnjy 1395991293
Message-ID: <1395991272.2704.16.camel@perseus.fritz.box>
Subject: [ANNOUNCE] autofs 5.0.9 release
From: Ian Kent <raven@themaw.net>
To: autofs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 28 Mar 2014 15:21:12 +0800
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-LDsRlOBtqTRj6+DRClSC"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-LDsRlOBtqTRj6+DRClSC
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi all,

Here is a bug fix release for autofs.

For those that have clones of the git repository the master branch
will progress to autofs-5.1.0 and autofs-5.0 will continue to be
updated with bug fixes (and periodic releases) on the new branch
autofs-5.0-stable.

For those that have git clones that include the branch autofs-5.0
you probably want to prune your remote as that branch has been
deleted.

autofs
=3D=3D=3D=3D=3D=3D

The package can be found at:

ftp://ftp.kernel.org/pub/linux/daemons/autofs/v5

It is autofs-5.0.9.tar.[gz|bz2|xz]

No source rpm is there as it can be produced by using:

rpmbuild -ts autofs-5.0.9.tar.gz

and the binary rpm by using:

rpmbuild -tb autofs-5.0.9.tar.gz

See the INSTALL file for information about configure options and
kernel requirements.

Here are the entries from the CHANGELOG which outline the updates:
- fix undefined authtype_requires_creds err if ldap enabled but without sas=
l.
- fix master map type check.
- fix task manager not getting signaled.
- allow --with-systemd to take a path arg.
- fix WITH_LIBTIRPC function name.
- fix ipv6 libtirpc getport.
- fix ipv6 link local address handling.
- fix fix ipv6 libtirpc getport.
- get_nfs_info() should query portmapper if port is not given.
- fix rpc_portmap_getport() proto not set.
- fix protmap not trying proto v2.
- fix rpc_getport() when libtirpc is disabled.
- fix rpc_getrpcbport() when libtirpc is disabled.
- don't reset errno.
- extend fix for crash due to thread unsafe use of libldap.
- fix deadlock in init_ldap_connection.
- fix options compare.
- fix negative status being reset on map read.
- check for existing offset mount before mounting.
- fix max() declaration.
- fix symlink fail message in mount_bind.c.
- fix cache readlock not taken on lookup.
- pass map_source as function paramter where possible.
- check for bind onto self in mount_bind.c.
- fix symlink expire.
- dont clobber mapent for negative cache.
- fix macro_addvar() and move init to main thread.
- change walk_tree() to take ap.
- add negative cache lookup to hesiod lookup.
- fix external env configure.
- make autofs(5) consistent with auto.master(5).
- fix map source with type lookup.
- fix lookup_nss_mount() map lookup.
- dont ignore null cache entries on multi mount umount.
- fix inconsistent error returns in handle_packet_missing_direct().
- simple coverity fixes.
- fix fix options compare.
- use open(2) instead of access(2) to trigger dependent mounts.
- fix fix map source with type lookup.
- fixes for samples/auto.master.
- fix variable substitution description.
- fix incorrect append options description in README.v5-release.

Ian


--=-LDsRlOBtqTRj6+DRClSC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAABAgAGBQJTNSLoAAoJEOdnc4D1T9ipjxcP+gLSHyPYAaKEoVO5VniQzWrD
0x/hPNCSFnkBBQKstliuJalZJNSijZMEm9yLpPU+/+sNom/2SuwobR27w4vo9ZMw
ubEFiRUIADFa4PugCStmeYYEF1Kn0Dmoy+7ZhT6gZGlGd+UO5hiMzzCGRM+M5OFG
driOV5z/1QtXk7sUAlHxutTr49AYTX1Q93kpaDHNWMgmqDJP5aJlpiJVFj1q9+yi
fzzZuH7hFdb0rGba78hSprnazS0FRggGiHE+DSLsvQl/OiWDGo+TTGz2P+6eJjYC
Y55fKMVLg7sseVpcwbi/4luEccXH+sPFtuHw2IrwtUKLZoZNplbrSkIp5QlhIKah
pLkmSsWSvxyW+n6Us9LdyMDCmyjhyd1ZngKuRVOMKKZIcI8h4tCnCqtCRQsf4wB6
Nk0u3ldCM2wNdXVmcouKviKb1dC/o0HxiqvZ8CfrPjbjc6uyQUT8BvS6M9ndju6a
s6L/uaB7vyNqF3Zi6lGq2db7E1qd0qDyzaGVvp/zGbuLrDtiVQBfcuYTbu8SSjK9
vQ0qBAJ+r4A85F6ATWaMKIFSTo6wfF4iJBqaXw9V63rYFMi1I6Cwn3NAaTnYOzV8
vMKXeG6yxMyhcDfIrWxWOUidHQAfqdWuQ/8xUczJ2jNaCAPJogcLZVyQgoS7d2/I
m77UzzTmemV8Xw8q1E3d
=Xflv
-----END PGP SIGNATURE-----

--=-LDsRlOBtqTRj6+DRClSC--

