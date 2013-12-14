Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752010Ab3LNFy3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 00:54:29 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53835 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751233Ab3LNFy2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 00:54:28 -0500
Date: Fri, 13 Dec 2013 21:54:23 -0800
From: Brian Norris <computersforpeace@gmail.com>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: linux-mtd@lists.infradead.org,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] MTD maintenance updates
Message-ID: <20131214055423.GB2454@norris-Latitude-E6410>
References: <1386199726-28074-1-git-send-email-computersforpeace@gmail.com>
 <1386232488.23205.283.camel@sauron.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386232488.23205.283.camel@sauron.fi.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 05, 2013 at 10:34:48AM +0200, Artem Bityutskiy wrote:
> On Wed, 2013-12-04 at 15:28 -0800, Brian Norris wrote:
> > BTW, I'd like to get David's "ack" for these patches, and it'd be nice
> > to hear
> > from Artem too, since he has previously been an unofficial maintainer
> > (and is
> > understandably distracted by non-MTD work these days).
> 
> Acked-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
> 
> Thanks Brian for taking care of the MTD subsystem.

Happy to!

Pushed both to l2-mtd.git. I'll give David a chance to yell before
3.14-rc1.

Brian
