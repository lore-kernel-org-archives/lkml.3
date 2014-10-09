Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757466AbaJIPsZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 11:48:25 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60518 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752189AbaJIPsR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 11:48:17 -0400
Date: Thu, 9 Oct 2014 08:48:16 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Nitin Kuppelur <nitinkuppelur@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3] Staging: rtl8712 removed unnecessary else after return
Message-ID: <20141009154816.GA27912@kroah.com>
References: <20141002084745.GF23154@mwanda>
 <1412253146-3568-1-git-send-email-nitinkuppelur@gmail.com>
 <20141008224414.GA25262@kroah.com>
 <CAJTjWg8QuvrdwD9rrHYW25LbJ6aq7ttyih1sxGkZEvtoBA8Ntg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJTjWg8QuvrdwD9rrHYW25LbJ6aq7ttyih1sxGkZEvtoBA8Ntg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


A: No.
Q: Should I include quotations after my reply?

http://daringfireball.net/2007/07/on_top


On Thu, Oct 09, 2014 at 09:00:58PM +0530, Nitin Kuppelur wrote:
> Hi Greg,
> 
> Sorry for noob question. I am still new to Kernel development.
> 
> I understood from your comment that the patch did not apply cleanly to
> your tree (may be due to change in the code which I have modified)

Or due to changes that others made and got accepted.

> But what should I do after this?
> 1) Send patch on rebased file to same mail chain with (--in-reply-to)
> and [PATCH V4] ? OR
> 2) Create new PATCH and start new mail chain done on latest code.

Create a new patch and new email thread please.

thanks,

greg k-h
