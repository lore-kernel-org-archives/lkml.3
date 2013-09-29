Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754872Ab3I2Rlr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 13:41:47 -0400
Received: from sauhun.de ([89.238.76.85]:35015 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754520Ab3I2Rlo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 13:41:44 -0400
Date: Sun, 29 Sep 2013 19:41:30 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: David Airlie <airlied@linux.ie>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH 0/8] i2c: Remove redundant driver field from the
 i2c_client struct
Message-ID: <20130929174130.GA3367@katana>
References: <1380444666-12019-1-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="liOOAslEiF7prFVr"
Content-Disposition: inline
In-Reply-To: <1380444666-12019-1-git-send-email-lars@metafoo.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--liOOAslEiF7prFVr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Sep 29, 2013 at 10:50:58AM +0200, Lars-Peter Clausen wrote:

> This series removes the redundant driver field from the i2c_client struct. The
> field is redundant since the same pointer can be accessed through
> to_i2c_driver(client->dev.driver). The commit log suggests that the field has
> been around since forever (since before v2.6.12-rc2) and it looks as if it was
> simply forgotten to remove it during the conversion of the i2c framework to the
> generic device driver model.

Great! Looks proper from a first glimpse. I'd think it makes sense to
take all patches via I2C. So, I am looking for ACKs for other subsystems
touched.

Thanks,

   Wolfram


--liOOAslEiF7prFVr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSSGZKAAoJEBQN5MwUoCm2/TkP/iB3Li27waUCgxPpQKf4gPQi
49GJQg2lbVxpE+YpFHUiVbOrYY6sESM3Qtj4QpdsEhNulqujDJBtMK2Ie7eWyCFp
TjyOJCjP8m0br6cUExHkxF+Pxt0YDoxbxkzKx2TGqxaNc9rCl2m7Mc8utzXWcSOd
UIv5RhXPTwVLCtnP1aYSzRPK2kAe9R0vmZjTXYO2ogrlk7PTCTjwabekzPb/xcG9
xJuEhgh7OguGtwDiCse6CUzCmmeNid5pPMdRDmlxz4EyvsI0n7veWLsCaNBQ9Tle
1VY14aVx7rfMwsTDO2EBdUtqb6184wY2TD8osxtXcc9x8xwEU2RXZgPTcWspx9WB
f+1sG/USwmFup2YEV3APVJlLQs+CyUIKDCoaDMEU1JKMFCSz9OwKnC5uoq5qf9fN
kfSYjkqVsNFcQVsudHPrjAKhcL8QJADzmVDt7mMI/BWsAEmEy9w+VPe4MsHmYQAV
J9blY7uTkIRSYtYYgRH2CcgxM5ucGf0taIzcgNqzMSyfHjRe6Z36s4hK2ftR6pWu
o1lqKhk3mKdb9VS/ZNuZx7M9yqUOL/9fRIDbYbWVmFIqBVmKheZ/mNgR1wVBIZrK
C45Tggj3qZPG5ILOB6LjowsDia+QQ8/rbUvrqoTPLhR13M0Ql8nJT9jycG/pjLtt
Fpu3snXkRcaIxjZS7pQM
=pXY2
-----END PGP SIGNATURE-----

--liOOAslEiF7prFVr--
