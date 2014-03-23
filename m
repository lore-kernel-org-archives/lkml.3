Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752306AbaCWPau (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2014 11:30:50 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:55957 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913AbaCWPas (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2014 11:30:48 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Fengguang Wu <fengguang.wu@intel.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Roland Scheidegger <rscheidegger_lists@hispeed.ch>
Subject: [PATCH 0/2] Clock fixes for UVC gadget driver
Date: Sun, 23 Mar 2014 16:32:32 +0100
Message-Id: <1395588754-20587-1-git-send-email-laurent.pinchart@ideasonboard.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <20140323001018.GA11963@localhost>
References: <20140323001018.GA11963@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

These two patches fix clock issues in the UVC gadget driver. Please see
individual patches for details.

The series is based on the latest media tree master branch as it depends on
commit 872484ce40881e295b046adf21f7211306477751 ("v4l: Add timestamp source
flags, mask and document them") queued for v3.15. It would thus be easier to
merge it through the media tree. Greg and Mauro, would that be fine ?
Alternatively I can rebase it on top of v3.15-rc1 when that version will be
tagged.

Laurent Pinchart (2):
  usb: gadget: uvc: Switch to monotonic clock for buffer timestamps
  usb: gadget: uvc: Set the vb2 queue timestamp flags

 drivers/usb/gadget/uvc_queue.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

-- 
Regards,

Laurent Pinchart

