Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751306AbaBBLJh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Feb 2014 06:09:37 -0500
Received: from stinky.trash.net ([213.144.137.162]:58688 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019AbaBBLJg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Feb 2014 06:09:36 -0500
X-Greylist: delayed 368 seconds by postgrey-1.27 at vger.kernel.org; Sun, 02 Feb 2014 06:09:36 EST
Date: Sun, 2 Feb 2014 11:03:24 +0000
From: Patrick McHardy <kaber@trash.net>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-kernel@vger.kernel.org
Subject: HID bluetooth regression
Message-ID: <20140202110324.GA4895@macbook.localnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit b1a1442a2 (HID: core: fix reporting of raw events) introduced a
regression that causes lockups for bluetooth trackpads.

This was already discussed in this thread in September:

http://www.kernelhub.org/?p=2&msg=329823

but it seems nothing has been fixed so far, I still get the lockups
in 3.13. Reverting that patch fixes it for me, but it would be great
if someone could push a proper fix upstream.

If you need me to test anything, please let me know.
