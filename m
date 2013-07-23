Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754349Ab3GWCCW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 22:02:22 -0400
Received: from home.keithp.com ([63.227.221.253]:43591 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753753Ab3GWCCT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 22:02:19 -0400
From: Keith Packard <keithp@keithp.com>
To: linux-kernel@vger.kernel.org, Dave Airlie <airlied@redhat.com>
Cc: Keith Packard <keithp@keithp.com>, dri-devel@lists.freedesktop.org
Subject: drm: Asynchronouse page flipping interface and Intel implementation
Date: Mon, 22 Jul 2013 18:49:57 -0700
Message-Id: <1374544202-15496-1-git-send-email-keithp@keithp.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's a sequence of five patches that exposes an interface to request
of the driver that the page flipping request be executed without
waiting for vblank. It's optional, and drivers can expose whether it
is supported through the existing GETCAP ioctl.

This supports only Ivybridge and Sandybridge Intel graphics chips as
that's what I've got to test on; of course all of the other drivers
have been modified so that they still compile cleanly.


--
keith.packard@intel.com

