Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756235Ab3ANPLc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 10:11:32 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:54227 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751916Ab3ANPLb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 10:11:31 -0500
Date: Mon, 14 Jan 2013 07:12:20 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Sedat Dilek <sedat.dilek@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Tomas Winkler <tomas.winkler@intel.com>, arnd@arndb.de,
        alan@linux.intel.com, linux-kernel@vger.kernel.org
Subject: Re: [char-misc-next V2] mei: drop the warning when cl is not
 initialized during unlinking
Message-ID: <20130114151220.GA20610@kroah.com>
References: <1357831934-31610-1-git-send-email-tomas.winkler@intel.com>
 <CA+icZUXa-cgNPTYAKjXDSkoqNhto7jz89yUMJAvYxa-jGtMbjg@mail.gmail.com>
 <20130114143238.GC20384@kroah.com>
 <CA+icZUXLFp_oZnVPcVDwuy_dvbywKgqHKknzg6qyF3o=mw-p+A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+icZUXLFp_oZnVPcVDwuy_dvbywKgqHKknzg6qyF3o=mw-p+A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 14, 2013 at 03:55:44PM +0100, Sedat Dilek wrote:
> On Mon, Jan 14, 2013 at 3:32 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> > On Mon, Jan 14, 2013 at 03:14:50PM +0100, Sedat Dilek wrote:
> >> On Thu, Jan 10, 2013 at 4:32 PM, Tomas Winkler <tomas.winkler@intel.com> wrote:
> >>
> >> Can you please apply this patch to char-misc-next?
> >> I am hitting it again while doing other regression testing!
> >
> > Please be patient, it will get there soon.
> >
> 
> The same answer I got for the report/testing of [1], it is still not
> in mainline.
> Yes, I have seen your pull-request for char-misc-linus of today, but
> why does this takes weeks to apply?

"Weeks"?  You do realize this was sent to me over a holliday break, one
in which I was on vacation?  I only returned a week ago, to over 1500
patches to sift through and process.

And, I did that within 4 days, and sent the needed fix off to Linus
within 7 days of returning.

If you think you can do better than that, wonderful, I would love for
you to start out reviewing code and helping with handling stuff like
that.  Please do so before complaining about anything.

greg k-h
