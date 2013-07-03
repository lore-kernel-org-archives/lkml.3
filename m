Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932719Ab3GCJyM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 05:54:12 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:34954 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932315Ab3GCJyL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 05:54:11 -0400
Message-ID: <1372845250.2048.7.camel@joe-AO722>
Subject: Re: [PATCH] MAINTAINERS: xfs@oss.sgi.com is a list
From: Joe Perches <joe@perches.com>
To: Yann Droneaud <ydroneaud@opteya.com>
Cc: Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org,
        xfs@oss.sgi.com
Date: Wed, 03 Jul 2013 02:54:10 -0700
In-Reply-To: <5e9d66217e0fa968863177d73dd492b1@meuh.org>
References: <1372777248-4114-1-git-send-email-ydroneaud@opteya.com>
	 <20130703064026.GL14996@dastard>
	 <c229feab100a72240128ef81297680a1@meuh.org>
	 <20130703092406.GM14996@dastard>
	 <5e9d66217e0fa968863177d73dd492b1@meuh.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-07-03 at 11:36 +0200, Yann Droneaud wrote:
> In the output of ./scripts/get_maintainer.pl:
> 
> Ben Myers <bpm@sgi.com> (supporter:XFS FILESYSTEM)
> Alex Elder <elder@kernel.org> (supporter:XFS FILESYSTEM)
> xfs@oss.sgi.com (supporter:XFS FILESYSTEM)
> linux-kernel@vger.kernel.org (open list)
> 
> [If having the mailing list listed as the maintainer/supporter is 
> correct,
>   could ./scripts/get_maintainer.pl also report the mailing list as a 
> list ?]

It does when you ask for just the lists...

$ ./scripts/get_maintainer.pl -f -l -nom fs/xfs
xfs@oss.sgi.com (open list:XFS FILESYSTEM)
linux-kernel@vger.kernel.org (open list)

If it bothers you that the same email address
doesn't get reported as both a maintainer and
a mailing list, you're free to submit a patch
to get_maintainer.pl. (look at sub add_role)

It doesn't bother me.

