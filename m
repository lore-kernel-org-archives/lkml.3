Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756571Ab3JNNr2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 09:47:28 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:37230 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756452Ab3JNNrY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 09:47:24 -0400
MIME-Version: 1.0
In-Reply-To: <20131014133620.GF4722@htj.dyndns.org>
References: <1381574794-7639-1-git-send-email-zhiguohong@tencent.com>
	<1381741757-20888-1-git-send-email-zhiguohong@tencent.com>
	<20131014133620.GF4722@htj.dyndns.org>
Date: Mon, 14 Oct 2013 21:47:23 +0800
Message-ID: <CAA7+ByWpRH2KSDBZ1ZRhvSSmfG2LHv+WO7F49oWLFpOTsj9cUA@mail.gmail.com>
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
BTW, what kind of setup do you expect? Is 2 levels of hierarchical enough?

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
