Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756369Ab3JNNx5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 09:53:57 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:51345 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793Ab3JNNxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 09:53:55 -0400
MIME-Version: 1.0
In-Reply-To: <20131014133620.GF4722@htj.dyndns.org>
References: <1381574794-7639-1-git-send-email-zhiguohong@tencent.com>
	<1381741757-20888-1-git-send-email-zhiguohong@tencent.com>
	<20131014133620.GF4722@htj.dyndns.org>
Date: Mon, 14 Oct 2013 21:53:54 +0800
Message-ID: <CAA7+ByWPM2Pizm+dP1AxPM7Ut-w=AtRfD2GkCK-0OVh+C2Twkg@mail.gmail.com>
Subject: Re: [PATCH v2] blk-throttle: simplify logic by token bucket algorithm
From: Hong zhi guo <honkiko@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, vgoyal@redhat.com, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, Hong Zhiguo <zhiguohong@tencent.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Tejun,

I've not tested hierarchical setup yet. I'll do it tomorrow.
BTW, what kind of setup do you expect? Is hierarchy of 2 levels enough?

Zhiguo

On Mon, Oct 14, 2013 at 9:36 PM, Tejun Heo <tj@kernel.org> wrote:
> Hello,
>
> Yes, this definitely is the direction we wanna take it.  I'll wait for
> Vivek to chime in but have you also tested hierarchical setup?
>
> Thanks.
>
> --
> tejun



-- 
best regards
Hong Zhiguo
