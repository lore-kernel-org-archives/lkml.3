Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759237AbaJaLsv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 07:48:51 -0400
Received: from mail-lb0-f170.google.com ([209.85.217.170]:45687 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757863AbaJaLsu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 07:48:50 -0400
Date: Fri, 31 Oct 2014 12:45:42 +0100
From: Johan Hovold <johan@kernel.org>
To: Jim Paris <jim@jtan.com>
Cc: Johan Hovold <johan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, Oliver Neukum <oliver@neukum.org>,
        linux-kernel@vger.kernel.org, Peter Hurley <peter@hurleysoftware.com>
Subject: Re: [PATCH v4-real] cdc-acm: ensure that termios get set when the
 port is activated
Message-ID: <20141031114542.GK13062@localhost>
References: <20141029150716.GG2265@localhost>
 <1414596640-28555-1-git-send-email-johan@kernel.org>
 <20141029155602.GC17399@kroah.com>
 <20141029155840.GJ2265@localhost>
 <20141030005314.GA6049@psychosis.jim.sh>
 <20141030075127.GC13062@localhost>
 <20141030144538.GA23737@psychosis.jim.sh>
 <20141030144858.GG13062@localhost>
 <20141030150446.GB23737@psychosis.jim.sh>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141030150446.GB23737@psychosis.jim.sh>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 30, 2014 at 11:04:47AM -0400, Jim Paris wrote:
> The driver wasn't properly configuring the hardware for the current
> termios settings under all conditions.  Ensure that termios are
> written to the device when the port is activated.
> 
> Signed-off-by: Jim Paris <jim@jtan.com>

Reviewed-by: Johan Hovold <johan@kernel.org>

> ---
> 
> Johan Hovold wrote:
> > On Thu, Oct 30, 2014 at 10:45:38AM -0400, Jim Paris wrote:
> > > Moved prototype.
> > 
> > You seem to have posted the old version again.
> 
> Doh.  Fixed.

Thanks,
Johan
