Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755706Ab3HLWLw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 18:11:52 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57326 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754343Ab3HLWLv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 18:11:51 -0400
Date: Mon, 12 Aug 2013 15:11:50 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Paul McQuade <paulmcquad@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging:BCM:DDRInit.c:Replacing __FUNCTION__
Message-ID: <20130812221150.GB18287@kroah.com>
References: <52027FDA.3020707@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52027FDA.3020707@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 07, 2013 at 06:11:54PM +0100, Paul McQuade wrote:
> 

> >From 5b6fbb6496ddc4e428f5dd0950b0617faed6596b Mon Sep 17 00:00:00 2001
> From: Paul McQuade <paulmcquad@gmail.com>
> Date: Wed, 7 Aug 2013 16:21:16 +0100
> Subject: [PATCH] Staging:BCM:DDRInit.c:Replacing __FUNCTION__
> 
> __func__ replaces __Function__.

You mean __FUNCTION__ here, right?

And as Dan pointed out, please don't attach patches, I can't accept them
that way.

Please fix this up and resend it, thanks.

greg k-h
