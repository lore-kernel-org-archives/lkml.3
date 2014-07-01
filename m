Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757221AbaGAXyJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 19:54:09 -0400
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:40340 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752046AbaGAXyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 19:54:07 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhFSAMVIs1N5LHZ8PGdsb2JhbABagw2DSYUIpBMGmkkBgQ4XBAEBAQE4NYQDAQEFOhwjEAgDDgoJJQ8FJQMHGhOIQcUOFxeFWIkwB4RDAQSaZYZSkQYr
Date: Wed, 2 Jul 2014 09:53:59 +1000
From: Dave Chinner <david@fromorbit.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: stable@vger.kernel.org, linux@roeck-us.net, satoru.takeuchi@gmail.com,
        shuah.kh@samsung.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3.12 000/181] 3.12.24-stable review
Message-ID: <20140701235359.GJ4453@dastard>
References: <cover.1404128997.git.jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1404128997.git.jslaby@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 30, 2014 at 01:51:22PM +0200, Jiri Slaby wrote:
> This is the start of the stable review cycle for the 3.12.24 release.
> There are 181 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
.....
> Dave Chinner (3):
>   xfs: prevent deadlock trying to cover an active log
>   xfs: prevent stack overflows from page cache allocation
>   xfs: xfs_remove deadlocks due to inverted AGF vs AGI lock ordering

None of the XFS patches you're backporting were marked for stable.
What criteria did you choose them by, and how are you testing the
result?

Randomly picked XFS backports have a nasty habit of causing
regressions, and it's always me that is on the pointy end of having
to triage problems users report with those backports...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
