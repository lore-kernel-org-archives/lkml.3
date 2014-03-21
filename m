Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760370AbaCUImp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 04:42:45 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37287 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751620AbaCUImm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 04:42:42 -0400
Date: Fri, 21 Mar 2014 09:42:39 +0100
From: Jean Delvare <jdelvare@suse.de>
To: Andy Whitcroft <apw@canonical.com>, Joe Perches <joe@perches.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: checkpatch on Kconfig files
Message-ID: <20140321094239.18aebf02@endymion.delvare>
Organization: SUSE Linux
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andy, hi Joe,

When running checkpatch on a patch which tweaks many Kconfig entries, I
got the following output:

WARNING: please write a paragraph that describes the config symbol fully
#74: FILE: drivers/hid/Kconfig:142:
 config HID_BELKIN

WARNING: please write a paragraph that describes the config symbol fully
#82: FILE: drivers/hid/Kconfig:149:
 config HID_CHERRY

WARNING: please write a paragraph that describes the config symbol fully
#135: FILE: drivers/hid/Kconfig:415:
 config HID_MICROSOFT

total: 0 errors, 3 warnings, 88 lines checked

I am not adding these entries, just tweaking the dependencies. Thus I
don't think it makes sense to print these warnings, they aren't
relevant to the changes I am making. There comment in checkpatch says:

# check for Kconfig help text having a real description
# Only applies when adding the entry originally, after that we do not have
# sufficient context to determine whether it is indeed long enough.

So I suspect these warnings aren't supposed to be displayed. I recall
hitting this many times in the past, in fact I think this is the most
frequent and oldest false positive I get from checkpatch. So I would
appreciate if this could be fixed, either by really limiting the
warning to Kconfig entries being added (if you can) or by dropping the
check altogether (if you can't.)

Thanks,
-- 
Jean Delvare
SUSE L3 Support
