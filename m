Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754390AbaAWQvO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 11:51:14 -0500
Received: from mail.skyhub.de ([78.46.96.112]:42123 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752864AbaAWQvN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 11:51:13 -0500
Date: Thu, 23 Jan 2014 17:51:09 +0100
From: Borislav Petkov <bp@alien8.de>
To: Toshi Kani <toshi.kani@hp.com>
Cc: Matt Fleming <matt@console-pimps.org>,
        Linux EFI <linux-efi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 0/5] EFI memmap and other fixes, v3
Message-ID: <20140123165109.GA11190@pd.tnic>
References: <1390045698-16882-1-git-send-email-bp@alien8.de>
 <20140123090654.GA17297@console-pimps.org>
 <1390494619.1792.482.camel@misato.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1390494619.1792.482.camel@misato.fc.hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 23, 2014 at 09:30:19AM -0700, Toshi Kani wrote:
> Since this issue is quite serious on our systems (3.14 kernels won't
> boot up), I'd really appreciate if the fixes can be made into some
> 3.14-rc.  It can hit on any EFI systems with large memory.

That's why we have "efi=old_map" - so that you can use the old mapping
method which is a chicken bit for the new scheme.

And I told you privately already that you're better off merging Matt's
'next' branch than us exposing this to the world too early. So stop
pushing this when there are clearly other solutions for your case and be
patient!

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
