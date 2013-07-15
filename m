Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933160Ab3GOPk4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 11:40:56 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:37025 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932646Ab3GOPkz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 11:40:55 -0400
Date: Mon, 15 Jul 2013 11:40:50 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: CONFIG_* used by user-space to figure out whether a feature is on/off
Message-ID: <20130715154050.GA5941@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Linus,

I am hoping you can help me draw an understanding and a line in sand whether:
 a) Tools should not depend on /proc/config.gz to figure out whether
    a kernel has some CONFIG_X=y feature.

 b) If they are OK to do so, what do we do when certain CONFIG_X options
    get reworked/removed. Would they be considered regressions? Aka
    is this similar to 'you shall not break user-space'?


Irrespective of that, do you have any ideas of how a user-space program (say GRUB)
can figure out whether the configuration stanze it generates is supported by
the kernel. If you don't want to answer this question - since this might
open a can of worms you prefer not to deal with - that is absolutly OK.

Folks have been tossing ideas such as:
 - Let the user deal with it and if it does not boot - oh well.
 - readelf or objdump.
 - use /boot/config-<kernel>-<version> as most (all?) distros stick that in
   there.

Thanks!
