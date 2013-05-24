Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757576Ab3EXURH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 16:17:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27100 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756705Ab3EXURE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 16:17:04 -0400
Date: Fri, 24 May 2013 16:16:55 -0400
From: Dave Jones <davej@redhat.com>
To: Dave Chinner <david@fromorbit.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com
Subject: Re: XFS assertion from truncate. (3.10-rc2)
Message-ID: <20130524201655.GA23086@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Dave Chinner <david@fromorbit.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com
References: <20130522052938.GA2573@redhat.com>
 <20130522055147.GI29466@dastard>
 <20130522215454.GL29466@dastard>
 <20130523184948.GA11151@redhat.com>
 <20130523223038.GB24543@dastard>
 <20130524004906.GA21171@redhat.com>
 <20130524012625.GH24543@dastard>
 <20130524015219.GA28486@redhat.com>
 <20130524030300.GA30760@redhat.com>
 <20130524080300.GI24543@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130524080300.GI24543@dastard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 24, 2013 at 06:03:00PM +1000, Dave Chinner wrote:

 > xfstest generic/193 is *supposed* to test behaviour of suid/sgid bits
 > and clearing them is various situations.
 > 
 > You know what I'm about to say, don't you? The test doesn't test
 > what it thinks it is testing. it puts the destination file in root
 > directory of the xfstests harness, not in the filesystems being
 > tested.

awesome, two bugs for the price of one!

 > So, on all my machines, it runs on ext3 filesystems, never on the
 > ext4, btrfs, xfs, etc filesystems that I'm actually testing.
 > 
 > That's beside the point, because it doesn't test truncate behaviour.
 > But at least I know now why my attempts to reproduce the problem
 > didn't work...
 > 
 > Right, patch below should fix the problem.

Haven't seen anything out of the ordinary since I applied that,
so I'd call it good.
 
 > What a frustrating bug. Now, where's my bottle of scotch?

heh, enjoy the weekend.

	Dave

