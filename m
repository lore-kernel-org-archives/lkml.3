Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752700AbaDWEyA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 00:54:00 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:45853 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752375AbaDWEx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 00:53:58 -0400
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
Subject: Re: [PATCH 2/9] perf hists: Introduce hists__add_nr_events()
References: <1398156591-11001-1-git-send-email-namhyung@kernel.org>
	<1398156591-11001-3-git-send-email-namhyung@kernel.org>
	<20140422145203.GH1104@krava.brq.redhat.com>
Date: Wed, 23 Apr 2014 13:53:56 +0900
In-Reply-To: <20140422145203.GH1104@krava.brq.redhat.com> (Jiri Olsa's message
	of "Tue, 22 Apr 2014 16:52:03 +0200")
Message-ID: <87bnvssl23.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Apr 2014 16:52:03 +0200, Jiri Olsa wrote:
> On Tue, Apr 22, 2014 at 05:49:44PM +0900, Namhyung Kim wrote:
>> +static void hists__add_nr_events(struct hists *hists, u32 type, u32 val)
>> +{
>> +	__events_stats__add(&hists->stats, type, val);
>> +}
>
> adding static function with no usage breaks build..
> we dont want that, eventhough it's fixed in the next commit

Oops, my bad.  Will fix!

Thanks,
Namhyung
