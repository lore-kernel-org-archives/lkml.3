Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752339AbaAPAAc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 19:00:32 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:64450 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751694AbaAPAAb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 19:00:31 -0500
X-AuditID: 9c93016f-b7b1aae000000f15-b3-52d7211ca0f3
Message-ID: <52D7211C.9030903@lge.com>
Date: Thu, 16 Jan 2014 09:00:28 +0900
From: Namhyung Kim <namhyung.kim@lge.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH 06/17] tools lib traceevent: Add pevent_unregister_event_handler()
References: <1389750340-15965-1-git-send-email-namhyung@kernel.org> <1389750340-15965-7-git-send-email-namhyung@kernel.org> <20140115111839.73d85422@gandalf.local.home>
In-Reply-To: <20140115111839.73d85422@gandalf.local.home>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steve,

2014-01-16 AM 1:18, Steven Rostedt wrote:
> On Wed, 15 Jan 2014 10:45:29 +0900
> Namhyung Kim <namhyung@kernel.org> wrote:
>> +	if (event->handler == func && event->context == context) {
>> +		pr_stat("overriding event (%d) %s:%s with default print handler",
>
> Should we use the word "overriding" again? Perhaps saying:
>
> "removing override print handler (%d) %s:%s. Going back to default handler."
>
> Or something?

What about this:

"removing override handler for event (%d) %s:%s. Going back to default 
handler."

Thanks,
Namhyung

