Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751945AbaFFGbU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 02:31:20 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:51366 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751898AbaFFGbT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 02:31:19 -0400
X-AuditID: 85900ec0-d1328b9000001514-8d-53916033df37
Message-ID: <53916033.1040908@hitachi.com>
Date: Fri, 06 Jun 2014 15:31:15 +0900
From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120604 Thunderbird/13.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org,
        Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ingo Molnar <mingo@redhat.com>, yrl.pp-manager.tt@hitachi.com
Subject: Re: [PATCH ftrace/core] tracing: Remove return value in event_trace_self_tests()
 when top_trace_array() returns NULL
References: <20140605234623.484afaf8@gandalf.local.home> <20140606062844.7955.61919.stgit@yunodevel>
In-Reply-To: <20140606062844.7955.61919.stgit@yunodevel>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven,

Thank you for applying my patches.
I received build warning report from kbuild test bot,
so I fixed it. Would you apply this patch?

Thank you,
Yoshihiro YUNOMAE

(2014/06/06 15:28), Yoshihiro YUNOMAE wrote:
> Remove return value in event_trace_self_tests() when top_trace_array() returns
> NULL because event_trace_self_tests() is void type.
>
> Signed-off-by: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: linux-kernel@vger.kernel.org
> ---
>   kernel/trace/trace_events.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
> index 1349870..f99e0b3 100644
> --- a/kernel/trace/trace_events.c
> +++ b/kernel/trace/trace_events.c
> @@ -2547,7 +2547,7 @@ static __init void event_trace_self_tests(void)
>
>   	tr = top_trace_array();
>   	if (!tr)
> -		return -ENODEV;
> +		return;
>
>   	pr_info("Running tests on trace events:\n");
>
>
>

-- 
Yoshihiro YUNOMAE
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: yoshihiro.yunomae.ez@hitachi.com


