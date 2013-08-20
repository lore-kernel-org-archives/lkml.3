Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751321Ab3HTOBI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 10:01:08 -0400
Received: from top.free-electrons.com ([176.31.233.9]:32948 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751228Ab3HTOBG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 10:01:06 -0400
Date: Tue, 20 Aug 2013 11:01:06 -0300
From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC 08/17] ARM: mvebu: remove custom .init_time hook
Message-ID: <20130820140105.GB4272@localhost>
References: <1376964271-22715-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1376964271-22715-9-git-send-email-sebastian.hesselbarth@gmail.com>
 <20130820125012.GA4272@localhost>
 <52136B2C.3030509@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <52136B2C.3030509@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 20, 2013 at 03:12:12PM +0200, Sebastian Hesselbarth wrote:
> > Maybe that's why I'm getting only the patches where I'm Cced?
> 
> I try to keep Cc list as short as possible, so I only put Gregory as the 
> maintainer of mach-mvebu on Cc.
> 

Pff... you're right, I got this because my mvebu-filters caught it from
lkml! I'm seeing now the complete patchset in lkml, it looks good!

> 
> I expect machs to move until all of it has been Ack'ed, so I
> based in on most recent tag of linux-next yesterday.
> 

No problem, just wanted to let you know about that.
Feel free to update the remaining bits once Daniel's lands
in linux-next.

Thanks,
-- 
Ezequiel García, Free Electrons
Embedded Linux, Kernel and Android Engineering
http://free-electrons.com
