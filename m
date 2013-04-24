Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757247Ab3DXHOW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 03:14:22 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:53148 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752604Ab3DXHOV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 03:14:21 -0400
Date: Wed, 24 Apr 2013 09:14:15 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Chao Xie <chao.xie@marvell.com>
Cc: linux-kernel@vger.kernel.org, xiechao.mail@gmail.com
Subject: Re: [PATCH V3 2/3] pwm: pxa: use module_platform_driver for driver
 register
Message-ID: <20130424071415.GE1429@avionic-0098.mockup.avionic-design.de>
References: <1366770234-5829-1-git-send-email-chao.xie@marvell.com>
 <1366770234-5829-3-git-send-email-chao.xie@marvell.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xJK8B5Wah2CMJs8h"
Content-Disposition: inline
In-Reply-To: <1366770234-5829-3-git-send-email-chao.xie@marvell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:KFSZXmyiJdH7olvUDE8B/+E44M1G3dHNY8Hj2fTh6p1
 x8MDF+135KtVBcW5NCl7oL6CZV+eTThJvzLEc4Itb2DqgzHqE1
 9MdmPCNnwXlS+b4AnmhLXeaZo+haXwRlhsFVRMJtAnXE3MdZo5
 WJ1aobKY93fMt2zOa3++57ou5XqiZSpd0NYPzJCoiKMZgroTmi
 5WrmnXVkwxVfLGIDjb9Fs5/4t8hZj9ViqsK/YEYAAyAwvBLDVK
 mgSkAwKzHuUiAAm1dzW/FwKB3MYbWLYU1IJTfHKHeDc5oc6R/i
 AoDpiD5B+Z6ipCFNVr23h2uxhf7owyk0HIswMt67RW5C8vKwNi
 xCm+RTj75TWZ1m1R4pWD1Bb3C6RfEbY04ZOtSSErUW6is8ZisG
 nYT0Cv8fy8HQTY97uZdhn0RJPrxt55aASY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xJK8B5Wah2CMJs8h
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Apr 23, 2013 at 10:23:53PM -0400, Chao Xie wrote:
> Signed-off-by: Chao Xie <chao.xie@marvell.com>

The subject is a bit redundant. Something like:

	pwm: pxa: use module_platform_driver()

would be enough.

But I'd like to see a commit message which also mentions that the driver
used to be registered with arch_initcall() and why it is okay that it
isn't anymore.

Thierry

--xJK8B5Wah2CMJs8h
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRd4ZHAAoJEN0jrNd/PrOhtCsP/A24QddzkHiRlAtr5hnY3nBO
StB1lZyOnbjDn05BDIjLxPn3Jilne+V6cuJ4zNmuEca9r4/ddhRhMkxKSk8MLLaN
peuAx4aOYXp27FemHsazzU3IUHxyfKDLz4SgpTlEF6OEr+RcgiULNYq9N5PGhEcB
jawIIbtMNoEH1drI/k8gJnhq4kDwVnwCnAuJLoDA8GclYCSNm8gyH/4FwZ1hpE/X
sg+bfrSqcRfw4nNWFdLgdWXqDJJr2B1qz2WbFQaVRWfomXCEhWq44X7V0jt0sBu0
n37vZri8OmS0CRQ9x830nzLZIzdebOEYDV+nOPh9XVvRDsy3ETZ7bl39nX2VUH1q
OnOjM1lVv9f5h6lRtLBpb4L6PXN0ZMxOcHY5U5OCRgLpo4RW01NB78KSTYk9Sod4
JfweC469Vk37fP6o2PSKF8o2aSmjQINY9Zu03TIHKagOLW/e0A6A90nj3W7VSXuG
G3I/+CR2l/onwurcJ+EcX66IIIEhS+lbflTnbktMtRea4oWXYeUzxJCJqXYqQcwq
af78gNeL+NNRijH296jelnxKWIEhSWPm/r5qn1RcJmQ93kim9sLj3EAxXfO+Db6R
wtSD/cVuHjqig8m3uwtnPR3ziLvD4IhDvXCBY3aR/dD4mYorWzmwaqKXDeekkOyL
BZqd2Ojx+9zA1SYb7AZf
=QuAl
-----END PGP SIGNATURE-----

--xJK8B5Wah2CMJs8h--
