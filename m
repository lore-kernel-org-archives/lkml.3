Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756469Ab3CZXAy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 19:00:54 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:45692 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756336Ab3CZXAx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 19:00:53 -0400
Date: Tue, 26 Mar 2013 16:00:50 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: "Winkler, Tomas" <tomas.winkler@intel.com>
Cc: "arnd@arndb.de" <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [char-misc-next 2/2] mei: drop RECOVERING_FROM_RESET device state
Message-ID: <20130326230050.GA25071@kroah.com>
References: <1363513281-12606-1-git-send-email-tomas.winkler@intel.com>
 <1363513281-12606-2-git-send-email-tomas.winkler@intel.com>
 <20130325202146.GA14900@kroah.com>
 <5B8DA87D05A7694D9FA63FD143655C1B01EF3427@HASMSX106.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5B8DA87D05A7694D9FA63FD143655C1B01EF3427@HASMSX106.ger.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 26, 2013 at 10:47:31PM +0000, Winkler, Tomas wrote:
> > 
> > On Sun, Mar 17, 2013 at 11:41:21AM +0200, Tomas Winkler wrote:
> > > ECOVERING_FROM_RESET device state is never set we can remove it
> > 
> > Really?  I now get the following build error with this patch applied:
> > 
> > drivers/misc/mei/pci-me.c: In function ‘mei_pci_suspend’:
> > drivers/misc/mei/pci-me.c:323:24: error:
> > ‘MEI_DEV_RECOVERING_FROM_RESET’ undeclared (first use in this
> > function)
> > drivers/misc/mei/pci-me.c:323:24: note: each undeclared identifier is
> > reported only once for each function it appears in
> > 
> > Please be more careful.
> 
> This patch has to be applied above patch  https://lkml.org/lkml/2013/3/10/101 that is queued for 3.9. 
> Somehow I've assumed it will go into 3.9-rc4.  

Yes, I hope to get it there.

> Anyhow we need to wait with this and everything else I have queued till it is merged back to char-misc-next.
> Maybe you have some suggestions how to handle such conflicts in the future.

Let me know about such conflicts so I don't blame you for them :)

I'll pull in the char-misc.linus branch into my .next branch now, so
that should solve this problem, right?  If so, please resend this patch
so I can apply it.

thanks,

greg k-h
