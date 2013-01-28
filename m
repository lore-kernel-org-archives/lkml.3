Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754547Ab3A1Ekr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 23:40:47 -0500
Received: from mail.kernel.org ([198.145.19.201]:43989 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751767Ab3A1Eko (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 23:40:44 -0500
Date: Sun, 27 Jan 2013 20:42:28 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Abdallah Chatila <abdallah.chatila@ericsson.com>
Cc: Jerry Snitselaar <dev@snitselaar.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, alan@lxorguk.ukuu.org.uk,
        Alan Cox <alan@linux.intel.com>, Jeff Garzik <jgarzik@redhat.com>
Subject: Re: [ 11/15] ahci: Add identifiers for ASM106x devices
Message-ID: <20130128044228.GA11294@kroah.com>
References: <20130124211723.489089115@linuxfoundation.org>
 <20130124211727.847446491@linuxfoundation.org>
 <20130125204521.GA1637@cantor.Home>
 <20130125220048.GA7238@dolphin.nala.lmc.ericsson.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130125220048.GA7238@dolphin.nala.lmc.ericsson.se>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 25, 2013 at 05:00:48PM -0500, Abdallah Chatila wrote:
> On Fri, Jan 25, 2013 at 01:45:21PM -0700, Jerry Snitselaar wrote:
> > 
> > There is a whitespace error in this patch:
> > 
> > Applying: ahci: Add identifiers for ASM106x devices
> > /root/linux/linux/.git/rebase-apply/patch:12: space before tab in indent.
> >         /* Asmedia */
> > warning: 1 line adds whitespace errors.
> 
> Will send a new patch to remove the extra whitespace before the comment
> shortly.

I've edited it by hand and fixed it up.

thanks,

greg k-h
