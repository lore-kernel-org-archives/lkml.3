Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758583Ab3FMTTS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 15:19:18 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37281 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751454Ab3FMTTR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 15:19:17 -0400
Date: Thu, 13 Jun 2013 12:19:54 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Jiri Slaby <jslaby@suse.cz>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org, lwn@lwn.net
Subject: Re: Linux 3.9.6
Message-ID: <20130613191954.GA14548@kroah.com>
References: <20130613175502.GA9768@kroah.com>
 <51BA193F.9040504@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51BA193F.9040504@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 13, 2013 at 09:10:55PM +0200, Jiri Slaby wrote:
> On 06/13/2013 07:55 PM, Greg KH wrote:
> > I'm announcing the release of the 3.9.6 kernel.
> 
> Greg,
> 
> did you forget to push? 3.0 and 3.4 appeared on the mirrors, unlike 3.9...

Ick, you are right, I forgot to push the git tree, which made the
generation of the larger linux tarballs to fail, but the patch files
should be on kernel.org already.  I've now pushed the git tree, and the
other files are being generated, so it should all be there in a few
minutes, thanks for letting me know.

greg k-h
