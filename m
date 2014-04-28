Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755871AbaD1U7Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 16:59:25 -0400
Received: from www.linutronix.de ([62.245.132.108]:60153 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751376AbaD1U7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 16:59:24 -0400
Date: Mon, 28 Apr 2014 22:59:34 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Cyrill Gorcunov <gorcunov@gmail.com>
cc: linux-kernel@vger.kernel.org, shawn@churchofgit.com,
        akpm@linux-foundation.org, avagin@openvz.org, xemul@parallels.com,
        vdavydov@parallels.com
Subject: Re: [patch 0/3] timerfd -- implement missing parts to checkpoint
 and restore timerfd state, v2
In-Reply-To: <20140428205334.GD16176@moon>
Message-ID: <alpine.DEB.2.02.1404282255590.6261@ionos.tec.linutronix.de>
References: <20140407174701.734703531@openvz.org> <20140428205334.GD16176@moon>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Apr 2014, Cyrill Gorcunov wrote:

> On Mon, Apr 07, 2014 at 09:47:01PM +0400, Cyrill Gorcunov wrote:
> > Hi, here is an updated series, changes mostly in show_fdinfo code which now
> > produces a way more information (and documentation update). Please take a look
> > once time permit. Thanks!
> 
> Hi, any new comments on this series?

Looks ok and I did not do anything about it, as I saw a "will update
in next version" from you in the discussion.

Thanks,

	tglx

