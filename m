Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752421AbaDELXL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Apr 2014 07:23:11 -0400
Received: from smtp-good-out-1.t-2.net ([84.255.208.43]:53735 "EHLO
	smtp-good-out-1.t-2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752032AbaDELXJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Apr 2014 07:23:09 -0400
X-Greylist: delayed 410 seconds by postgrey-1.27 at vger.kernel.org; Sat, 05 Apr 2014 07:23:09 EDT
Subject: Re: [PATCH 2/2] ttyprintk: Allow built as a module
From: Samo =?UTF-8?Q?Poga=C4=8Dnik?= <samo_pogacnik@t-2.net>
To: Takashi Iwai <tiwai@suse.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Arnd Bergmann <arnd@arndb.de>,
        Jean Delvare <jdelvare@suse.de>,
        Struan Bartlett <struan.bartlett@gmail.com>,
        Andreas Schwab <schwab@linux-m68k.org>, gnomes@lxorguk.ukuu.org.uk,
        linux-kernel@vger.kernel.org
In-Reply-To: <s5ha9c3djol.wl%tiwai@suse.de>
References: <1396434582-30799-1-git-send-email-tiwai@suse.de>
	 <1396434582-30799-2-git-send-email-tiwai@suse.de>
	 <20140402193222.GA26425@kroah.com>  <s5ha9c3djol.wl%tiwai@suse.de>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 05 Apr 2014 13:15:34 +0200
Message-ID: <1396696534.11212.32.camel@lapuh>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne 03.04.2014 (čet) ob 08:13 +0200 je Takashi Iwai napisal(a):
> At Wed, 2 Apr 2014 12:32:22 -0700,
> Greg Kroah-Hartman wrote:
> > 
> > On Wed, Apr 02, 2014 at 12:29:42PM +0200, Takashi Iwai wrote:
> > > The driver is well written to be used as a module, just the exit call
> > > is missing.
> > > 
> > > Signed-off-by: Takashi Iwai <tiwai@suse.de>
> > > ---
> > >  drivers/char/Kconfig     |  2 +-
> > >  drivers/char/ttyprintk.c | 13 ++++++++++++-
> > >  2 files changed, 13 insertions(+), 2 deletions(-)
> > 
> > There was some reason we didn't do this back when the code was accepted,
> > but I really can't remember why.
> > 
> > If you have tested this out, I don't have any objections to taking these
> > patches, thanks.
> 
> The module worked fine with my quick tests (load/unload/feed something
> via /dev/ttyprintk), at least.  But it'd be helpful if anyone
> remembers and clarifies.
> 
My initial requirement was to be able to use this functionality as soon
as possible at the beginning of user-space initialisation, so i never
thought of the ttyprintk code being loaded afterwards as module. Also
nobody brought modularisation subject to the table during code
acceptance.

> 
> thanks,
> 
> Takashi

regards, Samo

