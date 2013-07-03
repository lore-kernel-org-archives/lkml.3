Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754777Ab3GCIZ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 04:25:28 -0400
Received: from mx-out.ocsa-data.net ([194.36.166.37]:53647 "EHLO
	mx-out.ocsa-data.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754070Ab3GCIZZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 04:25:25 -0400
X-Greylist: delayed 641 seconds by postgrey-1.27 at vger.kernel.org; Wed, 03 Jul 2013 04:25:25 EDT
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date: Wed, 03 Jul 2013 10:14:41 +0200
From: Yann Droneaud <ydroneaud@opteya.com>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com, ydroneaud@opteya.com
Subject: Re: [PATCH] MAINTAINERS: xfs@oss.sgi.com is a list
Organization: OPTEYA
In-Reply-To: <20130703064026.GL14996@dastard>
References: <1372777248-4114-1-git-send-email-ydroneaud@opteya.com>
 <20130703064026.GL14996@dastard>
Message-ID: <c229feab100a72240128ef81297680a1@meuh.org>
User-Agent: Roundcube Webmail/0.9.2
X-abuse-contact: abuse@ocsa-data.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Le 03.07.2013 08:40, Dave Chinner a écrit :
> On Tue, Jul 02, 2013 at 05:00:47PM +0200, Yann Droneaud wrote:
>> This patch changes type of xfs@oss.sgi.com
>> 
>> The output of ./scripts/get_maintainer.pl is
>> modified to report xfs@oss.sgi.com as a list:
> 
> What's the problem with that? All XFS patches and problem
> reports should be sent to the xfs@oss.sgi.com list. There are far
> more people than just the maintainer that can triage problems,
> answer questions and review patches...
> 

It was just disturbing: I was looking for a list for XFS
and found only maintainers.
Except dm-devel, no others public mailing list is used as a maintainer.
So I thought it was a misinterpretation after following commit:

commit 18caa67ad41212e6f82a675c40f461ffb45f098e
Author: Ben Myers <bpm@sgi.com>
Date:   Thu Apr 12 17:05:05 2012 +0000

     MAINTAINERS: retire xfs-masters@oss.sgi.com

     xfs-masters@oss.sgi.com will be retired in favor of xfs@oss.sgi.com
     sometime soon.

     Signed-off-by: Ben Myers <bpm@sgi.com>
     Reviewed-by: Christoph Hellwig <hch@lst.de>

diff --git a/MAINTAINERS b/MAINTAINERS
index 2dcfca8..12b0445 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7564,7 +7564,7 @@ XFS FILESYSTEM
  P:     Silicon Graphics Inc
  M:     Ben Myers <bpm@sgi.com>
  M:     Alex Elder <elder@kernel.org>
-M:     xfs-masters@oss.sgi.com
+M:     xfs@oss.sgi.com
  L:     xfs@oss.sgi.com
  W:     http://oss.sgi.com/projects/xfs
  T:     git git://oss.sgi.com/xfs/xfs.git


Regards.

-- 
Yann Droneaud
OPTEYA

