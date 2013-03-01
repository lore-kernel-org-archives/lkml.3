Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751624Ab3CAP6b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 10:58:31 -0500
Received: from mail.skyhub.de ([78.46.96.112]:52917 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750983Ab3CAP6a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 10:58:30 -0500
Date: Fri, 1 Mar 2013 16:58:20 +0100
From: Borislav Petkov <bp@alien8.de>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Joern Engel <joern@logfs.org>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 3/9] printk: add CON_ALLDATA console flag
Message-ID: <20130301155820.GE30938@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Jeff Moyer <jmoyer@redhat.com>, Joern Engel <joern@logfs.org>,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
References: <1362087602-8979-1-git-send-email-joern@logfs.org>
 <1362087602-8979-4-git-send-email-joern@logfs.org>
 <x49obf32mvo.fsf@segfault.boston.devel.redhat.com>
 <20130301145805.GC30938@pd.tnic>
 <x49fw0f2m5r.fsf@segfault.boston.devel.redhat.com>
 <20130301153100.GD30938@pd.tnic>
 <x49621b2kkn.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <x49621b2kkn.fsf@segfault.boston.devel.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 01, 2013 at 10:42:16AM -0500, Jeff Moyer wrote:
> I don't think you've provided a very strong case for ignoring the

Maybe you should've looked at the 5/9 commit message - there's your
strong case.

> administrator's configuration settings.  I'm against the patches that
> introduce this behaviour, for whatever that's worth (2 cents is the
> going rate, I think).

I'm fine with netconsole retaining old behavior since people reportedly
use it not only as a debugging console.

blockconsole, OTOH, is purely a debugging console and has to log
*everything* *out-of-the-box* once the block device is plugged in. No
configuration, no user intervention, no admin fiddling with whatever.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
