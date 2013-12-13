Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752556Ab3LMKli (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 05:41:38 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:40275 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752269Ab3LMKlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 05:41:37 -0500
Date: Fri, 13 Dec 2013 10:41:28 +0000
From: Mark Brown <broonie@kernel.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Srinivas Ramana <sramana@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Message-ID: <20131213104128.GT11044@sirena.org.uk>
References: <1386718523-2587-1-git-send-email-sboyd@codeaurora.org>
 <1386718523-2587-4-git-send-email-sboyd@codeaurora.org>
 <20131210235000.GK11468@sirena.org.uk>
 <52A7AE1B.3040201@codeaurora.org>
 <20131211005106.GL11468@sirena.org.uk>
 <52A7C0C3.2070805@codeaurora.org>
 <20131211132729.GT11468@sirena.org.uk>
 <52AA42FD.4040503@codeaurora.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dBMBt2YGaTHbdllf"
Content-Disposition: inline
In-Reply-To: <52AA42FD.4040503@codeaurora.org>
X-Cookie: You will be successful in love.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 3/8] regmap: Add support for using regmap over ssbi
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--dBMBt2YGaTHbdllf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Dec 12, 2013 at 03:13:01PM -0800, Stephen Boyd wrote:

> > bulk_read() should decay to individual reads if there isn't a block
> > operaton and it's not like the hardware actually supports bulk reads
> > anyway.

> So regmap_bulk_read() should work if I don't have a map->bus? To make it
> work with reg_read/write I had to do this. I'm not sure how to make
> bulk_write work.

Yes, I'd expect the operation to work.  Your changes below are mostly
fine (we should add an additional check for values that aren't integer
numbers of bytes, I can add that) - can you send as a signed off patch
please and I'll apply?

--dBMBt2YGaTHbdllf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSquRVAAoJELSic+t+oim9bUYP/iqE/7vqweHgX3+bC/PySrmO
370UV1hgg6q1cpOlm6EbZNnRt7PSRr8whYeTBQhXR+TbP3QMnlAEMT8VXpq7PEEL
gvrHeQ5yPzRsWfXxro2bxssqHBTUM6Ob8lxdkYoj0M6/3+Tbkhs+GDqdSeUA/ME0
Fs8XXy5WUB/7Zux3VrbVc6ciVvSjAB99CuEvdmvjD1gPqHm/DQpjZixLpTc+V3ik
XzHRT2n1fjTvaww2w123vY9G+kF4qvQ7dmRpaFvTWABO3d9HnMzZ05Yab1fc2qis
tEp5nMpIZQqKC2IkU1vuYTCwfEd/UI7/wwQ7gTrCftYy+i88b9OZlKQpt28gfRgn
9OSeoBhSzU2SRn+dMOAELED7uCvbsf2GuF3WYgVcet6KpKuxZ/8G/xyXcba+9dPP
CfFWlcfdTTpN/Ymyqm2t89uxSud1VfQoJu5P31weMtDXq6A/lZlQhs3T6kGq/LuI
1yfEh7YpxmRgd4nzh4/9KxITFkNEocUs7eTLt3KeDG8NQ1xn9ebKeeiDGLqWL/9F
0GvhE5nPfzFlB65HcG6F9cqZKRejv+15b1yy+vPixylnouC6S9pqWdijvCkqaKXn
EvaYfi3wwvlLOlepBKg5bHQaH7vb/N3bjLH0eLq9yadefF8kNIVxvPWG8eGIWoBX
NjO7CsbTchRj1d3t07Ab
=Se/7
-----END PGP SIGNATURE-----

--dBMBt2YGaTHbdllf--
