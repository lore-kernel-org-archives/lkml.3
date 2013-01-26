Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754337Ab3AZUXz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2013 15:23:55 -0500
Received: from talus.maths.usyd.edu.au ([129.78.68.1]:39179 "EHLO
	talus.maths.usyd.edu.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754051Ab3AZUXv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2013 15:23:51 -0500
X-smtpdoor-from: psz@maths.usyd.edu.au
X-smtpdoor-want-Message-ID: <201301262023.r0QKNIaK029258@como.maths.usyd.edu.au>
Date: Sun, 27 Jan 2013 07:23:18 +1100
From: paul.szabo@sydney.edu.au
Message-Id: <201301262023.r0QKNIaK029258@como.maths.usyd.edu.au>
To: jrnieder@gmail.com
Subject: Re: Bug#695182: [PATCH] Subtract min_free_kbytes from dirtyable memory
Cc: 695182@bugs.debian.org, ben@decadent.org.uk, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, minchan@kernel.org
In-Reply-To: <20130126074444.GA28833@elie.Belkin>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Jonathan,

>> If you can identify where it was fixed then your patch for older
>> versions should go to stable with a reference to the upstream fix (see
>> Documentation/stable_kernel_rules.txt).
>
> How about this patch?
>
> It was applied in mainline during the 3.3 merge window, so kernels
> newer than 3.2.y shouldn't need it.
>
> ...
> commit ab8fabd46f811d5153d8a0cd2fac9a0d41fb593d upstream.
> ...

Yes, I beleive that is the correct patch, surely better than my simple
subtraction of min_free_kbytes.

Noting, that this does not "solve" all problems, the latest 3.8 kernel
still crashes with OOM:
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1098961/comments/18

Thanks, Paul

Paul Szabo   psz@maths.usyd.edu.au   http://www.maths.usyd.edu.au/u/psz/
School of Mathematics and Statistics   University of Sydney    Australia
