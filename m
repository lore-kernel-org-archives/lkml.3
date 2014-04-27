Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751996AbaD0X7q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 19:59:46 -0400
Received: from lgeamrelo04.lge.com ([156.147.1.127]:59171 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751321AbaD0X7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 19:59:45 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 1/2] perf tests: Factor out fake_setup_machine()
References: <1398396494-12811-1-git-send-email-namhyung@kernel.org>
	<20140425122734.GD4116@krava.brq.redhat.com>
Date: Mon, 28 Apr 2014 08:59:42 +0900
In-Reply-To: <20140425122734.GD4116@krava.brq.redhat.com> (Jiri Olsa's message
	of "Fri, 25 Apr 2014 14:27:34 +0200")
Message-ID: <871twiqq6p.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

On Fri, 25 Apr 2014 14:27:34 +0200, Jiri Olsa wrote:
> On Fri, Apr 25, 2014 at 12:28:13PM +0900, Namhyung Kim wrote:
>> The fake_setup_machine() is for setting up a environment for testing
>> various hists operations.  As it'll be used for other test cases it'd
>> better factoring it out.
>
> looks like print_hists could be in hists_common.c as well..
> within another update ;-)

The difference is that one in hists_link.c is working on the input tree
while one in hists_filter.c is working on the output tree.

>
> nice!
>
> Acked-by: Jiri Olsa <jolsa@kernel.org>
>
> for patchset

Thanks for review!
Namhyung
