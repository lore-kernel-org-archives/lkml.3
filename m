Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752335Ab3KDA4Z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Nov 2013 19:56:25 -0500
Received: from intranet.asianux.com ([58.214.24.6]:10402 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979Ab3KDA4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Nov 2013 19:56:24 -0500
X-Spam-Score: -100.8
Message-ID: <5276F07B.8030302@asianux.com>
Date: Mon, 04 Nov 2013 08:55:23 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>, Jens Axboe <axboe@kernel.dk>,
        Tejun Heo <tj@kernel.org>, Jan Kara <jack@suse.cz>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel: trace: blktrace: remove redundent memcpy() in
 compat_blk_trace_setup()
References: <52765C6B.7080608@asianux.com> <20131103123647.0bae8cf6@gandalf.local.home>
In-Reply-To: <20131103123647.0bae8cf6@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/04/2013 01:36 AM, Steven Rostedt wrote:
> A quick review of this patch looks fine to me.
> 
> Although, using ARRAY_SIZE() for a character string seems to me a bit
> over paranoid. But I'm fine with it, as it makes sure that the string
> is an array and not a pointer.
> 

Yeah.

> Jens,
> 
> Can you give me an Acked-by?
> 

I am glad to.


Thanks.
-- 
Chen Gang
