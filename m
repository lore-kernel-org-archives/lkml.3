Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754377Ab3F0Xpc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 19:45:32 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:33590 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754302Ab3F0Xp2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 19:45:28 -0400
Date: Thu, 27 Jun 2013 19:45:21 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Dave Chinner <david@fromorbit.com>, Al Viro <viro@zeniv.linux.org.uk>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        tux3@tux3.org
Subject: Re: [PATCH] Optimize wait_sb_inodes()
Message-ID: <20130627234521.GC22832@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Dave Chinner <david@fromorbit.com>,
	Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, tux3@tux3.org
References: <20130626231143.GC28426@dastard>
 <87wqpg76ls.fsf@devron.myhome.or.jp>
 <20130627044705.GB29790@dastard>
 <87y59w5dye.fsf@devron.myhome.or.jp>
 <20130627063816.GD29790@dastard>
 <87ppv83tnn.fsf@devron.myhome.or.jp>
 <20130627094042.GZ29338@dastard>
 <87mwqb3m1e.fsf@devron.myhome.or.jp>
 <20130627183631.GB22832@thunk.org>
 <871u7nrupn.fsf@devron.myhome.or.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <871u7nrupn.fsf@devron.myhome.or.jp>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 28, 2013 at 08:37:40AM +0900, OGAWA Hirofumi wrote:
> 
> Well, anyway, it is simple. This issue was came as the performance
> regression when I was experimenting to use kernel bdi flusher from own
> flusher. The issue was sync(2) like I said.  And this was just I
> couldn't solve this issue by tux3 side unlike other optimizations.

A performance regression using fsstress?  That's not a program
intended to be a useful benchmark for measuring performance.

	       	 		      - Ted
