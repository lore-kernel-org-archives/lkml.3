Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755826Ab3AYJxs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 04:53:48 -0500
Received: from talus.maths.usyd.edu.au ([129.78.68.1]:57033 "EHLO
	talus.maths.usyd.edu.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753944Ab3AYJxp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 04:53:45 -0500
X-smtpdoor-from: psz@maths.usyd.edu.au
X-smtpdoor-want-Message-ID: <201301250953.r0P9rOSe012192@como.maths.usyd.edu.au>
Date: Fri, 25 Jan 2013 20:53:24 +1100
From: paul.szabo@sydney.edu.au
Message-Id: <201301250953.r0P9rOSe012192@como.maths.usyd.edu.au>
To: minchan@kernel.org, psz@maths.usyd.edu.au
Subject: Re: [PATCH] Subtract min_free_kbytes from dirtyable memory
Cc: 695182@bugs.debian.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Minchan,

> So what's the effect for user?
> ...
> It seems you saw old kernel.
> ...
> Current kernel includes ...
> So I think we don't need this patch.

As I understand now, my patch is "right" and needed for older kernels;
for newer kernels, the issue has been fixed in equivalent ways; it was
an oversight that the change was not backported; and any justification
you need, you can get from those "later better" patches.

I asked:

  A question: what is the use or significance of vm_highmem_is_dirtyable?
  It seems odd that it would be used in setting limits or threshholds, but
  not used in decisions where to put dirty things. Is that so, is that as
  should be? What is the recommended setting of highmem_is_dirtyable?

The silence is deafening. I guess highmem_is_dirtyable is an aberration.

Thanks, Paul

Paul Szabo   psz@maths.usyd.edu.au   http://www.maths.usyd.edu.au/u/psz/
School of Mathematics and Statistics   University of Sydney    Australia
