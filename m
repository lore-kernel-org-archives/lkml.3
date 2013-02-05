Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756323Ab3BEQNG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 11:13:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6281 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756159Ab3BEQNC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 11:13:02 -0500
Date: Tue, 5 Feb 2013 10:40:26 -0500
From: Peter Jones <pjones@redhat.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Matt Fleming <matt.fleming@intel.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, akpm@linux-foundation.org,
        David Airlie <airlied@linux.ie>,
        Corentin Chary <corentincj@iksaif.net>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Dave Jiang <dave.jiang@intel.com>, Olof Johansson <olof@lixom.net>,
        Colin Ian King <colin.king@canonical.com>,
        Steve Langasek <steve.langasek@canonical.com>,
        Tony Luck <tony.luck@intel.com>,
        Konrad Rzeszutek Wilk <konrad@kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [ 105/128] efi: Make efi_enabled a function to query EFI
 facilities
Message-ID: <20130205154026.GA2335@fenchurch.internal.datastacks.com>
References: <20130203144653.313760856@decadent.org.uk>
 <1359904557.1822.2.camel@deadeye.wl.decadent.org.uk>
 <1359996265.7515.180.camel@mfleming-mobl1.ger.corp.intel.com>
 <1360035964.32217.9.camel@deadeye.wl.decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1360035964.32217.9.camel@deadeye.wl.decadent.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 05, 2013 at 03:46:04AM +0000, Ben Hutchings wrote:
> On Mon, 2013-02-04 at 16:44 +0000, Matt Fleming wrote:
> > On Sun, 2013-02-03 at 16:15 +0100, Ben Hutchings wrote:
> > > As you can see this needed quite a lot of work to backport, and I
> > > haven't been able to test it yet.  So I would particularly appreciate
> > > careful review of this.
> > 
> > Everything looks fine to me but I haven't actually booted with these
> > changes.
> 
> Thanks.  I've now tested this on a 64-bit EFI system myself:
> 
> x86_64 kernel build:
> - Boots successfully
> - x86_efi_facilities = 0x3f
> - efifb works
> - efivars can be loaded and creates /sys/firmware/efi/vars
> 
> i386 kernel build:
> - Boots as far as an initramfs shell, but the machine doesn't have an
> i386 installation to continue with
> - x86_efi_facilities = 0x21
> - efifb works
> - efivars can be loaded but does nothing
> 
> All of which I think is correct.

Yeah, if it's running 64-bit EFI, that looks correct.

-- 
        Peter
