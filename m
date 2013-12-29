Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750902Ab3L2GCF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Dec 2013 01:02:05 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:14088 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750743Ab3L2GCC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Dec 2013 01:02:02 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 108.39.110.144
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19y77DQV5AaQY3rGr964gBWe76AGHv+1zE=
X-DKIM: OpenDKIM Filter v2.0.1 titan 6596B4FD948
Date: Sun, 29 Dec 2013 01:02:00 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Gene Heskett <gheskett@wdtv.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Git puzzle
Message-ID: <20131229060200.GO19878@titan.lakedaemon.net>
References: <201312282141.40725.gheskett@wdtv.com>
 <201312290011.26801.gheskett@wdtv.com>
 <20131229052556.GM19878@titan.lakedaemon.net>
 <201312290042.00841.gheskett@wdtv.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201312290042.00841.gheskett@wdtv.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 29, 2013 at 12:42:00AM -0500, Gene Heskett wrote:
> On Sunday 29 December 2013, Jason Cooper wrote:
...
> >You may want to try the opposite approach.  x86_64_defconfig, then add
> >just what is necessary to boot and reproduce the bug.
> 
> Oh-oh, and where in this new tree do I find that?  Or is that a make 
> command?

$ make x86_64_defconfig

thx,

Jason.
