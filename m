Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751347AbaEXUnG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2014 16:43:06 -0400
Received: from mail-lb0-f181.google.com ([209.85.217.181]:41405 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228AbaEXUnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2014 16:43:04 -0400
Date: Sat, 24 May 2014 22:42:35 +0200
From: Johan Hovold <jhovold@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Johan Hovold <jhovold@gmail.com>, Jiri Slaby <jslaby@suse.cz>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Peter Hurley <peter@hurleysoftware.com>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Xiao Jin <jin.xiao@intel.com>, david.a.cohen@linux.intel.com,
        yanmin.zhang@intel.com, Oliver Neukum <oneukum@suse.de>
Subject: Re: [PATCH] USB: cdc-acm: fix broken runtime suspend
Message-ID: <20140524204235.GA24047@localhost>
References: <20140411093715.GA17522@localhost>
 <1397505492-10018-1-git-send-email-jhovold@gmail.com>
 <20140524144242.GC10266@localhost>
 <20140524195907.GB922@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140524195907.GB922@kroah.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 24, 2014 at 12:59:07PM -0700, Greg Kroah-Hartman wrote:
> On Sat, May 24, 2014 at 04:42:42PM +0200, Johan Hovold wrote:

> > Could you please discard this one for now? I've found a couple of more
> > PM related problems and I'll submit a slight update of this one as part
> > of a larger series of fixes instead.
> 
> I think it's already in my tree, right?  I don't see it in my to-apply
> queue.  Can you send me the git id to revert, or just a patch that
> reverts it?

No, you haven't applied it yet, so that's good. I should be able to send
the complete series in a few days.

Thanks,
Johan
