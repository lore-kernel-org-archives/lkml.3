Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757594Ab3J1VX5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 17:23:57 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:38847 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753571Ab3J1VX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 17:23:56 -0400
Date: Mon, 28 Oct 2013 14:23:52 -0700
From: Kent Overstreet <kmo@daterainc.com>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] percpu_ida: Various tweaks
Message-ID: <20131028212352.GH8153@kmo>
References: <20131028100440.GA5744@dhcp-26-207.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131028100440.GA5744@dhcp-26-207.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 28, 2013 at 11:04:44AM +0100, Alexander Gordeev wrote:
> Hi Kent,
> 
> Here is an update of few behaviours which caught my eye.
> I have not tested any, so it is up to your judgement ;)
> 
> Alexander Gordeev (5):
>   percpu_ida: Fix data race on cpus_have_tags cpumask
>   percpu_ida: Move waking up waiters out of atomic contexts
>   percpu_ida: Optimize freeing tags when maximum cache size is 1
>   percpu_ida: Sanity check initialization parameters
>   percpu_ida: Allow variable maximum number of cached tags
> 
>  block/blk-mq-tag.c         |    9 +++++----
>  include/linux/percpu_ida.h |    5 +++--
>  lib/percpu_ida.c           |   38 ++++++++++++++++++++++++++++----------
>  3 files changed, 36 insertions(+), 16 deletions(-)

What tree is this series based on? Patch 3 is based on something not in
mainline.
