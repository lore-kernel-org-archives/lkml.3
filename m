Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752054Ab3FZO1x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 10:27:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30359 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751212Ab3FZO1w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 10:27:52 -0400
Date: Wed, 26 Jun 2013 10:27:40 -0400
From: Dave Jones <davej@redhat.com>
To: Jan Kara <jack@suse.cz>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [3.10-rc6] soft lockups from sync()
Message-ID: <20130626142739.GA23429@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, Jan Kara <jack@suse.cz>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
References: <20130617142611.GA16732@redhat.com>
 <20130626134915.GA14102@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130626134915.GA14102@quack.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 26, 2013 at 03:49:15PM +0200, Jan Kara wrote:
 > On Mon 17-06-13 10:26:11, Dave Jones wrote:
 > > Haven't seen this happen before..  3.10-rc6 + a bunch of patches to
 > > survive other trinity induced bugs + some debug 'helpers' (the
 > > loadavg-at-oops for eg), but nothing that should be responsible for this.
 >   Hum, we are spinning on inode_sb_list_lock. I'm not aware of any recent
 > changes in that area. Is this reproducible? Has anything changed with
 > trinity so that it could start triggering this? Maybe using lockstat we
 > could see who are the worst offenders using the lock...

The biggest change is that I got two new test machines (that I'm seeing this on).
They're both quad core haswell machines, so a lot faster than the previous
machines I've been running trinity on.

	Dave

