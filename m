Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753958AbaIXQBl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 12:01:41 -0400
Received: from lists.s-osg.org ([54.187.51.154]:37469 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751284AbaIXQBk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 12:01:40 -0400
Message-ID: <5422EAE2.6080005@osg.samsung.com>
Date: Wed, 24 Sep 2014 10:01:38 -0600
From: Shuah Khan <shuahkh@osg.samsung.com>
Organization: Samsung Open Source Group
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
CC: LKML <linux-kernel@vger.kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Shuah Khan <shuah.kh@samsung.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        Oleg Nesterov <oleg@redhat.com>, Fengguang Wu <fengguang.wu@intel.com>,
        Ingo Molnar <mingo@kernel.org>, Shuah Khan <shuahkh@osg.samsung.com>
Subject: Re: [RFC][PATCH] ftracetest: Add a couple of ftrace test cases
References: <20140923173846.603cb49c@gandalf.local.home> <5422336A.6030304@hitachi.com> <20140924114235.4287f4a1@gandalf.local.home> <20140924115811.6eeeab8c@gandalf.local.home>
In-Reply-To: <20140924115811.6eeeab8c@gandalf.local.home>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24/2014 09:58 AM, Steven Rostedt wrote:
> On Wed, 24 Sep 2014 11:42:35 -0400
> Steven Rostedt <rostedt@goodmis.org> wrote:
> 
>>> I think you'd better use exit_unsupported/exit_xfail to notify
>>> that the test target is not configured, or expected to fail.
>>
> 
> Are these functions defined anywhere? I don't seem them in your v5
> patch set, or in selftests anywhere.
> 
> -- Steve
> 

Steve,

I am working on adding the framework for c tests. We will have
to get this evolved for shell scripts. Please see the following
thread:

https://lkml.org/lkml/2014/9/23/926

thanks,
-- Shuah

-- 
Shuah Khan
Sr. Linux Kernel Developer
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
