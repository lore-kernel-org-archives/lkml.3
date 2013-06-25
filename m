Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751865Ab3FYPGt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 11:06:49 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39735 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256Ab3FYPGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 11:06:48 -0400
Date: Tue, 25 Jun 2013 08:07:32 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: USB tree now closed for 3.11
Message-ID: <20130625150732.GA19676@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

With the release of the 3.10-rc7 kernel, I think it's time to close the
USB tree for new features / cleanups for 3.11.  So I'm closing my
tree, and will only be applying obvious bugfixes or regressions to it
until 3.11-rc1 comes out.

You can keep sending me patches for the tree that don't fit the "bugfix"
category, but note that I'll be storing them away to wait for 3.11-rc1
comes out, which might be a few weeks, so please be patient.

The USB tree right now contains 382 patches, and the diffstat
summary is:
	 410 files changed, 18183 insertions(+), 4956 deletions(-)

thanks,

greg k-h
