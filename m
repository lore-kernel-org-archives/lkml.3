Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756189Ab3GKQ7Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 12:59:25 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38660 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755538Ab3GKQ7X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 12:59:23 -0400
Date: Thu, 11 Jul 2013 09:59:22 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Oliver Schinagl <oliver+list@schinagl.nl>
Cc: linux-kernel@vger.kernel.org, linux@roeck-us.net, khali@linux-fr.org
Subject: Re: [PATCH v2 5/7] sysfs: add support for binary attributes in groups
Message-ID: <20130711165922.GB23056@kroah.com>
References: <1373486714-14531-1-git-send-email-gregkh@linuxfoundation.org>
 <1373502965-1683-1-git-send-email-gregkh@linuxfoundation.org>
 <1373502965-1683-6-git-send-email-gregkh@linuxfoundation.org>
 <51DE9AF1.90105@schinagl.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51DE9AF1.90105@schinagl.nl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 11, 2013 at 01:45:53PM +0200, Oliver Schinagl wrote:
> On 11-07-13 02:36, Greg Kroah-Hartman wrote:
> >groups should be able to support binary attributes, just like it
> >supports "normal" attributes.  This lets us only handle one type of
> >structure, groups, throughout the driver core and subsystems, making
> >binary attributes a "full fledged" part of the driver model, and not
> >something just "tacked on".
> However when only using binary attributes it warns and doesn't
> create anything. The attached patch fixes that.

Ah, missed that, I didn't have a binary-only attribute group to test
that out, thanks.

> >Reported-by: Oliver Schinagl <oliver+list@schinagl.nl>
> If I may be so bold and ask to change my e-mail address to
> <oliver@schinagl.nl> that would be kind. I use the +list delimiter
> to put all the mailing list mails in a separate mailbox.

Sure, no problem at all, will do so.  And I'll queue up your attached
patch as well, it looks great.

greg k-h
