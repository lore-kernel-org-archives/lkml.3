Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755289AbaIZQDi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 12:03:38 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43774 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754635AbaIZQDg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 12:03:36 -0400
Date: Fri, 26 Sep 2014 18:02:39 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        tony@atomide.com, balbi@ti.com,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: [PATCH 00/16 v9] omap 8250 based uart + DMA
Message-ID: <20140926160239.GA12801@kroah.com>
References: <1410377411-26656-1-git-send-email-bigeasy@linutronix.de>
 <20140917090506.GA6812@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140917090506.GA6812@breakpoint.cc>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 17, 2014 at 11:05:06AM +0200, Sebastian Andrzej Siewior wrote:
> On 2014-09-10 21:29:55 [+0200], Sebastian Andrzej Siewior wrote:
> > the diff of v8…v9 is small:
> 
> Greg, do you mind taking patches from this series up to "[PATCH 05/16]"?
> Nobody complained about those so far and it would keep v10 a little smaller.
> I have changes to #6 (the omap driver) and need to do some DMA related
> changes in the following

Now applied, thanks.

greg k-h
