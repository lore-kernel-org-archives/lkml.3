Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756061AbaD1VEE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 17:04:04 -0400
Received: from mail-la0-f48.google.com ([209.85.215.48]:40477 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752119AbaD1VED (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 17:04:03 -0400
Date: Tue, 29 Apr 2014 01:03:59 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, shawn@churchofgit.com,
        akpm@linux-foundation.org, avagin@openvz.org, xemul@parallels.com,
        vdavydov@parallels.com
Subject: Re: [patch 0/3] timerfd -- implement missing parts to checkpoint and
 restore timerfd state, v2
Message-ID: <20140428210359.GE16176@moon>
References: <20140407174701.734703531@openvz.org>
 <20140428205334.GD16176@moon>
 <alpine.DEB.2.02.1404282255590.6261@ionos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1404282255590.6261@ionos.tec.linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2014 at 10:59:34PM +0200, Thomas Gleixner wrote:
> On Tue, 29 Apr 2014, Cyrill Gorcunov wrote:
> 
> > On Mon, Apr 07, 2014 at 09:47:01PM +0400, Cyrill Gorcunov wrote:
> > > Hi, here is an updated series, changes mostly in show_fdinfo code which now
> > > produces a way more information (and documentation update). Please take a look
> > > once time permit. Thanks!
> > 
> > Hi, any new comments on this series?
> 
> Looks ok and I did not do anything about it, as I saw a "will update
> in next version" from you in the discussion.

Silly me :( I promised to update the series a bit, and forgot. Thanks, Thomas!
