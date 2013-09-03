Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932306Ab3ICSEV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 14:04:21 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:34748 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757048Ab3ICSET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 14:04:19 -0400
Date: Tue, 3 Sep 2013 11:04:16 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Henrik Rydberg <rydberg@euromail.se>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HID: Correct the USB IDs for the new Macbook Air 6
Message-ID: <20130903180416.GB25985@core.coreip.homeip.net>
References: <1378042304-1400-1-git-send-email-rydberg@euromail.se>
 <alpine.LNX.2.00.1309021329510.3796@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1309021329510.3796@pobox.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 02, 2013 at 01:30:07PM +0200, Jiri Kosina wrote:
> On Sun, 1 Sep 2013, Henrik Rydberg wrote:
> 
> > A recent patch (9d9a04ee) added support for the new machine, but got
> > the sequence of USB ids wrong. Reports from both Ian and Linus T show
> > that the 0x0291 id is for ISO, not ANSI, which should have the missing
> > number 0x0290. This patchs moves the three numbers accordingly, fixing
> > the problem.
> > 
> > Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> > Reported-and-tested-by: Ian Munsie <darkstarsword@gmail.com>
> > Tested-by: Linus G Thiel <linus@hanssonlarsson.se>
> > Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
> > ---
> > Hi Jiri, Dmitry,
> > 
> > it looks like this change has been sufficiently tested now, in
> > addition to making perfect sense. Jiri, would you mind taking it, if
> > Dmitry approves?
> 
> Absolutely ... waiting for Dmitry's Ack.

And here it is:

Acked-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>

Thanks.

-- 
Dmitry
