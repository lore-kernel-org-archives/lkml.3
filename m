Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755864Ab3GCKHm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 06:07:42 -0400
Received: from mx-out.ocsa-data.net ([194.36.166.37]:58478 "EHLO
	mx-out.ocsa-data.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753038Ab3GCKHl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 06:07:41 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date: Wed, 03 Jul 2013 12:07:40 +0200
From: Yann Droneaud <ydroneaud@opteya.com>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com, ydroneaud@opteya.com
Subject: Re: [PATCH] MAINTAINERS: xfs@oss.sgi.com is a list
Organization: OPTEYA
Message-ID: <ea519baa117add8c12bbe65f77708a4d@meuh.org>
User-Agent: Roundcube Webmail/0.9.2
X-abuse-contact: abuse@ocsa-data.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 03.07.2013 11:50, Dave Chinner a écrit :
> On Wed, Jul 03, 2013 at 11:36:39AM +0200, Yann Droneaud wrote:
>> Le 03.07.2013 11:24, Dave Chinner a écrit :
>> >On Wed, Jul 03, 2013 at 10:14:41AM +0200, Yann Droneaud wrote:
>> >>Le 03.07.2013 08:40, Dave Chinner a écrit :
>> >>>On Tue, Jul 02, 2013 at 05:00:47PM +0200, Yann Droneaud wrote:
>> >>>>This patch changes type of xfs@oss.sgi.com
>> >>>>
>> >>>>The output of ./scripts/get_maintainer.pl is
>> >>>>modified to report xfs@oss.sgi.com as a list:
>> >>>
>> >>>What's the problem with that? All XFS patches and problem
>> >>>reports should be sent to the xfs@oss.sgi.com list. There are far
>> >>>more people than just the maintainer that can triage problems,
>> >>>answer questions and review patches...
>> >>>
>> >>
>> >>It was just disturbing: I was looking for a list for XFS
>> >>and found only maintainers.
>> >
>> >That's what the:
>> >
>> >L:      xfs@oss.sgi.com
>> >
>> >entry is, yes?
>> >
>> 
>> In the output of ./scripts/get_maintainer.pl:
>> 
>> Ben Myers <bpm@sgi.com> (supporter:XFS FILESYSTEM)
>> Alex Elder <elder@kernel.org> (supporter:XFS FILESYSTEM)
>> xfs@oss.sgi.com (supporter:XFS FILESYSTEM)
>> linux-kernel@vger.kernel.org (open list)
> 
> You're smarter than a dumb script. If the information that the
> script parses is correct and the dumb script doesn't give you the
> right information, then what needs fixing?
> 

And what about:

   If you are the only one[*] to abuse ./scripts/get_maintainer.pl,
   then what needs fixing ?

[*] I have found three other examples of duplicating mailing list as 
maintainer:

$ sed -n 's/^L:[[:space:]]*//p' MAINTAINERS | sort | uniq > L
$ sed -n 's/^M:[[:space:]]*//p' MAINTAINERS | sort | uniq > M
$ comm -12 L M
ceph-devel@vger.kernel.org
dm-devel@redhat.com
xfs@oss.sgi.com

I've sent a patch for xfs@oss.sgi.com and dm-devel@redhat.com,
in my first pass I've missed ceph-devel@vger.kernel.org

> Seriously, all you are proving is the old adage that
> scripts/get_maintainer.pl should be considered harmful because
> people use it without first engaging their brain.

Just thinking about the whole picture.
In this case ./scripts/get_maintainer.pl is going to be right most of 
time
except for 3 subsystems on about 1160. So having the same address for 
maintainer
and list is a rather uncommon case. Which could be misleading for most.

Regards.

-- 
Yann Droneaud
OPTEYA

