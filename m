Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752066AbaAPB6N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 20:58:13 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:46613 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751336AbaAPB6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 20:58:11 -0500
X-AuditID: 9c930179-b7c84ae000000e38-17-52d73cad4562
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Namhyung Kim <namhyung.kim@lge.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH 06/17] tools lib traceevent: Add pevent_unregister_event_handler()
References: <1389750340-15965-1-git-send-email-namhyung@kernel.org>
	<1389750340-15965-7-git-send-email-namhyung@kernel.org>
	<20140115111839.73d85422@gandalf.local.home>
	<52D7211C.9030903@lge.com>
	<20140115205259.017a644f@gandalf.local.home>
Date: Thu, 16 Jan 2014 10:58:05 +0900
In-Reply-To: <20140115205259.017a644f@gandalf.local.home> (Steven Rostedt's
	message of "Wed, 15 Jan 2014 20:52:59 -0500")
Message-ID: <87y52g7knm.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Jan 2014 20:52:59 -0500, Steven Rostedt wrote:
> On Thu, 16 Jan 2014 09:00:28 +0900
> Namhyung Kim <namhyung.kim@lge.com> wrote:
>
>> Hi Steve,
>> 
>> 2014-01-16 AM 1:18, Steven Rostedt wrote:
>> > On Wed, 15 Jan 2014 10:45:29 +0900
>> > Namhyung Kim <namhyung@kernel.org> wrote:
>> >> +	if (event->handler == func && event->context == context) {
>> >> +		pr_stat("overriding event (%d) %s:%s with default print handler",
>> >
>> > Should we use the word "overriding" again? Perhaps saying:
>> >
>> > "removing override print handler (%d) %s:%s. Going back to default handler."
>> >
>> > Or something?
>> 
>> What about this:
>> 
>> "removing override handler for event (%d) %s:%s. Going back to default 
>> handler."
>> 
>
> Sounds good.

Thanks, can I add your ack with this change?

Namhyung
