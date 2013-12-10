Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751467Ab3LJAeg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 19:34:36 -0500
Received: from lgeamrelo02.lge.com ([156.147.1.126]:58123 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065Ab3LJAef (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 19:34:35 -0500
X-AuditID: 9c93017e-b7bb9ae000000ec8-50-52a66197eb43
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCHSET 00/14] tools lib traceevent: Get rid of *die() calls from parse-filter.c
References: <1386567251-22751-1-git-send-email-namhyung@kernel.org>
	<20131209112449.47eeedaa@gandalf.local.home>
	<20131209184119.GD8098@ghostprotocols.net>
Date: Tue, 10 Dec 2013 09:34:31 +0900
In-Reply-To: <20131209184119.GD8098@ghostprotocols.net> (Arnaldo Carvalho de
	Melo's message of "Mon, 9 Dec 2013 15:41:19 -0300")
Message-ID: <87haahlf1k.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnaldo,

On Mon, 9 Dec 2013 15:41:19 -0300, Arnaldo Carvalho de Melo wrote:
> Em Mon, Dec 09, 2013 at 11:24:49AM -0500, Steven Rostedt escreveu:
>> On Mon,  9 Dec 2013 14:33:57 +0900 Namhyung Kim <namhyung@kernel.org> wrote:
>> > This patchset tries to remove all die() calls in event filter parsing
>> > code.  The only remaining bits are in trace-seq.c which implement
>> > print functions and I want to hear what's the best way we can handle
>> > the error case during the print.
>
>> Other than what I commented on, the rest can have my:
>> Reviewed-by: Steven Rostedt <rostedt@goodmis.org>
>
> Added this to all the ones I applied, Namhyung, please address the other
> concerns and check which ones were not applied so that you can have them
> in your next request.

Okay, will do!

Thanks,
Namhyung
