Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757010Ab3HLP1K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 11:27:10 -0400
Received: from mail-ve0-f177.google.com ([209.85.128.177]:56863 "EHLO
	mail-ve0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753482Ab3HLP1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 11:27:05 -0400
Message-ID: <5208FEC1.7010206@opersys.com>
Date: Mon, 12 Aug 2013 12:26:57 -0300
From: Karim Yaghmour <karim.yaghmour@opersys.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804 Thunderbird/17.0.8
MIME-Version: 1.0
To: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
CC: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        mingo@elte.hu
Subject: Re: Reading perf counters at ftrace trace boundaries
References: <5208263D.2080205@opersys.com> <52084774.7010009@huawei.com>
In-Reply-To: <52084774.7010009@huawei.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 13-08-11 11:24 PM, zhangwei(Jovi) wrote:
> If you want to base on ftrace, below two approach maybe take into use:
> 
> - register_ftrace_function/unregister_ftrace_function
> 
> - perf_event_create_kernel_counter (function event id is 1)
> 
> the first one is simplest, IMO.

Thx for the pointers.

> You need to write your own kernel module to use these approach.

As a proof-of-concept, sure. For something more permanent it would make
more sense to adapt the various perf/ftrace tools to make this available
on the command line with other options. But we're far away from that for
the moment.

-- 
Karim Yaghmour
CEO - Opersys inc. / www.opersys.com
http://twitter.com/karimyaghmour

