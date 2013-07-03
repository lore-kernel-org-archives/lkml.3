Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932599Ab3GCJgn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 05:36:43 -0400
Received: from mx-out.ocsa-data.net ([194.36.166.37]:51192 "EHLO
	mx-out.ocsa-data.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932221Ab3GCJgm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 05:36:42 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date: Wed, 03 Jul 2013 11:36:39 +0200
From: Yann Droneaud <ydroneaud@opteya.com>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com, ydroneaud@opteya.com
Subject: Re: [PATCH] MAINTAINERS: xfs@oss.sgi.com is a list
Organization: OPTEYA
In-Reply-To: <20130703092406.GM14996@dastard>
References: <1372777248-4114-1-git-send-email-ydroneaud@opteya.com>
 <20130703064026.GL14996@dastard> <c229feab100a72240128ef81297680a1@meuh.org>
 <20130703092406.GM14996@dastard>
Message-ID: <5e9d66217e0fa968863177d73dd492b1@meuh.org>
User-Agent: Roundcube Webmail/0.9.2
X-abuse-contact: abuse@ocsa-data.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 03.07.2013 11:24, Dave Chinner a écrit :
> On Wed, Jul 03, 2013 at 10:14:41AM +0200, Yann Droneaud wrote:
>> Le 03.07.2013 08:40, Dave Chinner a écrit :
>> >On Tue, Jul 02, 2013 at 05:00:47PM +0200, Yann Droneaud wrote:
>> >>This patch changes type of xfs@oss.sgi.com
>> >>
>> >>The output of ./scripts/get_maintainer.pl is
>> >>modified to report xfs@oss.sgi.com as a list:
>> >
>> >What's the problem with that? All XFS patches and problem
>> >reports should be sent to the xfs@oss.sgi.com list. There are far
>> >more people than just the maintainer that can triage problems,
>> >answer questions and review patches...
>> >
>> 
>> It was just disturbing: I was looking for a list for XFS
>> and found only maintainers.
> 
> That's what the:
> 
> L:      xfs@oss.sgi.com
> 
> entry is, yes?
> 

In the output of ./scripts/get_maintainer.pl:

Ben Myers <bpm@sgi.com> (supporter:XFS FILESYSTEM)
Alex Elder <elder@kernel.org> (supporter:XFS FILESYSTEM)
xfs@oss.sgi.com (supporter:XFS FILESYSTEM)
linux-kernel@vger.kernel.org (open list)

[If having the mailing list listed as the maintainer/supporter is 
correct,
  could ./scripts/get_maintainer.pl also report the mailing list as a 
list ?]

Regards.

-- 
Yann Droneaud
OPTEYA

