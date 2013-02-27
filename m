Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759834Ab3B0Mnl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 07:43:41 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:48809 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753583Ab3B0Mnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 07:43:40 -0500
Date: Wed, 27 Feb 2013 12:43:30 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Peter Jones <pjones@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        David Howells <dhowells@redhat.com>, Florian Weimer <fw@deneb.enyo.de>,
        Josh Boyer <jwboyer@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
        Kees Cook <keescook@chromium.org>, keyrings@linux-nfs.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Load keys from signed PE binaries
Message-ID: <20130227124330.GA2905@srcf.ucam.org>
References: <20130226033156.GA24999@kroah.com>
 <20130226033803.GA30285@srcf.ucam.org>
 <20130226035416.GA1128@kroah.com>
 <20130226040456.GA30717@srcf.ucam.org>
 <20130226041324.GA7241@kroah.com>
 <20130226042338.GA30944@srcf.ucam.org>
 <CA+55aFx9HkRGfMx6pfR2xsTf0vof_yyrT4ks5TzMKoEpS7w=5g@mail.gmail.com>
 <CAMuHMdV4DbX_i6Ye5v7ObR0no-eDhBzqYrsqVtR5PAXQTVSmVQ@mail.gmail.com>
 <20130226220618.GK32160@fenchurch.internal.datastacks.com>
 <CAMuHMdUQxX+3kSN+UorapS5a3kZaNrBpY1Nch8nLniMU-w9-DA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdUQxX+3kSN+UorapS5a3kZaNrBpY1Nch8nLniMU-w9-DA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 27, 2013 at 01:32:30PM +0100, Geert Uytterhoeven wrote:

> So revocation will only be done by the guest OS?
> I.e. if I only boot my own trusted Linux, even if it's signed with the MS key,
> the MS key _on my system_ will never be revoked?

As long as you never apply any updates that will revoke that key.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
