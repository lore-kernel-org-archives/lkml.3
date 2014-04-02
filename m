Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757443AbaDBCrL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 22:47:11 -0400
Received: from imap.thunk.org ([74.207.234.97]:48800 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751391AbaDBCrJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 22:47:09 -0400
Date: Tue, 1 Apr 2014 22:46:33 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Andrew Stephenson <aste9@icloud.com>
Cc: David Lang <david@lang.hm>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Replacing GNU
Message-ID: <20140402024633.GB29944@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Andrew Stephenson <aste9@icloud.com>, David Lang <david@lang.hm>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <2A318645-52BD-4650-BDEF-11F6215AA621@icloud.com>
 <alpine.DEB.2.02.1404011744300.14073@nftneq.ynat.uz>
 <7E28311F-2408-4713-82DE-F9708AEAF855@icloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7E28311F-2408-4713-82DE-F9708AEAF855@icloud.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 02, 2014 at 01:03:13PM +1100, Andrew Stephenson wrote:
> Ah, so there is a Free Software camp and an Open Source camp within
> the Linux Kernel Mailing List.

There is a strong consensus that the Linux kernel should remain GPLv2,
and many senior kernel developers (including Linus) have an extremely
strong dislike of the GPLv3's anti-Tivo clauses.  I suspect many of us
regret that license incompatibilities caused by some code being
licensed under GPLv2 only, and some code being licensed under GPLv3,
but that's an issue that you need to talk to the FSF about.

As far as the kernel is concerned, it doesn't use the gcc runtime
library, so issues about GPLv3 are simply simply not a major concern
for most linux kernel developers.

Questions about what the implications are of GPLv3 licensed code in
userspace really are out of scope of the LKML mailing list.  If you
care about such things, I suggest you talk to your lawyers.

Cheers,

						- Ted
