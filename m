Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757537Ab3J1VT5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 17:19:57 -0400
Received: from mail.linux-iscsi.org ([67.23.28.174]:49082 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753571Ab3J1VT4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 17:19:56 -0400
Message-ID: <1382995746.19256.756.camel@haakon3.risingtidesystems.com>
Subject: Re: [PATCH 0/5] percpu_ida: Various tweaks
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: Kent Overstreet <kmo@daterainc.com>, Oleg Nesterov <oleg@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Date: Mon, 28 Oct 2013 14:29:06 -0700
In-Reply-To: <20131028100440.GA5744@dhcp-26-207.brq.redhat.com>
References: <20131028100440.GA5744@dhcp-26-207.brq.redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-10-28 at 11:04 +0100, Alexander Gordeev wrote:
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
> 

Hi Alexander,

So this series is atop Shaohua's conversion blk-mq patch to use
percpu_ida, right..?

I'll wait for Kent's feedback on these, and end-up dropping the
blk-mq-tag part from Patch #5 for the moment..

--nab

