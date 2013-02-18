Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753590Ab3BRSkk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 13:40:40 -0500
Received: from mail-da0-f41.google.com ([209.85.210.41]:43538 "EHLO
	mail-da0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751515Ab3BRSki (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 13:40:38 -0500
Date: Mon, 18 Feb 2013 10:40:35 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        David Herrmann <dh.herrmann@googlemail.com>, linux-api@vger.kernel.org,
        linux-input@vger.kernel.org,
        RavindranathX Doddi <ravindranathx.doddi@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Marcel Holtmann <marcel@holtmann.org>
Subject: Re: uhid: broken interface: 32/64-bit compatibility
Message-ID: <20130218184035.GB15167@core.coreip.homeip.net>
References: <20130215112911.68A98E0085@blue.fi.intel.com>
 <CANq1E4T1QzOUOwWPpV6_55hVTXzXF4baShxpYaM0HNAgF0ffAg@mail.gmail.com>
 <20130215120022.GA23694@x220>
 <20130215135141.1EFCEE0085@blue.fi.intel.com>
 <20130215200526.GA15811@core.coreip.homeip.net>
 <alpine.LNX.2.00.1302181121460.17024@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1302181121460.17024@pobox.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 18, 2013 at 11:28:40AM +0100, Jiri Kosina wrote:
> On Fri, 15 Feb 2013, Dmitry Torokhov wrote:
> 
> > > Here's my attempt to fix the issue.
> > > 
> > > Not sure if tricks with padding in a good idea. We can  just use __u64
> > > instead of pointer, but it will require update of userspace to silence
> > > cast warning and will cause warning if you will try to use updated
> > > userspace with old kernel headers.
> > > 
> > > Any comments?
> > 
> > This does not fix anything really, we simply have to deal with compat
> > interface.
> > 
> > Compiled but not tested.
> > 
> > Thanks.
> 
> Sorry for late response, I have been extremely busy doing some skiing :-)

Sounds good. At least someone has the right priorities ;)

-- 
Dmitry
