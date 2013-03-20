Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753238Ab3CTWwk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 18:52:40 -0400
Received: from mail.skyhub.de ([78.46.96.112]:57739 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752198Ab3CTWwg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 18:52:36 -0400
Date: Wed, 20 Mar 2013 23:52:31 +0100
From: Borislav Petkov <bp@alien8.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Joern Engel <joern@logfs.org>, linux-kernel@vger.kernel.org,
        Jeff Moyer <jmoyer@redhat.com>, Takashi Iwai <tiwai@suse.de>
Subject: Re: [PATCH 0/9] Add blockconsole version 1.1 (try 2)
Message-ID: <20130320225231.GG15471@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Joern Engel <joern@logfs.org>, linux-kernel@vger.kernel.org,
	Jeff Moyer <jmoyer@redhat.com>, Takashi Iwai <tiwai@suse.de>
References: <1362087602-8979-1-git-send-email-joern@logfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1362087602-8979-1-git-send-email-joern@logfs.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

On Thu, Feb 28, 2013 at 04:39:53PM -0500, Joern Engel wrote:
> Blockconsole is a console driver very roughly similar to netconsole.
> Instead of sending messages out via UDP, they are written to a block
> device.  Typically a USB stick is chosen, although in principle any
> block device will do.
> 
> In most cases blockconsole is useful where netconsole is not, i.e.
> single machines without network access or without an accessable
> netconsole capture server.  When using both blockconsole and
> netconsole, I have found netconsole to sometimes create a mess under
> high message load (sysrq-t, etc.) while blockconsole does not.
> 
> Most importantly, a number of bugs were identified and fixed that
> would have been unexplained machine reboots without blockconsole.
> 
> More highlights:
> * reasonably small and self-contained code,
> * some 100+ machine years of runtime,
> * nice tutorial with a 30-sec guide for the impatient.

any thoughts on this?

Blockconsole is very useful in certain situations and a bunch of people
are using it already and it would be nice if we could get it moving
towards upstream.

So I'd appreciate it if you could take a look and maybe even pick it up
if there are no serious issues with it.

Thanks a bunch.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
