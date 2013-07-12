Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932428Ab3GLBBp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 21:01:45 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:53638 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756125Ab3GLBBn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 21:01:43 -0400
Date: Fri, 12 Jul 2013 11:01:24 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mike Snitzer <snitzer@redhat.com>
Cc: Alasdair G Kergon <agk@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>, dm-devel@redhat.com,
        linux-kernel@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Hannes Reinecke <hare@suse.de>, Jim Ramsay <jim_ramsay@dell.com>,
        "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Milan Broz <gmazyland@gmail.com>, Rob Herring <robherring2@gmail.com>,
        Robin Dong <sanbai@taobao.com>, stable@vger.kernel.org,
        Yann Droneaud <ydroneaud@opteya.com>, axboe@kernel.dk
Subject: Re: [git pull] device-mapper changes for 3.11
Message-Id: <20130712110124.0b396bfe9c4753e5c098356e@canb.auug.org.au>
In-Reply-To: <20130711133511.GA12287@redhat.com>
References: <20130711013448.GD32399@agk-dp.fab.redhat.com>
	<20130711162040.8a82cb97a6c647c4f61f919b@canb.auug.org.au>
	<20130711133511.GA12287@redhat.com>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.19; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__12_Jul_2013_11_01_24_+1000_7UPrRxgiPMmRTttD"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__12_Jul_2013_11_01_24_+1000_7UPrRxgiPMmRTttD
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mike,

On Thu, 11 Jul 2013 09:35:11 -0400 Mike Snitzer <snitzer@redhat.com> wrote:
>
> I'll be transitioning in to maintain device mapper (for 3.12).  Alasdair
> will be helping me as needed but ultimately the plan is for me to be the
> one sending DM changes upstream in the future.  I will maintain a
> kernel.org git tree with a 'for-next' branch for you to pull.  I'll
> likely base my for-next on Jens' for-next as a rule (unless that isn't
> ideal on a linux-next process level).

OK, that sounds fine as long as Jen's never rebases his branch (I think
he is pretty good about that).

> There will be a learning curve for me initially on how to interface with
> linux-next, proper git rebase protocol relative to Linus' ideals, etc
> but I hope to cut through that quickly.

Excellent.  Please feel free to ask if you have any questions.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__12_Jul_2013_11_01_24_+1000_7UPrRxgiPMmRTttD
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJR31VpAAoJEECxmPOUX5FExuIP/iXWT8Qv1PeQVtK3UkiwS0YT
4CN5qpHsal9Km9eulkzPWVYriynkEG3ZvhwmJpMihjd+FrHD/TfzrGW2DPDOPq35
y3GabK61NrzeL5if7tZMW0fAfULBE1mOG8r1KPkczT/hrnTLUvSHYCClBgKoE32g
ZUfLonFAf4+yjmDbTYrKik3G3GvIZpEj7UkoPfzRUFsFxe0YIkiPqAOSKvOnpd1M
kKERTvAYjukEcBZBnQCa7TV/BxxRfGafPLwHYFCsicK5NoFfv6httTXQLBucqjC7
XMVT02jh3q79/wRnENEfAeq1NnJpvKTedpVGKYqAanmftc8Z6eeVNI7tph6Ul+qj
ftMLIZ7r2pnaG24BgGjysvxh4GcjPvql1IgM45z9nznkRZllLmXYjtpiBnd7QD3X
h4nPjKEVwOYaF0CotKY5Rk6FNVFboIVQO0SuAj2DrdRbsYUJrHmTTJgN3SQSvkhW
bDqn1/7o9SO7NEnKQ/CYU0Qkrx7SmirhG8OF6rMORMFoEQSPImB+jL8yS3scSn3p
SOHdv9iW3vydz1/sD0aBvkiec16ASzOHcDqXd/rqK+S0ELLPw4krKrbGHpk4NXWX
ZS3ooocbzKLJFawzTcD9kZOUtPLcNodr02YJntBRouMRQ6EjGsPipASqF407LoFA
IHZNuH4Kq70P3VwAIA/S
=M8Yv
-----END PGP SIGNATURE-----

--Signature=_Fri__12_Jul_2013_11_01_24_+1000_7UPrRxgiPMmRTttD--
