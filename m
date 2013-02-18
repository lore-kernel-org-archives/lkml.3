Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932100Ab3BRK2w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 05:28:52 -0500
Received: from cantor2.suse.de ([195.135.220.15]:48716 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757302Ab3BRK2u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 05:28:50 -0500
Date: Mon, 18 Feb 2013 11:28:40 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        David Herrmann <dh.herrmann@googlemail.com>, linux-api@vger.kernel.org,
        linux-input@vger.kernel.org,
        RavindranathX Doddi <ravindranathx.doddi@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Marcel Holtmann <marcel@holtmann.org>
Subject: Re: uhid: broken interface: 32/64-bit compatibility
In-Reply-To: <20130215200526.GA15811@core.coreip.homeip.net>
Message-ID: <alpine.LNX.2.00.1302181121460.17024@pobox.suse.cz>
References: <20130215112911.68A98E0085@blue.fi.intel.com> <CANq1E4T1QzOUOwWPpV6_55hVTXzXF4baShxpYaM0HNAgF0ffAg@mail.gmail.com> <20130215120022.GA23694@x220> <20130215135141.1EFCEE0085@blue.fi.intel.com> <20130215200526.GA15811@core.coreip.homeip.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Feb 2013, Dmitry Torokhov wrote:

> > Here's my attempt to fix the issue.
> > 
> > Not sure if tricks with padding in a good idea. We can  just use __u64
> > instead of pointer, but it will require update of userspace to silence
> > cast warning and will cause warning if you will try to use updated
> > userspace with old kernel headers.
> > 
> > Any comments?
> 
> This does not fix anything really, we simply have to deal with compat
> interface.
> 
> Compiled but not tested.
> 
> Thanks.

Sorry for late response, I have been extremely busy doing some skiing :-)

Thanks a lot for fixing this embarassing bug, Dmitry. I have now applied 
the patch.

-- 
Jiri Kosina
SUSE Labs
