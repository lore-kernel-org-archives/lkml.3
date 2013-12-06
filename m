Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757198Ab3LFMae (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 07:30:34 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:57797 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752420Ab3LFMad (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 07:30:33 -0500
Date: Fri, 6 Dec 2013 12:30:26 +0000
From: Matt Fleming <matt@console-pimps.org>
To: Joe Perches <joe@perches.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>,
        Prarit Bhargava <prarit@redhat.com>, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 1/3] Introduce FW_INFO* functions and messages
Message-ID: <20131206123026.GB3597@console-pimps.org>
References: <1385997579-22240-1-git-send-email-prarit@redhat.com>
 <1385997579-22240-2-git-send-email-prarit@redhat.com>
 <20131203132120.6a7ab2cd7cc99720712cbe6a@linux-foundation.org>
 <201312041922.59181.arnd@arndb.de>
 <20131205113016.GB3823@console-pimps.org>
 <1386258903.10003.8.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386258903.10003.8.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 05 Dec, at 07:55:03AM, Joe Perches wrote:
> On Thu, 2013-12-05 at 11:30 +0000, Matt Fleming wrote:
> > On Wed, 04 Dec, at 07:22:57PM, Arnd Bergmann wrote:
> > > The other part I noticed about this particular patchset is that it's
> > > not really "firmware" as such, but specifically PC wiht ACPI that
> > > gets covered here. So rather than generalizing the code, another
> > > option would be to narrow down the scope and make it
> > > acpi_{warn,info,dbg} instead.
> > 
> > Making this specific to ACPI runs the risk of people introducing a
> > multitude of new logging functions for every subsystem, e.g.
> > efi_{warn,info,dbg}.
> 
> There are many subsystem specific logging functions:

Surely that's further justification to not introduce any more.

> > FWIW, I'd be interested in using something like this patch series to
> > properly log EFI implementation bugs. The logging for EFI is currently
> > done fairly haphazardly.
> 
> I thought that was the point of embedding the existing
> FW_INFO, FW_WARN and FW_BUG #defines in formats.
> 
> Using logging message scraping to find faults is not
> a great approach as message content is subject to change.

I wasn't planning on using them to scrape the kernel logs, just for more
informative messages.

-- 
Matt Fleming, Intel Open Source Technology Center
