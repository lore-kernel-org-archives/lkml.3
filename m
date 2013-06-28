Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754547Ab3F1Aa0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 20:30:26 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:48002 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754505Ab3F1AaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 20:30:21 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Dave Chinner <david@fromorbit.com>, Al Viro <viro@zeniv.linux.org.uk>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        tux3@tux3.org
Subject: Re: [PATCH] Optimize wait_sb_inodes()
References: <20130626231143.GC28426@dastard>
	<87wqpg76ls.fsf@devron.myhome.or.jp> <20130627044705.GB29790@dastard>
	<87y59w5dye.fsf@devron.myhome.or.jp> <20130627063816.GD29790@dastard>
	<87ppv83tnn.fsf@devron.myhome.or.jp> <20130627094042.GZ29338@dastard>
	<87mwqb3m1e.fsf@devron.myhome.or.jp>
	<20130627183631.GB22832@thunk.org>
	<871u7nrupn.fsf@devron.myhome.or.jp>
	<20130627234521.GC22832@thunk.org>
Date: Fri, 28 Jun 2013 09:30:17 +0900
In-Reply-To: <20130627234521.GC22832@thunk.org> (Theodore Ts'o's message of
	"Thu, 27 Jun 2013 19:45:21 -0400")
Message-ID: <87hagjqdpi.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Ts'o <tytso@mit.edu> writes:

> On Fri, Jun 28, 2013 at 08:37:40AM +0900, OGAWA Hirofumi wrote:
>> 
>> Well, anyway, it is simple. This issue was came as the performance
>> regression when I was experimenting to use kernel bdi flusher from own
>> flusher. The issue was sync(2) like I said.  And this was just I
>> couldn't solve this issue by tux3 side unlike other optimizations.
>
> A performance regression using fsstress?  That's not a program
> intended to be a useful benchmark for measuring performance.

Right. fsstress is used as stress tool for me too as part of CI, with
background vmstat 1. Anyway, it is why I noticed this.

I agree it would not be high priority. But I don't think we should stop
to optimize it.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
