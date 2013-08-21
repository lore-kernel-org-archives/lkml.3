Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751984Ab3HURIb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 13:08:31 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52540 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751519Ab3HURIa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 13:08:30 -0400
Date: Wed, 21 Aug 2013 10:08:28 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>, lwn@lwn.net,
        Guenter Roeck <linux@roeck-us.net>, Hugh Dickins <hughd@google.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Proposed stable release changes
Message-ID: <20130821170828.GA14784@kroah.com>
References: <20130820224032.GA20491@kroah.com>
 <20130821134852.GA4562@nazgul.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130821134852.GA4562@nazgul.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 21, 2013 at 03:48:52PM +0200, Borislav Petkov wrote:
> On Tue, Aug 20, 2013 at 03:40:32PM -0700, Greg KH wrote:
> > - I will wait for a -rc to come out with the patch in it before putting
> >   it into a stable release, unless:
> 
> Question: what's the exact reasoning of that delay? To get more people
> who install -rc kernels to smoke-test patches tagged for stable.

Yes.

> What happens if the bug gets detected *after* you've taken the patch? We
> probably end up in the same situation.

Yes we will, but this does give us a bit more testing, right?  That's
the point of the delay.

thanks,

greg k-h
