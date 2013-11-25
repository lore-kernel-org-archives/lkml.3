Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752787Ab3KYVYn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 16:24:43 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56582 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751083Ab3KYVYh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 16:24:37 -0500
Date: Mon, 25 Nov 2013 13:24:36 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH staging-next 0/4] fwserial changes for 3.14
Message-ID: <20131125212436.GA26290@kroah.com>
References: <1385143571-3571-1-git-send-email-peter@hurleysoftware.com>
 <20131125204336.GA646@kroah.com>
 <5293BA67.3010405@hurleysoftware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5293BA67.3010405@hurleysoftware.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 25, 2013 at 04:00:23PM -0500, Peter Hurley wrote:
> On 11/25/2013 03:43 PM, Greg Kroah-Hartman wrote:
> >On Fri, Nov 22, 2013 at 01:06:07PM -0500, Peter Hurley wrote:
> >>**This patchset requires 'Halve tty buffer memory consumption' patchset **
> >
> >Requires it to build or just work properly?
> >
> >I'm trying to figure out what tree to take this in, (tty-next or
> >staging-next).
> 
> To build.
> 
> The 'Halve tty buffer memory consumption' patchset exports new
> methods that allow the driver to configure the maximum memory
> consumption by the tty buffers.
> 
> This fwserial patchset uses that new interface to rely on tty
> buffers to provide adequate rx buffering, rather than add'l rx
> buffering being done by the driver.
> 
> By halving the buffer memory consumption, I don't feel so
> guilty about doubling the limit :)

Ok, thanks, I'll take it through my tty-next tree then.

greg k-h
