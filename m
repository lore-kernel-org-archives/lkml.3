Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753689Ab3ISXwS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 19:52:18 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:35445 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752696Ab3ISXwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 19:52:16 -0400
Date: Thu, 19 Sep 2013 14:00:37 -0700
From: Simon Horman <horms@verge.net.au>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        linux-m68k <linux-m68k@vger.kernel.org>, kexec@lists.infradead.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Preliminary kexec support for Linux/m68k
Message-ID: <20130919210037.GG2918@verge.net.au>
References: <1379412095-7213-1-git-send-email-geert@linux-m68k.org>
 <CAMuHMdW8y9_=LXQ1PXjFaPyq-nYTPe+FodE5hQh4P3QSdnP_dg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdW8y9_=LXQ1PXjFaPyq-nYTPe+FodE5hQh4P3QSdnP_dg@mail.gmail.com>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 19, 2013 at 11:20:22AM +0200, Geert Uytterhoeven wrote:
> On Tue, Sep 17, 2013 at 12:01 PM, Geert Uytterhoeven
> <geert@linux-m68k.org> wrote:
> > This is a preliminary set of patches to add kexec support for m68k.
> 
> >   - [PATCH 1/3] m68k: Add preliminary kexec support
> >   - [PATCH 2/3] m68k: Add support to export bootinfo in procfs
> >   - [PATCH 3/3] [RFC] m68k: Add System RAM to /proc/iomem
> >
> > Notes:
> >   - The bootinfo is now saved and exported to /proc/bootinfo, so kexec-tools
> >     can read it and pass it (possibly after modification) to the new kernel.
> >     This is similar to /proc/atags on ARM.
> 
> >   - I based [PATCH 3/3] on the PowerPC version, but it's no longer needed as we
> >     now get this information from the bootinfo.
> >     Does anyone think this is nice to have anyway?
> 
> It seems kexec/kdump on ppc don't use /proc/iomem anymore, and only rely on
> /proc/device-tree these days?

I think thats entirely a matter for the m68k kernel maintainers to decide.
But my personal opinion is that it is nice not to add it if it isn't needed.
