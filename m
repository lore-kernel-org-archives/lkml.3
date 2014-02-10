Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752523AbaBJJ1U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 04:27:20 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:51721 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751123AbaBJJ1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 04:27:18 -0500
Date: Mon, 10 Feb 2014 12:27:10 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Joe Perches <joe@perches.com>, Andy Whitcroft <apw@canonical.com>
Cc: linux-kernel@vger.kernel.org
Subject: WARNING: Unnecessary parentheses - maybe == should be = ?
Message-ID: <20140210092710.GA10899@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These messages are terrifying...  We do not want to encourage a million
first patch submitters to start introducing = vs == bugs.

Did you look through the warning messages this generates?  Was it ever
appropriate to change the == to =?

Please remove the second part of that message.

Also there needs to be a mailing list for checkpatch.pl.  LKML is a
write only archive, but it's not a discussion list.

Also the seq_puts() warning messages should be put under --strict
because we have to fight against people submitting those patches.

regards,
dan carpenter
