Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753086Ab3KNLYr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 06:24:47 -0500
Received: from mail.skyhub.de ([78.46.96.112]:37651 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752323Ab3KNLYp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 06:24:45 -0500
Date: Thu, 14 Nov 2013 12:24:18 +0100
From: Borislav Petkov <bp@alien8.de>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Borislav Petkov <bp@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Doug Thompson <dougthompson@xmission.com>,
        Johannes Thumshirn <johannes.thumshirn@men.de>,
        Robert Richter <rric@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-edac@vger.kernel.org,
        Aristeu Rozanski Filho <arozansk@redhat.com>
Subject: Re: [GIT PULL] mpc85xx_edac changes for 3.13
Message-ID: <20131114112418.GH4960@pd.tnic>
References: <20131112161901.GA15637@jtlinux>
 <CA+55aFzJhyo8bKBchYq0Q=rwPv_-v-xWgOKWxKBcSBycMZcmTg@mail.gmail.com>
 <20131114054750.GA27791@kroah.com>
 <20131114092009.GA4960@pd.tnic>
 <20131114091843.4bb72afc@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20131114091843.4bb72afc@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 14, 2013 at 09:18:43AM -0200, Mauro Carvalho Chehab wrote:
> So, in practice, Borislav was working as a maintainer for amd64 EDAC
> patches, and I working mainly as Intel EDAC maintainer. The (few)
> other arm EDAC patches were either coming via my tree or via Boris
> tree, depending on who got them first.

Yeah, and I think this has worked pretty good in the past so if you want
to, we can continue the same thing of sharing the load on EDAC patches
and we both do interim maintainers until Doug steps in.

And since it won't change any workflow for Linus, he's probably fine
with it too.

Yes, no? Comments?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
