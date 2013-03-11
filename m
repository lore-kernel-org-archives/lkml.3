Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753889Ab3CKRM5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 13:12:57 -0400
Received: from mail-ia0-f172.google.com ([209.85.210.172]:51091 "EHLO
	mail-ia0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665Ab3CKRM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 13:12:56 -0400
Date: Mon, 11 Mar 2013 10:12:52 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Joe Perches <joe@perches.com>
Cc: Forest Bond <forest@alittletooquiet.net>,
        devel <devel@driverdev.osuosl.org>, linux-kernel@vger.kernel.org
Subject: Re: [PULL REQUEST staging-next] staging: vt6655: Whitespace cleanups
 only
Message-ID: <20130311171252.GA14810@kroah.com>
References: <1362089715.1928.22.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362089715.1928.22.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 28, 2013 at 02:15:15PM -0800, Joe Perches wrote:
> Just a nearly completely scripted pass to convert
> the vt6655 sources to something more kernel like.
> 
> It's too large to post, ~2.3Mb.
> 
> No lines added or removed.
> 
> git diff -w shows no differences.
> Compilation allyesconfig, allmodconfig shows no
> object/module differences.
> 
> ---
> 
> The following changes since commit 8b5628ab83b671f96ac9f174c1bd51c92589fc82:
> 
>   Merge tag 'virt' of git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc (2013-02-21 15:40:16 -0800)
> 
> are available in the git repository at:
> 
> 
>   git://repo.or.cz/linux-2.6/trivial-mods.git 20130228_vt6655

Sorry, I don't take git pulls for staging tree drivers, please send them
as patches.

greg k-h
