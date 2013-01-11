Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753583Ab3AKAr6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 19:47:58 -0500
Received: from talus.maths.usyd.edu.au ([129.78.68.1]:48770 "EHLO
	talus.maths.usyd.edu.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382Ab3AKAr5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 19:47:57 -0500
X-smtpdoor-from: psz@maths.usyd.edu.au
X-smtpdoor-want-Message-ID: <201301110046.r0B0k6lR024284@como.maths.usyd.edu.au>
Date: Fri, 11 Jan 2013 11:46:06 +1100
From: paul.szabo@sydney.edu.au
Message-Id: <201301110046.r0B0k6lR024284@como.maths.usyd.edu.au>
To: dave@linux.vnet.ibm.com
Subject: Re: [RFC] Reproducible OOM with partial workaround
Cc: 695182@bugs.debian.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <50EF4AD1.4060807@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Dave,

> Your configuration has never worked.  This isn't a regression ...
> ... does not mean that we expect it to work.

Do you mean that CONFIG_HIGHMEM64G is deprecated, should not be used;
that all development is for 64-bit only?

> ... 64-bit kernels should basically be drop-in replacements ...

Will think about that. I know all my servers are 64-bit capable, will
need to check all my desktops.

---

I find it puzzling that there seems to be a sharp cutoff at 32GB RAM,
no problem under but OOM just over; whereas I would have expected
lowmem starvation to be gradual, with OOM occuring much sooner with
64GB than with 34GB. Also, the kernel seems capable of reclaiming
lowmem, so I wonder why does that fail just over the 32GB threshhold.
(Obviously I have no idea what I am talking about.)

---

Thanks, Paul

Paul Szabo   psz@maths.usyd.edu.au   http://www.maths.usyd.edu.au/u/psz/
School of Mathematics and Statistics   University of Sydney    Australia
