Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757558Ab3LFKT4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 05:19:56 -0500
Received: from smtp01.online.nl ([194.134.41.31]:45093 "EHLO smtp01.online.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757241Ab3LFKTx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 05:19:53 -0500
X-Greylist: delayed 523 seconds by postgrey-1.27 at vger.kernel.org; Fri, 06 Dec 2013 05:19:53 EST
Message-ID: <52A1A297.9010208@meshcoding.com>
Date: Fri, 06 Dec 2013 11:10:31 +0100
From: Antonio Quartulli <antonio@meshcoding.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>, Marek Lindner <mareklindner@neomailbox.ch>,
        Simon Wunderlich <sw@simonwunderlich.de>
CC: "David S. Miller" <davem@davemloft.net>, b.a.t.m.a.n@lists.open-mesh.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] batadv: Slight optimization of batadv_compare_eth
References: <1386317890.31845.26.camel@joe-AO722>
In-Reply-To: <1386317890.31845.26.camel@joe-AO722>
X-Enigmail-Version: 1.6
OpenPGP: id=43FD7307
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Online-Scanned: by Cloudmark authority (on smtp01.online.nl)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

On 06/12/13 09:18, Joe Perches wrote:
> Use CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS to check if this
> function can be optimized by using the generic ether_addr_equal.
> 
> Remove the unnecessary ?: after the unoptimized memcmp.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Acked-by: Antonio Quartulli <antonio@meshcoding.com>


- -- 
Antonio Quartulli
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSoaKXAAoJEEKTMo6mOh1VMjoP/3GqGy0TQG1yXRzbrzAbbklJ
8Oa6DHQd2pSN/cJkR501JYwSUnCGh3m7eh7qc1HZYrEIgxIrJDLHWSqBL3FPtgap
gQ92BBQG/pd38ZmmWSeZob44bEMEGAn00B1kgFx+Xb4YW4bP2rDAlvPxjjaqjT3U
tBNbNYxUTBY2JMftI7WwEOwMWgLPVoHR1PhAbBTpbXMXCRrGp/vXN1xXam1xIDNx
kahFmHA1Dc91dwr8ev4bcUjfGO2tXkQOEoqKRkwc1SEzuKTjgJNDxdbFNqG6vMAm
k/aXhMvf3DOUkaCeslRQIkwefbKmzN69c1x2ND7S8mLEMIKyBuhKUFcf6PebD9SK
Dc+KdwIx0lsaS2vGqOt6mUSie1KfY8QNAc74eF6XjDhKyJynYXe6S3L40uT4eLXR
8fwGClJmyYVIiYD65NOtiIx6C2uHFchjDpXjlz0X8N9oQ2Azr4e2RMTGkkoihvOh
94r1dmAaBrnRiAu6AkImhgN+lWgLglHWD5trmmRCxNEJf0iW+x9ZaR4yAQFDUP3k
mrk5AN8JuRZkOeY5QK4AIZ0bFUh8tKW6JaNb8VHQGsLqjhAB/HPS6VljyRgMalyQ
c/kLlEOIIZ9dsjMwKMgyoJ9bMtTYUTxrriKz12mQbx8mWvm4CMFEQglljQiuTyvh
J+UsjAHs/ffW59JIGCfB
=8xL7
-----END PGP SIGNATURE-----
