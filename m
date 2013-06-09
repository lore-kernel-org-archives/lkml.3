Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751489Ab3FIREW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jun 2013 13:04:22 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:47388 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751043Ab3FIREU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jun 2013 13:04:20 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 9 Jun 2013 19:03:57 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Clemens Ladisch <clemens@ladisch.de>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: Re: [PATCH] firewire: introduce fw_driver.probe and .remove methods
Message-ID: <20130609190357.399faea8@stein>
In-Reply-To: <51AC14B4.4050003@sakamocchi.jp>
References: <51A20AEE.7060201@sakamocchi.jp>
	<20130526233513.1a95d0d5@stein>
	<20130526225757.GA32606@kroah.com>
	<51A742A1.8010108@sakamocchi.jp>
	<20130603002749.4fdc36a5@stein>
	<20130602223843.GA7194@kroah.com>
	<20130603013502.4df9bc6b@stein>
	<51AC14B4.4050003@sakamocchi.jp>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.17; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I pushed the branch "fw_driver-api-transition" out to linux1394.git at

    git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394.git fw_driver-api-transition

This branch originates from v3.10-rc5 and contains only the single patch
"firewire: introduce fw_driver.probe and .remove methods".

If you pull this branch, you _can_ move your drivers to the new methods.

Furthermore, the "master" and "for-next" branches at linux1394.git are
now based on "fw_driver-api-transition" and contain patch "firewire:
remove support of fw_driver.driver.probe and .remove methods".

This means that starting from tomorrow, any FireWire driver which goes into
linux-next _must_ implement the new methods.
-- 
Stefan Richter
-=====-===-= -==- -=--=
http://arcgraph.de/sr/
