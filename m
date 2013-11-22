Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932110Ab3KVXNs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 18:13:48 -0500
Received: from mail-pb0-f49.google.com ([209.85.160.49]:53424 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756299Ab3KVXNn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 18:13:43 -0500
MIME-Version: 1.0
In-Reply-To: <20131114115618.GB30824@redhat.com>
References: <OFC3933D9B.5510E97E-ON48257C23.0007B7CD-48257C23.000A4246@zte.com.cn>
	<20131114052326.GA29031@mtj.dyndns.org>
	<20131114114039.GA29277@redhat.com>
	<20131114115551.GA30824@redhat.com>
	<20131114115618.GB30824@redhat.com>
Date: Fri, 22 Nov 2013 18:13:43 -0500
X-Google-Sender-Auth: 9BqpAHRwlfypZ31S29b1hEOatfM
Message-ID: <CAOS58YO_pZzBB+T6FEzNqfZv4_UUQ_QF1n1zxy4u+H_KhW-vJQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] workqueue: swap set_cpus_allowed_ptr() and PF_NO_SETAFFINITY
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: zhang.yi20@zte.com.cn, lkml <linux-kernel@vger.kernel.org>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 14, 2013 at 6:56 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> Move the setting of PF_NO_SETAFFINITY up before set_cpus_allowed()
> in create_worker(). Otherwise userland can change ->cpus_allowed
> in between.
>
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Applied to wq/for-3.13-fixes.

Thanks!

-- 
tejun
