Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752463AbaLYOmz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2014 09:42:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43237 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752186AbaLYOmv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2014 09:42:51 -0500
Message-ID: <549C2256.5010704@redhat.com>
Date: Thu, 25 Dec 2014 09:42:30 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Nicholas Mc Guire <der.herr@hofr.at>, Al Viro <viro@zeniv.linux.org.uk>
CC: John Stultz <john.stultz@linaro.org>, Ingo Molnar <mingo@kernel.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Trond Myklebust <trond.myklebust@primarydata.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] doc fix - brlock was removed in the 3.13 kernel series
References: <1419506981-23952-1-git-send-email-der.herr@hofr.at>
In-Reply-To: <1419506981-23952-1-git-send-email-der.herr@hofr.at>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 12/25/2014 06:29 AM, Nicholas Mc Guire wrote:
> The brlock was completely removed in the 3.13 kernel series. see
> commit 0f6ed63b1707 ("no need to keep brlock macros anymore...")
> 
> It seems that documentation in seqlock.h was not updated to
> reflect this. This patch drops the (hopefully last) false brlock
> reference. All remaining references to brlock refer to byte-range
> locks (notably in cifs) and not to "Big Reader Lock" and should be
> correct.
> 
> patch is against 3.19.0-rc1 linux-next
> 
> Signed-off-by: Nicholas Mc Guire <der.herr@hofr.at>

Reviewed-by: Rik van Riel <riel@redhat.com>

- -- 
All rights reversed
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBAgAGBQJUnCJVAAoJEM553pKExN6DTl4IALfePxNFoRphS8CmLbONtqmi
Bs4gu9ngJq6BLenk6bOF5wfMCRTBXHagWnn14wrjjZOFBkh9Fh+Zy+8GKS31rwUL
GNsCdOUoSBRts2xXMCIxX2cE6+xclYXD5/nWC0InrGtYGfMQmVr5hdLy3UYQu5GO
M0JaWKuvZE06/pz4ntPKWx0wX15o12ojHQy1IgD9d/J5pe2odAZ2WIueioJAqVes
0PM3rgSlsdFanI+RNAm5OUmTNqVF9S+ctbdjJN0MpJVBBun1XtdyefhnBeNRZIRf
9wmMiHU5sFcg3wEraIQ2lZoPCvFcNw4FHt95S5wS3zNI8FJUN0zm4gLe36hh0EU=
=qaLQ
-----END PGP SIGNATURE-----
