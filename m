Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753516Ab3KKLif (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 06:38:35 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:34745 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753139Ab3KKLi1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 06:38:27 -0500
Date: Mon, 11 Nov 2013 11:38:09 +0000
From: Matt Fleming <matt@console-pimps.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] EFI runtime mapping work for v3.14
Message-ID: <20131111113809.GF22636@console-pimps.org>
References: <20131108105719.GB2318@console-pimps.org>
 <20131111111754.GB15810@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131111111754.GB15810@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Nov, at 12:17:54PM, Ingo Molnar wrote:
> 
> * Matt Fleming <matt@console-pimps.org> wrote:
> 
> > Folks, could you queue up the following for the v3.14 merge window? It
> > would be good to get these patches into linux-next for a full release
> > cycle of testing. They pass all of my tests.
> > 
> > The following changes since commit 72548e836b0c4abbb652e791dee9c91203a9a4c6:
> > 
> >   x86/efi: Add EFI framebuffer earlyprintk support (2013-10-28 18:09:58 +0000)
> > 
> > are available in the git repository at:
> > 
> >   git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git tags/efi-next
> 
> Mind resending this in about a week or so? The merge window has just 
> started and we don't want to potentially destabilize -next with v3.14 
> problems.

Sure, no problem at all.

-- 
Matt Fleming, Intel Open Source Technology Center
