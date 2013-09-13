Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932166Ab3IMPry (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 11:47:54 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36355 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932110Ab3IMPrw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 11:47:52 -0400
Date: Fri, 13 Sep 2013 08:47:51 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Paul Chavent <Paul.Chavent@onera.fr>
Cc: linux-usb@vger.kernel.org, jhovold@gmail.com, fschaefer.oss@googlemail.com,
        jslaby@suse.cz, max@suse.de, giometti@enneenne.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] USB : serial : invoke dcd_change ldisc's handler.
Message-ID: <20130913154751.GB19736@kroah.com>
References: <1379086513-2434-1-git-send-email-paul.chavent@onera.fr>
 <1379086513-2434-3-git-send-email-paul.chavent@onera.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1379086513-2434-3-git-send-email-paul.chavent@onera.fr>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 13, 2013 at 05:35:12PM +0200, Paul Chavent wrote:
> Signed-off-by: Paul Chavent <paul.chavent@onera.fr>

Again, why?  I need a whole lot more information in here to be able to
accept this.

Yes, you provided much of this in the 0/3 message, but that doesn't end
up in the kernel.

Third time's a charm?

thanks,

greg k-h
