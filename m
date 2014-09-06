Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751573AbaIFNgk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2014 09:36:40 -0400
Received: from mail.antaris-organics.com ([91.220.127.233]:34530 "EHLO
	mail.antaris-organics.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164AbaIFNgj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2014 09:36:39 -0400
X-Greylist: delayed 498 seconds by postgrey-1.27 at vger.kernel.org; Sat, 06 Sep 2014 09:36:39 EDT
Date: Sat, 6 Sep 2014 15:28:19 +0200
From: Markus Reichelt <ml@mareichelt.com>
To: linux-kernel@vger.kernel.org
Subject: Re: Linux 3.10.54
Message-ID: <20140906132819.GD10585@pc21.mareichelt.com>
Mail-Followup-To: linux-kernel@vger.kernel.org
References: <20140906000816.GA12458@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140906000816.GA12458@kroah.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Greg KH <gregkh@linuxfoundation.org> wrote:

> I'm announcing the release of the 3.10.54 kernel.

These days I don't follow this list that closely anymore but I wonder
why the following patch has not been included:

md/raid6: avoid data corruption during recovery of double-degraded RAID6
http://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable.git/commit/drivers/md?id=9c4bdf697c39805078392d5ddbbba5ae5680e0dd

Thanks for any info on that.

-- 
left blank, right bald
