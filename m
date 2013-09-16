Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752954Ab3IPFHF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 01:07:05 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:62853 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752103Ab3IPFHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 01:07:03 -0400
Date: Sun, 15 Sep 2013 22:06:59 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Lennox Wu <lennox.wu@gmail.com>
Cc: linux-kernel@vger.kernel.org, liqin.linux@gmail.com,
        torvalds@linux-foundation.org
Subject: Re: [GIT PULL] S+core Architecture : fix bugs for compiling and
 support necessary functions
Message-ID: <20130916050659.GA26457@roeck-us.net>
References: <CAF0htA5QzKiodZyG-mE3mgMHHDkVDz=_D8oW3Gd03NEUrY67MA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAF0htA5QzKiodZyG-mE3mgMHHDkVDz=_D8oW3Gd03NEUrY67MA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 14, 2013 at 05:42:07PM +0800, Lennox Wu wrote:
> Hi Linus,
> Please pull these updates for S+core architecture. These updates include
> updating information of maintainers, fix some trivial errors, and add
> a necessary function for supporting ipv6.
> 
> The following changes since commit bdbdfdef5766c2a60185e946df242f1bc0d37c09
> 
> Merge tag 'hwmon-for-linus' of
> git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging
> (Fri Sep 13 10:58:41 2013 -0700)
> 
> on
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
> 
> 
> For you to fetch changes up to 969f99168b9dff2f6cc07cdf14255178d4397c4f
> 
> git@github.com:sctscore/official-linux.git tags/branch-linus-20130914
> 
> Best,
> Lennox Wu
> 
Your e-mail is not signed. You don't even have a pgp key as far as
I can see, at least not one associated with your e-mail address.
How do you expect anyone to establish your identity ?

In addition to that, the tag in your repository is not signed and
does not contain a summary of your changes. Your patches do not
have a Signed-off-by: tag. The pull message below appears to be
hand-edited and does not match an auto-generated pull request
(which should have given you a hint that the commit logs have
a problem).

You did not even copy Linus on this e-mail. Do you really think
he would even notice your pull request, much less apply it ?

Guenter

> -----------------------------------------------
> Summary these commits:
> 1. Fix some trivial errors for successfully compiling the latest
> version Linux kernel.
> 2. Provide necessary function for support IPV6.
> 3. Update the information of maintainers.
> ------------------------------------------------
> Lennox Wu (8):
> score : Update the information of Score maintainers
> score : Implement the function csum_ipv6_magic
> score : arch/score/kernel/entry.S: fix wrong instructions
> score : arch/score/kernel/process.c : fix some typos
> score : Modify the MAKEFILE of Score
> 
>  MAINTAINERS                       |    4 +-
>  arch/score/Kconfig                |    4 ++
>  arch/score/Makefile               |    4 +-
>  arch/score/include/asm/checksum.h |   93 ++++++++++++++++++++-----------------
>  arch/score/include/asm/io.h       |    1 -
>  arch/score/include/asm/pgalloc.h  |    2 +-
>  arch/score/kernel/entry.S         |    4 +-
>  arch/score/kernel/process.c       |    4 +-
>  8 files changed, 64 insertions(+), 52 deletions(-)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 
> 
