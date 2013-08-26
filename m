Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756778Ab3HZMDE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 08:03:04 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53791 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751632Ab3HZMDC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 08:03:02 -0400
Date: Mon, 26 Aug 2013 05:05:17 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 12/15] HID: convert bus code to use dev_groups
Message-ID: <20130826120517.GA31240@kroah.com>
References: <1377293081-10957-1-git-send-email-gregkh@linuxfoundation.org>
 <1377293081-10957-12-git-send-email-gregkh@linuxfoundation.org>
 <alpine.LNX.2.00.1308261341550.2077@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1308261341550.2077@pobox.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 26, 2013 at 01:42:03PM +0200, Jiri Kosina wrote:
> On Fri, 23 Aug 2013, Greg Kroah-Hartman wrote:
> 
> > The dev_attrs field of struct bus_type is going away soon, dev_groups
> > should be used instead.  This converts the HID bus code to use
> > the correct field.
> > 
> > Cc: Jiri Kosina <jkosina@suse.cz>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> Acked-by: Jiri Kosina <jkosina@suse.cz>

Thanks, I'll take this through my driver-core tree.

greg k-h
