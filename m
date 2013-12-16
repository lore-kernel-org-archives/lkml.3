Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753715Ab3LPMNr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 07:13:47 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:35650 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753045Ab3LPMNp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 07:13:45 -0500
X-AuditID: cbfec7f4-b7fc96d000006cd4-2f-52aeee77c8b6
Message-id: <1387196021.4280.7.camel@AMDC1943>
Subject: Re: linux-next: build failure after merge of the final tree
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Mark Brown <broonie@kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Kyungmin Park <kyungmin.park@samsung.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus <torvalds@linux-foundation.org>
Date: Mon, 16 Dec 2013 13:13:41 +0100
In-reply-to: <20131216114510.GE3185@sirena.org.uk>
References: <20131216164721.79bfe996919a8ec3576867c7@canb.auug.org.au>
 <1387177714.4280.2.camel@AMDC1943> <20131216114510.GE3185@sirena.org.uk>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.2.3-0ubuntu6
Content-transfer-encoding: 7bit
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrALMWRmVeSWpSXmKPExsVy+t/xa7rl79YFGRx+IWoxZ/0aNoupD5+w
	WZxtesNucXnXHDaLgwvbGC227r3KbvGo7y27A7tH440bbB6bVnWyeZyY8ZvFo2/LKkaPz5vk
	AlijuGxSUnMyy1KL9O0SuDKWrzrMWPCfreLHg1usDYw3WLsYOTkkBEwkbkxfyAZhi0lcuLce
	yObiEBJYyihxf+k0KOczo8S+/6tZQKp4BfQkem/PZgKxhQVcJC78e8EIYrMJGEtsXr4EbJKI
	gLLE1e97WUCamQVeMEoc2tcFlmARUJX4u3MJM4jNKWAkcWVTLzPEhomMEisvrmYHSTALqEtM
	mreIGeImJYnd7Z1QcXmJzWveMkNcISjxY/I9lgmMArOQtMxCUjYLSdkCRuZVjKKppckFxUnp
	uYZ6xYm5xaV56XrJ+bmbGCGh/mUH4+JjVocYBTgYlXh4A9etCxJiTSwrrsw9xCjBwawkwlt/
	HCjEm5JYWZValB9fVJqTWnyIkYmDU6qBUfr5KgvJtqNLVwaXLd716Bqv5S/dTRLrjq7aI2nC
	9vKKTvbET3+71Ns3Kz3sfieo+tN0eSZ34uuM00+0t+15k1X8OP/q4y+df4s+2Pk+iT0kojVv
	gfyfxPiu2G8dKW2K0SUbl8QyKs35rVK1PSicW3LPkswQmTmFu6fdmrwwYfPHLY92153dIa/E
	UpyRaKjFXFScCADyX9b3UwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, 2013-12-16 at 11:45 +0000, Mark Brown wrote:
> On Mon, Dec 16, 2013 at 08:08:34AM +0100, Krzysztof Kozlowski wrote:
> 
> > I sent a fix for this already on last Wednesday but I forgot to put you
> > on as recipient.
> > http://thread.gmane.org/gmane.linux.kernel/1612360
> > Fix is needed also for clock driver and on Saturday Rashika Kheria
> > posted similar patch.
> 
> I've now applied your patch (which fixes both regulator and clocks, the
> separate patch isn't needed).  The big question I have is how this
> managed to get into Linus' tree - why didn't this show up in -next?

Thanks for applying the patch. The commit introducing error was picked
up by Andrew to MM tree and lately got merged to Linus' tree:
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=8d2763770c34e8ed771f0be86760eb4485febc05

Best regards,
Krzysztof

