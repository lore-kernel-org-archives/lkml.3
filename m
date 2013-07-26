Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759728Ab3GZUdE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 16:33:04 -0400
Received: from oproxy14-pub.unifiedlayer.com ([67.222.51.224]:40354 "HELO
	oproxy14-pub.unifiedlayer.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757630Ab3GZUc5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 16:32:57 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org
Cc: hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de,
        torvalds@linux-foundation.org
Subject: Updated stolen mem patches
Date: Fri, 26 Jul 2013 13:32:50 -0700
Message-Id: <1374870772-4592-1-git-send-email-jbarnes@virtuousgeek.org>
X-Mailer: git-send-email 1.7.9.5
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These address the comments I've received so far, but omit the new E820
type for this mem.

Chris's patches could go on top if desired; they add a new type and
resource reservation function for looking up regions by name.  That
allows us to remove some duplicate code in the driver for finding stolen
space.

But I think these two are ready as-is.  How should we merge them?  Just
through the i915 tree since the first one touches our headers?  that and
there probably won't be conflicts on the early-quirks file; that's not
touch too often...

Thanks,
Jesse

