Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756135AbaEIHis (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 03:38:48 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:41651 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756041AbaEIHiq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 03:38:46 -0400
Date: Fri, 9 May 2014 09:38:41 +0200
From: Pavel Machek <pavel@ucw.cz>
To: David Miller <davem@davemloft.net>
Cc: andi@firstfloor.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        tom.zanussi@linux.intel.com, ak@linux.intel.com
Subject: Re: [PATCH 08/24] net, diet: Make TCP metrics optional
Message-ID: <20140509073841.GC4965@xo-6d-61-c0.localdomain>
References: <1399328773-6531-1-git-send-email-andi@firstfloor.org>
 <1399328773-6531-9-git-send-email-andi@firstfloor.org>
 <20140505.231229.136734008603421707.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140505.231229.136734008603421707.davem@davemloft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2014-05-05 23:12:29, David Miller wrote:
> From: Andi Kleen <andi@firstfloor.org>
> Date: Mon,  5 May 2014 15:25:57 -0700
> 
> > This is all the code that saves connection information
> > between different sockets. Not really essential for
> > small systems.
> 
> It is absolutely essential unless you want poor performance
> of TCP connections.

Sounds like "poor" performance of TCP and 400KB memory free is tradeoff that
makes for small machines.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
