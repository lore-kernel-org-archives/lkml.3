Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932523Ab3DZI7y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 04:59:54 -0400
Received: from mail-da0-f47.google.com ([209.85.210.47]:38186 "EHLO
	mail-da0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759515Ab3DZI7w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 04:59:52 -0400
Date: Fri, 26 Apr 2013 01:59:49 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Joe Perches <joe@perches.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Matthew Dharm <mdharm-usb@one-eyed-alien.net>,
        linux-usb <linux-usb@vger.kernel.org>,
        usb-storage <usb-storage@lists.one-eyed-alien.net>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2] usb: storage: Convert US_DEBUGP to usb_stor_dbg
In-Reply-To: <20130425153209.5b590422dbd249a5e19ac570@linux-foundation.org>
Message-ID: <alpine.DEB.2.02.1304260159310.21727@chino.kir.corp.google.com>
References: <Pine.LNX.4.44L0.1304171426460.1623-100000@iolanthe.rowland.org> <1366254055.28609.61.camel@joe-AO722> <20130419173503.GA27495@kroah.com> <1366397040.3901.45.camel@joe-AO722> <alpine.DEB.2.02.1304221234270.16385@chino.kir.corp.google.com>
 <20130425153209.5b590422dbd249a5e19ac570@linux-foundation.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Apr 2013, Andrew Morton wrote:

> From: Andrew Morton <akpm@linux-foundation.org>
> Subject: drivers/usb/storage/realtek_cr.c: fix build
> 
> Remove unused local `us', which broke the build.  Also nuke an unneeded
> cast.
> 
> Repairs 191648d03d20 ("usb: storage: Convert US_DEBUGP to usb_stor_dbg").
> 
> Cc: Joe Perches <joe@perches.com>
> Cc: David Rientjes <rientjes@google.com>
> Cc: Greg KH <greg@kroah.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Acked-by: David Rientjes <rientjes@google.com>

Fixes it for me, thanks Andrew.
