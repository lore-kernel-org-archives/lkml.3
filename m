Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752889AbaBMXee (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 18:34:34 -0500
Received: from trent.utfs.org ([94.185.90.103]:44313 "EHLO trent.utfs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752006AbaBMXed (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 18:34:33 -0500
Date: Thu, 13 Feb 2014 15:34:19 -0800 (PST)
From: Christian Kujau <lists@nerdbynature.de>
To: Dave Chinner <david@fromorbit.com>
cc: LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, linux-mm@kvack.org
Subject: Re: 3.14.0-rc2: WARNING: at mm/slub.c:1007
In-Reply-To: <20140213222602.GK13997@dastard>
Message-ID: <alpine.DEB.2.19.4.1402131531290.6233@trent.utfs.org>
References: <alpine.DEB.2.19.4.1402131144390.6233@trent.utfs.org> <20140213222602.GK13997@dastard>
User-Agent: Alpine 2.19.4 (DEB 40 2013-11-18)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-AV-Checked: ClamAV using ClamSMTP (127.0.0.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Feb 2014 at 09:26, Dave Chinner wrote:
> > after upgrading from 3.13-rc8 to 3.14.0-rc2 on this PowerPC G4 machine, 
> > the WARNING below was printed.
> > 
> > Shortly after, a lockdep warning appeared (possibly related to my 
> > post to the XFS list yesterday[0]).
> 
> Unlikely.

OK, so the "possible irq lock inversion dependency detected" is a lockdep 
regression, as you explained in the xfs-list thread. What about the 
"RECLAIM_FS-safe -> RECLAIM_FS-unsafe lock order detected" warning - I 
haven't seen it again though, only once with 3.14.0-rc2.

Christian.
-- 
BOFH excuse #108:

The air conditioning water supply pipe ruptured over the machine room
