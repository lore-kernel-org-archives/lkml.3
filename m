Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1947435Ab3BIABW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 19:01:22 -0500
Received: from mail-da0-f53.google.com ([209.85.210.53]:54292 "EHLO
	mail-da0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1947367Ab3BIABV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 19:01:21 -0500
Date: Fri, 8 Feb 2013 16:01:18 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: devel@driverdev.osuosl.org
Cc: linux-kernel@vger.kernel.org
Subject: staging tree now closed for 3.9
Message-ID: <20130209000118.GA29146@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

With the release of the 3.8-rc7 kernel, I think it's time to close the
staging tree for new features / cleanups for 3.9.  So I'm closing my
tree, and will only be applying obvious bugfixes or regressions to it
until 3.9-rc1 comes out.

You can keep sending me patches for the tree that don't fit the "bugfix"
category, but note that I'll be storing them away to wait for 3.9-rc1
comes out, which might be a few weeks, so please be patient.

The staging tree right now contains 739 patches, and the diffstat
summary is:
	 557 files changed, 34132 insertions(+), 35286 deletions(-)
we actually deleted more lines than added, despite numerous new drivers
being added, a very nice job to everyone involved.

thanks,

greg k-h
