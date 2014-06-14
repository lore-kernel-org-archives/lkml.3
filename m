Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754905AbaFNRdn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2014 13:33:43 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:31665 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754749AbaFNRdl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2014 13:33:41 -0400
Date: Sat, 14 Jun 2014 19:32:58 +0200
From: Daniel Kiper <daniel.kiper@oracle.com>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        xen-devel@lists.xenproject.org, boris.ostrovsky@oracle.com,
        david.vrabel@citrix.com, hpa@zytor.com, jbeulich@suse.com,
        konrad.wilk@oracle.com, matt.fleming@intel.com, mingo@redhat.com,
        tglx@linutronix.de
Subject: Re: Why efi_set_rtc_mmss() is never used?
Message-ID: <20140614173258.GF3463@olila.local.net-space.pl>
References: <20140609110800.GJ15989@olila.local.net-space.pl>
 <20140609134635.26abc019@alan.etchedpixels.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140609134635.26abc019@alan.etchedpixels.co.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 09, 2014 at 01:46:35PM +0100, One Thousand Gnomes wrote:
> On Mon, 9 Jun 2014 13:08:00 +0200
> Daniel Kiper <daniel.kiper@oracle.com> wrote:
>
> > Hi,
> >
> > As I can see efi_set_rtc_mmss() is never used to set RTC.
> > Even on EFI platform mach_set_rtc_mmss() is called and does
> > that thing. Why it is done in that way? It is a bug or it was
> > done intentionally. Am I missing something?
>
> EFI services generally don't work properly. The less they are used the
> better. We can realistically only make an EFI call with the same
> parameters windows does under the same kind of circumstances because the
> firmware on many motherboards is complete sh*te.

Thanks. Sadly it makes sens.

Daniel
