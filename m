Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932318AbaGBTHL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 15:07:11 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:55226 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932209AbaGBTHJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 15:07:09 -0400
Date: Wed, 2 Jul 2014 23:07:06 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Christopher Covington <cov@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-api@vger.kernel.org, Michael Kerrisk <mtk.manpages@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrey Vagin <avagin@openvz.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Vladimir Davydov <vdavydov@parallels.com>,
        Linux ARM kernel mailing list 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [patch 3/4] timerfd: Implement timerfd_ioctl method to restore
 timerfd_ctx::ticks
Message-ID: <20140702190706.GH12440@moon>
References: <20140623185431.396309193@openvz.org>
 <53B4382F.9030908@codeaurora.org>
 <20140702170416.GG12440@moon>
 <4188254.Av1Z2pQssC@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4188254.Av1Z2pQssC@wuerfel>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 02, 2014 at 09:01:02PM +0200, Arnd Bergmann wrote:
> > > 
> > > 64-bit get_user is currently unsupported on ARM, although it appears work is
> > > ongoing [1].
> > > 
> > > 1. https://lkml.org/lkml/2014/6/17/260
> > 
> > Thanks for info, Christopher! What arm camp is using then, copy-from-user?
> > 
> 
> copy_from_user should work on all architectures. I believe a 64-bit get_user
> is currently unsupported on most 32-bit architectures, x86-32 being a notable
> exception.

Thanks, I'll update.
