Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753369Ab3DSSZr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 14:25:47 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:60633 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752983Ab3DSSZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 14:25:46 -0400
Date: Fri, 19 Apr 2013 11:25:43 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org
Subject: Re: [char-misc-next 2/3] mei: fix reading large reposnes
Message-ID: <20130419182543.GA30807@kroah.com>
References: <1366395415-13031-1-git-send-email-tomas.winkler@intel.com>
 <1366395415-13031-2-git-send-email-tomas.winkler@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366395415-13031-2-git-send-email-tomas.winkler@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 19, 2013 at 09:16:54PM +0300, Tomas Winkler wrote:
> While writting to device is limitted to max_msg_length advertized
> in client properites the read can be much longer delivered consequiting chunks.
> 
> We use krealloc to enlarge the buffer when needed.
> 
> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>

Patch 1/3 had some fuzz in interrupt.c, so I fixed that up by hand, but
this one just fails to apply at all:
	checking file drivers/misc/mei/bus.c
	checking file drivers/misc/mei/client.c
	checking file drivers/misc/mei/client.h
	checking file drivers/misc/mei/interrupt.c
	Hunk #1 FAILED at 145.
	1 out of 1 hunk FAILED
	checking file drivers/misc/mei/main.c

So something is out of sync between us.

Care to refresh this patch based on my latest tree, and 3/3, and resend
them?

thanks,

greg k-h
