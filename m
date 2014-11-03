Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753405AbaKCTa2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 14:30:28 -0500
Received: from sauhun.de ([89.238.76.85]:47254 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752329AbaKCTaZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 14:30:25 -0500
Date: Mon, 3 Nov 2014 20:31:28 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-spi@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Balbir Singh <bsingharora@gmail.com>
Subject: Re: [RFC 0/2] drivers: spi/i2c: account completions as iowait
Message-ID: <20141103193128.GA1449@katana>
References: <1414936689-2707-1-git-send-email-wsa@the-dreams.de>
 <20141102165943.GT10501@worktop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rwEMma7ioTxnRzrJ"
Content-Disposition: inline
In-Reply-To: <20141102165943.GT10501@worktop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--rwEMma7ioTxnRzrJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

> If people really think its worth; we could invent new IO-wait measure
> that do make sense -- maybe, but the current thing is complete bollocks.

One more reason to simply convert this one I2C user back to plain
wait_for_completion() for now.

Thanks for these explanations!

--rwEMma7ioTxnRzrJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUV9gQAAoJEBQN5MwUoCm28ZIP/Rd7XLlywV/dVxy7h68HuCLF
i6/ZJov8UgG0J6BIGgtkmH1Jwr4eAWyddC1EkdXzFKo7KelVE0UYmD5WCnsrjpyW
t9h+dLh4f/VawNEta9tP8j1wUTNtSQktqi4Qb5mKEF0PTRN5ir+rcJIbIxkjDW4d
1vEB5/CfuqrEAxCZYf8NKEpUfvj2frtoq+zBsCoW6XKmZ16gkztuXukorH0moAFb
5JNIlNFe95nQL+2yHsFc4MARxtdCVNErfoXHxKoFytYsxIbqQTUv6b6yUJYScfoQ
rq9tv+5YW16UsQCm04y7y4z6cqVRVEeUa0RhDbF3QjHfuS34rEj6JMosksmFrE1C
OStLdNAUw2+YQOMKjgI1CzxbOU98UKll9cVERU9gukWlyBaTXwNVNnOGT7XPVfUD
Z7q7vVTifIO3wzW47tKB40dAVIvG2/q5VkEJeLcBnoeIA/UW+HMjzH+HofCvN0Vn
H3wUEbBmMP1kBwXpN0sOlCpHcHpnjgHve3ipxfeAc29KwDhfs4WAJYeZZtSm5Moy
SeWu6ZCfthvjEh4znlrp468QAWZjT2vwdkF8wPa+qsOx0G3R6yJbW86qhSxJyien
0vYyEUCht/f1KbBN1eHJt0DM4x6faWES/SP3Dv3qsY3N+6tNCxn0CPn64nF5n6wb
Jgi86BPpnFr4CCQ7bRKf
=xjLs
-----END PGP SIGNATURE-----

--rwEMma7ioTxnRzrJ--
