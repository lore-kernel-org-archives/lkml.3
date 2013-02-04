Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753900Ab3BDDP7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 22:15:59 -0500
Received: from netrider.rowland.org ([192.131.102.5]:41755 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753757Ab3BDDP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 22:15:56 -0500
Date: Sun, 3 Feb 2013 22:15:55 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Li, Fei" <fei.li@intel.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "Liu, Chuansheng" <chuansheng.liu@intel.com>
Subject: RE: [PATCH V4] suspend: enable freeze timeout configuration through
 sys
In-Reply-To: <BEC9F67575FA1E429CA7CF5AE9BE36343F154E@SHSMSX102.ccr.corp.intel.com>
Message-ID: <Pine.LNX.4.44L0.1302032213410.28934-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Feb 2013, Li, Fei wrote:

> > -> the situation described above shouldn't happen and if it does, then there
> > is a bug that needs to be fixed.
> 
> Yes, we agree with that it's a bug that needs to be fixed, and we are already done
> for some cases. 
> During the process, we realize that tuning the timeout value to smaller value will help
> to expose freezing failure for some cases.

Besides, the underlying bug is well known (fuse filesystems hanging
because the fuse daemon gets frozen before the process doing file I/O,
or something like that) and so far nobody has a good idea of how to
fix it.

Alan Stern

