Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752403AbaDYH6a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 03:58:30 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:55536 "EHLO
	lgemrelse7q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752105AbaDYH61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 03:58:27 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Don Zickus <dzickus@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCHSET 00/17] perf report: Add -F option for specifying output fields (v4)
References: <1397617554-26319-1-git-send-email-namhyung@kernel.org>
	<20140422211647.GO8488@redhat.com> <87lhuwr2pk.fsf@sejong.aot.lge.com>
	<20140423125828.GL5328@redhat.com> <1398346899.1681.18.camel@leonhard>
	<20140424210015.GJ8488@redhat.com>
Date: Fri, 25 Apr 2014 16:58:25 +0900
In-Reply-To: <20140424210015.GJ8488@redhat.com> (Don Zickus's message of "Thu,
	24 Apr 2014 17:00:15 -0400")
Message-ID: <87d2g5rgbi.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Don,

On Thu, 24 Apr 2014 17:00:15 -0400, Don Zickus wrote:
> On Thu, Apr 24, 2014 at 10:41:39PM +0900, Namhyung Kim wrote:
>> Hmm.. it seems that it's exactly sorted by the data symbol addresses, so
>> I don't see any problem here.  What did you expect?  If you want to see
>> those symbol_daddr,pid pair to be sorted by overhead, you can use the
>> one of -F or -s option only.
>
> Good question.  I guess I was hoping to see things sorted by overhead, but
> as you said removing all the -F options gives me that.  I have been
> distracted with other fires this week, I lost focus at what I was trying
> to accomplish.
>
> Let me figure that out again and try to come up with a more clear email
> explaining what I was looking for (for myself at least :-) ).
>
> Sorry for the distraction.

No need to sorry and thank you for testing and feedbacks :)

Thanks,
Namhyung
