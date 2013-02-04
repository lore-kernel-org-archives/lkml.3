Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755322Ab3BDS1C (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 13:27:02 -0500
Received: from mail.kernel.org ([198.145.19.201]:45986 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754827Ab3BDS07 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 13:26:59 -0500
Date: Mon, 4 Feb 2013 10:20:09 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Matt Fleming <matt.fleming@intel.com>
Cc: Ben Hutchings <ben@decadent.org.uk>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, akpm@linux-foundation.org,
        David Airlie <airlied@linux.ie>,
        Corentin Chary <corentincj@iksaif.net>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Dave Jiang <dave.jiang@intel.com>, Olof Johansson <olof@lixom.net>,
        Peter Jones <pjones@redhat.com>,
        Colin Ian King <colin.king@canonical.com>,
        Steve Langasek <steve.langasek@canonical.com>,
        Tony Luck <tony.luck@intel.com>,
        Konrad Rzeszutek Wilk <konrad@kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [ 105/128] efi: Make efi_enabled a function to query EFI
 facilities
Message-ID: <20130204182009.GA3219@kroah.com>
References: <20130203144653.313760856@decadent.org.uk>
 <1359904557.1822.2.camel@deadeye.wl.decadent.org.uk>
 <1359996265.7515.180.camel@mfleming-mobl1.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359996265.7515.180.camel@mfleming-mobl1.ger.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 04, 2013 at 04:44:25PM +0000, Matt Fleming wrote:
> On Sun, 2013-02-03 at 16:15 +0100, Ben Hutchings wrote:
> > As you can see this needed quite a lot of work to backport, and I
> > haven't been able to test it yet.  So I would particularly appreciate
> > careful review of this.
> 
> Everything looks fine to me but I haven't actually booted with these
> changes.

I didn't backport this to the 3.4 kernel, as I didn't think it really
was necessary, but now that Ben did all of the hard work, I'll see if
his version applies there, as it would be good to solve this issue for
that kernel release.  Thanks for verifying that this work at least looks
sane.

greg k-h
