Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751455AbaDAK4Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 06:56:16 -0400
Received: from plane.gmane.org ([80.91.229.3]:54134 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751162AbaDAK4P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 06:56:15 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: [PATCH v2] lib: add size unit t/p/e to memparse
Date: Tue, 1 Apr 2014 10:55:59 +0000 (UTC)
Message-ID: <pan$8fddd$cc4f106$67b55dbb$abaf55ec@cox.net>
References: <1396346251-2506-1-git-send-email-guihc.fnst@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: ip68-231-22-224.ph.ph.cox.net
User-Agent: Pan/0.140 (Chocolate Salty Balls; GIT 2ae6aff
 /usr/src/portage/src/egit-src/pan2)
Cc: linux-btrfs@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gui Hecheng posted on Tue, 01 Apr 2014 17:57:31 +0800 as excerpted:

> + *	potentially suffixed with 
> + *	%K (for kibibytes, or 1024 bytes),
> + *	%M (for mebibytes, or 1048576 bytes),
> + *	%G (for gibibytes, or 1073741824),
> + *	%T (for tebibytes, or 1099511627776),
> + *	%P (for pebibytes, or 1125899906842624 bytes),
> + *	%E (for exbibytes, or 1152921504606846976 bytes).

Why do the first two and the last two end in bytes, but the the middle 
two don't?  I'd suggest either only specifying bytes on the first one
(a reasonably common pattern in English, with the carry down to the 
others implied) or on all of them.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

