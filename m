Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757068Ab3APSgO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 13:36:14 -0500
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:30087 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756552Ab3APSgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 13:36:13 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 72.84.113.162
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18SyT9rjqHv9X/VIzQCixJXjz2aCpkeyM4=
Date: Wed, 16 Jan 2013 13:35:18 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Soeren Moch <smoch@web.de>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Andrew Lunn <andrew@lunn.ch>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org,
        Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org,
        Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        linaro-mm-sig@lists.linaro.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH] ata: sata_mv: fix sg_tbl_pool alignment
Message-ID: <20130116183518.GL25500@titan.lakedaemon.net>
References: <20130115175020.GA3764@kroah.com>
 <20130115201617.GC25500@titan.lakedaemon.net>
 <20130115215602.GF25500@titan.lakedaemon.net>
 <50F5F1B7.3040201@web.de>
 <20130116024014.GH25500@titan.lakedaemon.net>
 <50F61D86.4020801@web.de>
 <50F66B1B.40301@web.de>
 <20130116155045.GI25500@titan.lakedaemon.net>
 <50F6DDF7.9080605@web.de>
 <20130116175203.GK25500@titan.lakedaemon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130116175203.GK25500@titan.lakedaemon.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > >On Wed, Jan 16, 2013 at 09:55:55AM +0100, Soeren Moch wrote:
> > >>I don't want to say that Mareks patch is wrong, probably it triggers a
> > >>bug somewhere else! (in em28xx?)

Could you send the output of:

lsusb -v -d VEND:PROD

for the em28xx?

thx,

Jason.
