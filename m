Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752010AbaKBQMG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2014 11:12:06 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60986 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751133AbaKBQME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2014 11:12:04 -0500
Date: Sun, 2 Nov 2014 16:12:00 +0000
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: m.stam@fugro.nl
Cc: davem@davemloft.net, linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Arndale ethernet regression
Message-ID: <20141102161200.GM23178@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guys,

I have been having an issue with the ethernet on Arndale and it
bisects down to this commit:

commit 3cc81d85ee01e5a0b7ea2f4190e2ed1165f53c31
Author: Michel Stam <m.stam@fugro.nl>
asix: Don't reset PHY on if_up for ASIX 88772

I am afraid I am not overly familiar with the USB or networking
subsystems. But are we sure this patch is good? It seems to set
the reset callback to the link_reset function which feels a
little odd from my layman perspective. It doesn't look like there
could be any config settings or such that I am missing relating
to this patch.

Thanks,
Charles
