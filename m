Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754529AbaEMTBB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 15:01:01 -0400
Received: from BERING.ISR.CS.CMU.EDU ([128.2.209.223]:41646 "EHLO
	bering.isr.cs.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754485AbaEMTAv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 15:00:51 -0400
X-Greylist: delayed 2657 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 May 2014 15:00:51 EDT
Date: Tue, 13 May 2014 14:16:30 -0400
From: Jan Harkes <jaharkes@cs.cmu.edu>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/3] FS/CODA: replace printk by pr_foo()
Message-ID: <20140513181629.GA24191@cs.cmu.edu>
Mail-Followup-To: Fabian Frederick <fabf@skynet.be>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	akpm <akpm@linux-foundation.org>
References: <20140513184909.e5ccec32a70c2722c43c1d1e@skynet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140513184909.e5ccec32a70c2722c43c1d1e@skynet.be>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2014 at 06:49:09PM +0200, Fabian Frederick wrote:
> No level printk converted to pr_warn or pr_info
> 
> Cc: Jan Harkes <jaharkes@cs.cmu.edu>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Fabian Frederick <fabf@skynet.be>
> ---

Ack, those are nice cleanups for those ugly printk's. Looks like it will
shave off a few KB of memory too by making the strings shorter.

Jan

>  fs/coda/cnode.c      |  4 ++--
>  fs/coda/coda_linux.h |  2 +-
>  fs/coda/dir.c        | 12 ++++++------
>  fs/coda/inode.c      | 29 +++++++++++++++--------------
>  fs/coda/psdev.c      | 34 +++++++++++++++++-----------------
>  fs/coda/upcall.c     | 14 +++++++-------
>  6 files changed, 48 insertions(+), 47 deletions(-)
