Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751317Ab3FVG6L (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jun 2013 02:58:11 -0400
Received: from mail.active-venture.com ([67.228.131.205]:55865 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768Ab3FVG6J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jun 2013 02:58:09 -0400
X-Originating-IP: 108.223.40.66
Date: Fri, 21 Jun 2013 23:58:08 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org, Mika Kuoppala <mika.kuoppala@intel.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        David Airlie <airlied@linux.ie>
Subject: 'Timed out waiting for forcewake old ack to clear' and hangup on
 IvyBridge system
Message-ID: <20130622065808.GA20980@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

after upgrading one of my servers to 3.8, then 3.9.7 and 3.10-rc6, I started to
see lots of "Timed out waiting for forcewake old ack to clear" error messages,
including hang-ups especially if the system was highly loaded. With 3.5.24
everything was fine.

After backing out commit 36ec8f877 (drm/i915: unconditionally use mt forcewake
on hsw/ivb), everything is back to normal. The log message is still there, but
only once during boot, and the system runs stable.

CPU is "Intel(R) Core(TM) i7-3770K CPU @ 3.50GHz", mainboard is Supermicro
C7H61, BIOS version 2.00 dated 11/02/2012. Configuration file is whatever
comes with Ubuntu; I'll be happy to provide a copy if anyone thinks it might
help.

Any idea what else I can do besides using a special kernel with the backed out
commit ? Is it possible that others have the same problem ?

Thanks,
Guenter
