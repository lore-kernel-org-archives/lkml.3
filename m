Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751630AbaIYAfO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 20:35:14 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:37734 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272AbaIYAfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 20:35:12 -0400
Message-ID: <54236339.7060506@hitachi.com>
Date: Thu, 25 Sep 2014 09:35:05 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Shuah Khan <shuah.kh@samsung.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        Oleg Nesterov <oleg@redhat.com>, Fengguang Wu <fengguang.wu@intel.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: Re: [RFC][PATCH] ftracetest: Add a couple of ftrace test cases
References: <20140923173846.603cb49c@gandalf.local.home> <5422336A.6030304@hitachi.com> <20140924114235.4287f4a1@gandalf.local.home> <20140924115811.6eeeab8c@gandalf.local.home>
In-Reply-To: <20140924115811.6eeeab8c@gandalf.local.home>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/09/25 0:58), Steven Rostedt wrote:
> On Wed, 24 Sep 2014 11:42:35 -0400
> Steven Rostedt <rostedt@goodmis.org> wrote:
> 
>>> I think you'd better use exit_unsupported/exit_xfail to notify
>>> that the test target is not configured, or expected to fail.
>>
> 
> Are these functions defined anywhere? I don't seem them in your v5
> patch set, or in selftests anywhere.

Hmm, could you check my 4/4 patch in the series??
http://www.mail-archive.com/linux-kernel@vger.kernel.org/msg730578.html

Thanks,

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


