Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758540AbaJaQEB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 12:04:01 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41806 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758273AbaJaQD7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 12:03:59 -0400
Message-ID: <1414771442.24194.3.camel@linux-0dmf.site>
Subject: Re: [PATCH v4-real] cdc-acm: ensure that termios get set when the
 port is activated
From: Oliver Neukum <oneukum@suse.de>
To: Johan Hovold <johan@kernel.org>
Cc: Jim Paris <jim@jtan.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Hurley <peter@hurleysoftware.com>
Date: Fri, 31 Oct 2014 17:04:02 +0100
In-Reply-To: <20141031114542.GK13062@localhost>
References: <20141029150716.GG2265@localhost>
	 <1414596640-28555-1-git-send-email-johan@kernel.org>
	 <20141029155602.GC17399@kroah.com> <20141029155840.GJ2265@localhost>
	 <20141030005314.GA6049@psychosis.jim.sh> <20141030075127.GC13062@localhost>
	 <20141030144538.GA23737@psychosis.jim.sh>
	 <20141030144858.GG13062@localhost>
	 <20141030150446.GB23737@psychosis.jim.sh>
	 <20141031114542.GK13062@localhost>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-10-31 at 12:45 +0100, Johan Hovold wrote:
> On Thu, Oct 30, 2014 at 11:04:47AM -0400, Jim Paris wrote:
> > The driver wasn't properly configuring the hardware for the current
> > termios settings under all conditions.  Ensure that termios are
> > written to the device when the port is activated.
> > 
> > Signed-off-by: Jim Paris <jim@jtan.com>
> 
> Reviewed-by: Johan Hovold <johan@kernel.org>
Acked-by: Oliver Neukum <oneukum@suse.de>

