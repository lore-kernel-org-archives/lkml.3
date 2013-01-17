Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756156Ab3AQT73 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 14:59:29 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:60405 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755114Ab3AQT72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 14:59:28 -0500
Date: Thu, 17 Jan 2013 11:59:23 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Sedat Dilek <sedat.dilek@gmail.com>
Cc: Tomas Winkler <tomas.winkler@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: mei: Fix typo "@hader" in mei_write_message()
Message-ID: <20130117195923.GA12747@kroah.com>
References: <1357634896-9944-1-git-send-email-sedat.dilek@gmail.com>
 <20130117181720.GA12352@kroah.com>
 <CA+icZUUdZHSa5OLfPUbxw2MVqG5LvV=dPrprQBciWPCUeNRO_w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+icZUUdZHSa5OLfPUbxw2MVqG5LvV=dPrprQBciWPCUeNRO_w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 17, 2013 at 07:51:09PM +0100, Sedat Dilek wrote:
> On Thu, Jan 17, 2013 at 7:17 PM, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> > On Tue, Jan 08, 2013 at 09:48:16AM +0100, Sedat Dilek wrote:
> >> This was introduced by:
> >>
> >> commit 438763f37eb9664b6372bdfee990f8c33acdc63c
> >> "mei: drop redundant length parameter from mei_write_message function"
> >>
> >> First seen in linux-next (next-20120108).
> >>
> >> Signed-off-by: Sedat Dilek <sedat.dilek@gmail.com>
> >> Acked-by: Tomas Winkler <tomas.winkler@intel.com>
> >> ---
> >>  drivers/misc/mei/interface.c |    2 +-
> >>  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > This patch no longer applies to my tree, can you please redo it against
> > the latest char-misc.next branch?
> >
> 
> I have sent an updated version (see [1]).
> Looks like I sent that to Thomas and LKML.
> Shall I resend it to you?

It looks like you just did, I'll take that one.

thanks,

greg k-h
