Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754144Ab3K2RbV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 12:31:21 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:40745 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752239Ab3K2RbT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 12:31:19 -0500
Date: Fri, 29 Nov 2013 09:32:12 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
Subject: Re: tty/serial eating \n regression in 3.13-rc1
Message-ID: <20131129173212.GA5510@kroah.com>
References: <20131127181348.GA22723@obsidianresearch.com>
 <1385652419-4732-1-git-send-email-peter@hurleysoftware.com>
 <20131128174614.GB28055@obsidianresearch.com>
 <52988B11.3090300@hurleysoftware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52988B11.3090300@hurleysoftware.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 29, 2013 at 07:39:45AM -0500, Peter Hurley wrote:
> On 11/28/2013 12:46 PM, Jason Gunthorpe wrote:
> > On Thu, Nov 28, 2013 at 10:26:57AM -0500, Peter Hurley wrote:
> >
> >> Please test out the attached patch and let me know if that solves
> >> the login whitespace problem.
> >
> > Yes, it certainly does:
> > Tested-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
> >
> > My bisection search showed this should go into 3.12 stable and 3.13..
> 
> Greg,
> 
> Please let me know if you need me to resend the earlier patch with
> Jason's Tested-by and a proper Cc to stable.

That would be nice to have, thanks :)
