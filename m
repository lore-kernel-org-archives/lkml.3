Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752719Ab3FYPWt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 11:22:49 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39840 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752231Ab3FYPWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 11:22:47 -0400
Date: Tue, 25 Jun 2013 08:23:32 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: devel@driverdev.osuosl.org
Cc: linux-kernel@vger.kernel.org
Subject: staging tree now closed for 3.11
Message-ID: <20130625152332.GC20244@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

With the release of the 3.10-rc7 kernel, I think it's time to close the
staging tree for new features / cleanups for 3.11.  So I'm closing my
tree, and will only be applying obvious bugfixes or regressions to it
until 3.11-rc1 comes out.

You can keep sending me patches for the tree that don't fit the "bugfix"
category, but note that I'll be storing them away to wait for 3.11-rc1
comes out, which might be a few weeks, so please be patient.

The staging tree right now contains 868 patches, and the diffstat
summary is:
	 878 files changed, 281113 insertions(+), 21520 deletions(-)

The large majority of the lines added is the Lustre client code, but
it's not being built just yet, so all is good :)

thanks,

greg k-h
