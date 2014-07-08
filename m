Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754781AbaGHMwP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 08:52:15 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:56890 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752912AbaGHMwO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 08:52:14 -0400
Date: Tue, 8 Jul 2014 14:52:03 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "xiaofeng.yan" <xiaofeng.yan@huawei.com>
Cc: mingo@redhat.com, juri.lelli@gmail.com, linux-kernel@vger.kernel.org,
        xiaofeng.yan2012@gmail.com
Subject: Re: [PATCH] sched/deadline: overrun could happen in start_hrtick_dl
Message-ID: <20140708125203.GP19379@twins.programming.kicks-ass.net>
References: <1404809607-26197-1-git-send-email-xiaofeng.yan@huawei.com>
 <20140708093334.GD6758@twins.programming.kicks-ass.net>
 <53BBD4A7.5050701@huawei.com>
 <53BBDAFE.1070309@huawei.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7jjDTNL5GSSsPbWk"
Content-Disposition: inline
In-Reply-To: <53BBDAFE.1070309@huawei.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7jjDTNL5GSSsPbWk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 08, 2014 at 07:50:22PM +0800, xiaofeng.yan wrote:
> I have tested this solution, It can work very well with deadline schedule
> class.

Great, please send it as a proper patch and I might just press 'A' ;-)

--7jjDTNL5GSSsPbWk
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTu+lzAAoJEHZH4aRLwOS6BnoP/3O3YexhPHiuTGb3XRpmCeYq
AdbZ4+rEVRs6Wx2zJkRSi4hsJmrMDw7katndVuWRmfDmU4ejmwtFK9T2J0+PerFT
uauBt1rkLbqQDmgiftyBTrpwygluDvIiZFurOVw5oxO/maws3Gf9WH96qA/2h3Xn
oOc3+xjcC20hC2AG9VFXMYInguL/ezWYPfmQar+9pmwX95va1nTc45ynqz2AOgXC
8VoLkLqtqyAIwBEjhboPNR/SxW6gyPdXOAyEvvNIkPoKEO/Cya1shmPh0yri4Pxe
BY42UPNo6pwV8PF4fsl82E3JJEv9tR1m4NOQhvJ9Lk7Om6gnq6U6is3kYJ+uHPlC
3ChK84WljN9RfoFVXfpGoVuEOJw2jUoI6xVRk+GcTzEiZKmdw5lQA8WgqpkVlKom
U+rlxfagtoiyXbVKxrcFKnGhDvsW11UmC2ExvKgkw2iSEhqfzLyEL4oOc1++C5L9
dgfZWAW1WsBWTlTVu884uJqKk5qFmNH2xfwIe78VhaYdZDrfelD9OJOlyCInYllj
UPy3N+dLYVR22a0JHF1lHHVHS0dcZCTYH5sct7JPL29fb3CrxRbsYJMb8a7I84Am
Nm0Rk0VV4GpGqE8NUNdkUotbUPnMiSUPl9ef/vk+0edEfaggH7q5eNjD2gMJkxes
YbibLaGKf5JASwvLFjt9
=1JLr
-----END PGP SIGNATURE-----

--7jjDTNL5GSSsPbWk--
