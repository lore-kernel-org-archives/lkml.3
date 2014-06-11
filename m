Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755767AbaFKSo4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 14:44:56 -0400
Received: from mail-ve0-f175.google.com ([209.85.128.175]:57120 "EHLO
	mail-ve0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753265AbaFKSox (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 14:44:53 -0400
MIME-Version: 1.0
In-Reply-To: <CALAqxLUsn3Fu-fx2j+pzcK+FsV53qsgV6sEkX3TV+trgB6MZGA@mail.gmail.com>
References: <1401982261-11246-1-git-send-email-trond.myklebust@primarydata.com>
	<CALAqxLUsn3Fu-fx2j+pzcK+FsV53qsgV6sEkX3TV+trgB6MZGA@mail.gmail.com>
Date: Wed, 11 Jun 2014 11:44:51 -0700
Message-ID: <CALAqxLWGdR3=ZmwuN=8PCc37i88mjix5D1=ANEhDmdgBk9O9hw@mail.gmail.com>
Subject: Re: [PATCH] Revert lockdep check in raw_seqcount_begin
From: John Stultz <john.stultz@linaro.org>
To: Trond Myklebust <trond.myklebust@primarydata.com>
Cc: Peter Zijlstra <peterz@infradead.org>, lkml <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 11, 2014 at 11:39 AM, John Stultz <john.stultz@linaro.org> wrote:
> Just back from vacation, sorry for the slow response. Thanks for
> submitting this! Also sorry for my confusion mixing
> raw_seqcount_begin() and raw_seqlock_begin() in our earlier discussion

Bah. Not raw_seqlock_begin.. I meant raw_read_seqcount_begin().
-john
