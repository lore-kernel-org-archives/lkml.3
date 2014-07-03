Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754792AbaGCCgW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 22:36:22 -0400
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:9907 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750916AbaGCCgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 22:36:21 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao9cAKjAtFN5LHZ8PGdsb2JhbABUBoMNg0qFCKQZAQIBAQEGmlUBgQcXBAEBAQE4NYQDAQEFOhwjEAgDDgoJJQ8FJQMHGhOIQcdPFxiFWIhvQweEQwWabIZXkQkr
Date: Thu, 3 Jul 2014 12:36:18 +1000
From: Dave Chinner <david@fromorbit.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: stable@vger.kernel.org, linux@roeck-us.net, satoru.takeuchi@gmail.com,
        shuah.kh@samsung.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3.12 000/181] 3.12.24-stable review
Message-ID: <20140703023618.GO4453@dastard>
References: <cover.1404128997.git.jslaby@suse.cz>
 <20140701235359.GJ4453@dastard>
 <53B3BE3E.3080802@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53B3BE3E.3080802@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 02, 2014 at 10:09:34AM +0200, Jiri Slaby wrote:
> On 07/02/2014 01:53 AM, Dave Chinner wrote:
> > On Mon, Jun 30, 2014 at 01:51:22PM +0200, Jiri Slaby wrote:
> >> This is the start of the stable review cycle for the 3.12.24 release.
> >> There are 181 patches in this series, all will be posted as a response
> >> to this one.  If anyone has any issues with these being applied, please
> >> let me know.
> > .....
> >> Dave Chinner (3):
> >>   xfs: prevent deadlock trying to cover an active log
> >>   xfs: prevent stack overflows from page cache allocation
> >>   xfs: xfs_remove deadlocks due to inverted AGF vs AGI lock ordering
> > 
> > None of the XFS patches you're backporting were marked for stable.
> > What criteria did you choose them by, and how are you testing the
> > result?
> 
> Hi Dave,
> 
> these patches are in SUSE's enterprise linux based on 3.12. So I picked
> them from there. Testing is covered by our QA, but of course, with some
> additional patches on the top of them which do not satisfy the stable
> rules (because they add features).
> 
> > Randomly picked XFS backports have a nasty habit of causing
> > regressions, and it's always me that is on the pointy end of having
> > to triage problems users report with those backports...
> 
> Despite the patches fix real problems, if you prefer me not to take such
> patches, I will drop them and will apply no more.

I don't mind as long as I know they are being testing properly. It
sounds like you've already got that in hand (via SuSE QA), so I
don't have any problems with including them.

I just wanted to understand the process because it seemed a little
unusual for a stable kernel. ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
