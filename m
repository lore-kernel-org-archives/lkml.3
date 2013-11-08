Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756693Ab3KHHaS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 02:30:18 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:60560 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752858Ab3KHHaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 02:30:15 -0500
Date: Fri, 8 Nov 2013 18:30:01 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>
Subject: linux-next: manual merge of the akpm-current tree with the vfs tree
Message-Id: <20131108183001.2564151a619f8f6df3db543a@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta6 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__8_Nov_2013_18_30_01_+1100_qmBGfF3oh9juQr8M"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__8_Nov_2013_18_30_01_+1100_qmBGfF3oh9juQr8M
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm-current tree got a conflict in
fs/anon_inodes.c between commit 24b0303e9532 ("take anon inode allocation
to libfs.c") from the vfs tree and commit 02f3ac4386d9 ("anon_inodefs:
forbid open via /proc") from the akpm-current tree.

I just dropped the akpm-current changes for today - they should probably
be applied to fs/libfs.c.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__8_Nov_2013_18_30_01_+1100_qmBGfF3oh9juQr8M
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSfJL9AAoJEMDTa8Ir7ZwV5QYP/iaOov15GwSMRqL4JY85IDIy
q6AiWUvrgg8LCLpuCB6X9mLMZue92VRaihsTwx1YZ+xeCc/uT4z0GAckuPo5xs0W
vI4GXN0h/6/Ul+if7UxN4v0Bx3GNKqx1Lv0iHBgV9stiLIEmQjha5yVHjDc+rkrC
66tpI2Y6eAHNL7rTOtTP4G1z0LOMfk6RIdUKyfLzB7AJxMVuV9m41KtZw3JSEgc7
C3TwPBvuyJGLs4Tz7bUjidKb/R10Wd8kcjaB5MU2NavQbKnOTqr2MVpU/smaaRu8
ecghZ64tvu6yAmfAtnk5stGOaL2++FaTZzIExytcXffRo3GxrBuyvGFMkAmAMi4N
k3cskCzq2F6NDlWFADLj3kXBw+P8N3PIoQNDgEB40GLkLkTQkrOJ2EhT19UE/QB0
wvasv890F04v38sFkXDU0sB5tb1wBPukQqw7puicq54TZ7vw22OCnENxerBbWSav
yirlkQrIs9+/BFMO1yApxghIqVp6WRYtlHuNDvPa/LQSKdc7hd4ynP5t+XWCanWF
eGweK/VmynmlH6C/GA1nUYZc6b95FBLkvazNvwXSb04PkrjhR9RYELLZYjvrR+gv
Nu9Pdm/1H2Zyl7nZp9aC0AKRsa9PS7M1KH/QoxXYx1MFaGWhpk5vQ5Klb3Cw1EDN
GP7VRjOyMSWCMEpMTdOj
=7A+b
-----END PGP SIGNATURE-----

--Signature=_Fri__8_Nov_2013_18_30_01_+1100_qmBGfF3oh9juQr8M--
