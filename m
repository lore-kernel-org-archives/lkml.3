Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757009AbaIWWA0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 18:00:26 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38317 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756965AbaIWWAV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 18:00:21 -0400
Date: Tue, 23 Sep 2014 14:58:31 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Frans Klaver <frans.klaver@xsens.com>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Subject: Re: [PATCH 0/2] Fix a division by zero
Message-ID: <20140923215831.GB651@kroah.com>
References: <1411502080-19769-1-git-send-email-frans.klaver@xsens.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411502080-19769-1-git-send-email-frans.klaver@xsens.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2014 at 09:54:38PM +0200, Frans Klaver wrote:
> Hi Greg,
> 
> Here's a couple of patches that fix a divison by zero in omap-serial.c. One's a
> cleanup, the other the actual fix.

So both would be needed to be backported to stable kernels?  Why not
just do the fix first, then the cleanup afterward, to make backporting
easier?

thanks,

greg k-h
