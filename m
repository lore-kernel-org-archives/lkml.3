Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758394AbaJ3IJo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 04:09:44 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60259 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758162AbaJ3IJm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 04:09:42 -0400
Message-ID: <1414651698.21660.2.camel@linux-0dmf.site>
Subject: Re: [PATCH] USB: cdc-acm: only raise DTR on transitions from B0
From: Oliver Neukum <oneukum@suse.de>
To: Johan Hovold <johan@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
        Jim Paris <jim@jtan.com>, linux-kernel@vger.kernel.org,
        Peter Hurley <peter@hurleysoftware.com>
In-Reply-To: <20141029155840.GJ2265@localhost>
References: <20141029150716.GG2265@localhost>
	 <1414596640-28555-1-git-send-email-johan@kernel.org>
	 <20141029155602.GC17399@kroah.com> <20141029155840.GJ2265@localhost>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 30 Oct 2014 07:48:18 +0100
Mime-Version: 1.0
X-Mailer: Evolution 3.10.4 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-10-29 at 16:58 +0100, Johan Hovold wrote:
> On Wed, Oct 29, 2014 at 11:56:02PM +0800, Greg Kroah-Hartman wrote:

> > This should go to older kernels as well, right?
> 
> Yes, if you want.
> 
> It's fixing handling of B0, but I doubt many people care (hence the
> missing stable tag). Note that set_termios is currently not called
> during open() (but Jim's patch will be relying on this one).

It may not hit many people, but whom it hits, it hits hard. It
should go into stable.

	Regards
		Oliver


