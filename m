Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752904Ab3IWW7z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 18:59:55 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:48454 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752007Ab3IWW7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 18:59:54 -0400
Date: Mon, 23 Sep 2013 15:59:49 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: apw@canonical.com, joe@perches.com
Cc: linux-kernel@vger.kernel.org
Subject: False positive in checkpatch
Message-ID: <20130923225949.GA26278@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13092322-0928-0000-0000-000001D2839F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

The checkpatch.pl script complains as follows:

ERROR: need consistent spacing around '*' (ctx:WxB)
#57: FILE: include/linux/rcupdate.h:564:
+		ACCESS_ONCE(p) = (typeof(*(v)) __force space *)(v); \

Of course, the two uses of '*' are doing different things, so it should
be OK for the spacing to be different.

Could you please fix this?

							Thanx, Paul

