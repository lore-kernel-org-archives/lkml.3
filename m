Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755060AbaFXSDO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 14:03:14 -0400
Received: from mail-qa0-f54.google.com ([209.85.216.54]:56248 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753961AbaFXSDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 14:03:12 -0400
From: Paul Moore <paul@paul-moore.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        James Morris <james.l.morris@oracle.com>,
        "Serge E. Hallyn" <serge@hallyn.com>
Subject: Re: linux-next: the selinux tree needs cleaning up
Date: Tue, 24 Jun 2014 14:03:08 -0400
Message-ID: <32647147.KmAPzBrbMT@sifl>
User-Agent: KMail/4.13.2 (Linux/3.14.8-gentoo; KDE/4.13.2; x86_64; ; )
In-Reply-To: <1474416.aEfMv8Ny53@sifl>
References: <20140618084046.1bce12cc@canb.auug.org.au> <20140620085931.6427678d@canb.auug.org.au> <1474416.aEfMv8Ny53@sifl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, June 20, 2014 12:06:28 PM Paul Moore wrote:

{big snip}

> Stephen, assuming for a moment that I created a fresh branch, based against
> 3.15, and then added the SELinux patches for 3.16 (basically the few new
> patches that were in the ole #next branch) would that serve as a reasonable
> basis for a new SELinux #next branch?  Around the -rc5/6/7 timeframe I would
> send a pull request to James to pull from this next branch into the Linux
> Security branch for 3.17.  Once 3.16 is released, I would merge that into
> this new #next branch and continue with the next round of patches.
> 
> FYI, more or less, the above is the process we've settled upon for all of
> the trees that get accumulated into the Linux Security tree.

Hi Stephen,

Does the above work for you in linux-next?  I'd like to try and resolve this 
sooner rather than later and I imagine you feel the same ...

-- 
paul moore
www.paul-moore.com

