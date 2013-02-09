Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1947495Ab3BIAEP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 19:04:15 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:65153 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1947459Ab3BIAEK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 19:04:10 -0500
Date: Fri, 8 Feb 2013 16:04:08 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-serial@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: TTY/serial tree now closed for 3.9
Message-ID: <20130209000408.GB29346@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

With the release of the 3.8-rc7 kernel, I think it's time to close the
TTY/serial tree for new features / cleanups for 3.9.  So I'm closing my
tree, and will only be applying obvious bugfixes or regressions to it
until 3.9-rc1 comes out.

You can keep sending me patches for the tree that don't fit the "bugfix"
category, but note that I'll be storing them away to wait for 3.9-rc1
comes out, which might be a few weeks, so please be patient.

The TTY tree right now contains 120 patches, and the diffstat
summary is:
	 254 files changed, 6720 insertions(+), 2528 deletions(-)

thanks,

greg k-h
