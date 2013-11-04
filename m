Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751781Ab3KDAwy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Nov 2013 19:52:54 -0500
Received: from intranet.asianux.com ([58.214.24.6]:7625 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979Ab3KDAwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Nov 2013 19:52:53 -0500
X-Spam-Score: -100.8
Message-ID: <5276EFA2.7060501@asianux.com>
Date: Mon, 04 Nov 2013 08:51:46 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Jens Axboe <axboe@kernel.dk>, Frederic Weisbecker <fweisbec@gmail.com>,
        Tejun Heo <tj@kernel.org>, Jan Kara <jack@suse.cz>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel: trace: blktrace: remove redundent memcpy() in
 compat_blk_trace_setup()
References: <52765C6B.7080608@asianux.com> <20131103123647.0bae8cf6@gandalf.local.home> <20131103181639.GA14163@kernel.dk> <20131103151500.2a612ac8@gandalf.local.home>
In-Reply-To: <20131103151500.2a612ac8@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/04/2013 04:15 AM, Steven Rostedt wrote:
> On Sun, 3 Nov 2013 11:16:39 -0700
> Jens Axboe <axboe@kernel.dk> wrote:
> 
>> Thanks, but I'll just queue it up with the other block bits for 3.13.
>>
> 
> OK,
> 

Thank all of you. :-)
-- 
Chen Gang
