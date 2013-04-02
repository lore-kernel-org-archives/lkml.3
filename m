Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932820Ab3DBQUz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 12:20:55 -0400
Received: from mail-qe0-f49.google.com ([209.85.128.49]:34479 "EHLO
	mail-qe0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932683Ab3DBQUx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 12:20:53 -0400
MIME-Version: 1.0
In-Reply-To: <20130402095353.GB4667@kernel.dk>
References: <20130402030933.GB6255@htj.dyndns.org>
	<20130402095353.GB4667@kernel.dk>
Date: Tue, 2 Apr 2013 09:20:53 -0700
X-Google-Sender-Auth: jrXdPWNFX8TYUxZCubK7oV8y7Jc
Message-ID: <CAOS58YMfDyomRpGMwmPg1mCU2t7Q0NTrLCuZjmr_YLs=XwrahQ@mail.gmail.com>
Subject: Re: [GIT PULL] writeback: convert writeback to unbound workqueue
From: Tejun Heo <tj@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: lkml <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.cz>,
        Fengguang Wu <fengguang.wu@intel.com>, Jeff Moyer <jmoyer@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Jens.

On Tue, Apr 2, 2013 at 2:53 AM, Jens Axboe <axboe@kernel.dk> wrote:
> Thanks, pulled in for testing. We'll need the debug change in before
> sending this upstream, though. I agree with Jan/Dave that this is
> required functionality, for debugging purposes.

Yeah, sure thing. The debug changes are targeting the coming merge
window but they'll have to go through -mm instead of block or
workqueue trees due to dependencies on arch changes.  So, AFAICS,
while the routing is rather complicated, things should fall in place
in the same merge window.

Thanks.

--
tejun
