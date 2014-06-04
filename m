Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751861AbaFDSYB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 14:24:01 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37073 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751230AbaFDSX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 14:23:59 -0400
Date: Wed, 4 Jun 2014 11:27:39 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Dave Jones <davej@redhat.com>, linux-mm@kvack.org,
        Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Brandon Philips <brandon.philips@coreos.com>
Subject: Bad rss-counter is back on 3.14-stable
Message-ID: <20140604182739.GA30340@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Dave, I saw you mention that you were seeing the "Bad rss-counter" line
on 3.15-rc1, but I couldn't find any follow-up on this to see if anyone
figured it out, or did it just "magically" go away?

I ask as Brandon is seeing this same message a lot on a 3.14.4 kernel,
causing system crashes and problems:

[16591492.449718] BUG: Bad rss-counter state mm:ffff8801ced99880 idx:0 val:-1836508
[16591492.449737] BUG: Bad rss-counter state mm:ffff8801ced99880 idx:1 val:1836508

[20783350.461716] BUG: Bad rss-counter state mm:ffff8801d2b1dc00 idx:0 val:-52518
[20783350.461734] BUG: Bad rss-counter state mm:ffff8801d2b1dc00 idx:1 val:52518

[21393387.112302] BUG: Bad rss-counter state mm:ffff8801d0104e00 idx:0 val:-1767569
[21393387.112321] BUG: Bad rss-counter state mm:ffff8801d0104e00 idx:1 val:1767569

[21430098.512837] BUG: Bad rss-counter state mm:ffff880100036680 idx:0 val:-2946
[21430098.512854] BUG: Bad rss-counter state mm:ffff880100036680 idx:1 val:2946

Anyone have any ideas of a 3.15-rc patch I should be including in
3.14-stable to resolve this?

thanks,

greg k-h
