Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754119AbaIBMrv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 08:47:51 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40108 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751130AbaIBMrt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 08:47:49 -0400
Date: Tue, 2 Sep 2014 14:47:46 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Vishnu Pratap Singh <vishnu.ps@samsung.com>
cc: akpm@linux-foundation.org, oleg@redhat.com, richard@nod.at,
        paulmck@linux.vnet.ibm.com, fabf@skynet.be, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org, cpgs@samsung.com, pintu.k@samsung.com,
        vishu13285@gmail.com
Subject: Re: [PATCH] kernel/signal.c: whitespace fixes
In-Reply-To: <1409661657-7598-1-git-send-email-vishnu.ps@samsung.com>
Message-ID: <alpine.LNX.2.00.1409021445580.2481@pobox.suse.cz>
References: <1409661657-7598-1-git-send-email-vishnu.ps@samsung.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Sep 2014, Vishnu Pratap Singh wrote:

> From: "vishnu.ps" <vishnu.ps@samsung.com>
> 
> Fix minor errors and warning messages in kernel/signal.c.  These errors were
> reported by checkpatch while working with some modifications in signal.c
> file.
> 
> ERROR: code indent should use tabs where possible - 18
> ERROR: need consistent spacing around '&' (ctx:WxO) - 11
> ERROR: space prohibited after that '~' (ctx:OxW) - 11
> ERROR: trailing whitespace - 4
> ERROR: space required after that ',' (ctx:VxV) - 4
> ERROR: trailing statements should be on next line - 3
> ERROR: "foo * bar" should be "foo *bar" - 1
> 
> total 52 errors fixed.

I am not taking this through trivial.git; it just clutters results of 'git 
blame' horribly for no measurable gain.

Changes like this are reasonable only if you make any real changes to the 
code at the same time.

-- 
Jiri Kosina
SUSE Labs
