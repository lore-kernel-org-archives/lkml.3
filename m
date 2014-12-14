Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750894AbaLNSZZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 13:25:25 -0500
Received: from mail.skyhub.de ([78.46.96.112]:54379 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750702AbaLNSZV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 13:25:21 -0500
Date: Sun, 14 Dec 2014 19:25:18 +0100
From: Borislav Petkov <bp@alien8.de>
To: Richard Farthing <rfarthing@iee.org>
Cc: linux-kernel@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>
Subject: Re: Kernel boot panic 3.12-34 > 3.12.35
Message-ID: <20141214182518.GA607@pd.tnic>
References: <548DAFA0.1090700@iee.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <548DAFA0.1090700@iee.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 14, 2014 at 03:41:20PM +0000, Richard Farthing wrote:
> I patched 3.12.34 to 3.12.35 and the attached now happens at boot.
> Sorry I don't have better than a photo, cannot get past this.
> 
> The root FS is EXT2.  It's admittedly an old test machine that I'm using to
> build up a new configuration, so the  BIOS is a bit old, but it's at least
> dual core, not totally ancient.
> 
> Let me know if you need more diagnostic

That happens very early and the first oops which is the most
relevant one is cut off and one cannot see what the bug actually is,
unfortunately.

Can you catch dmesg of that boot over serial or netconsole or so? Ask if
you don't know how.

You could send your .config, maybe it is reproducible in kvm. Also, can
you send a full dmesg of the successful boot with 3.12.34?

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
