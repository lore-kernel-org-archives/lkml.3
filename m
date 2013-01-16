Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758985Ab3APKdz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 05:33:55 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:62703 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758727Ab3APKdx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 05:33:53 -0500
X-AuditID: 9c930179-b7b54ae000000e44-f0-50f682101d78
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Stephane Eranian <eranian@google.com>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCHSET 00/13] perf report: Add support for event group view (v8)
References: <1358235117-12803-1-git-send-email-namhyung@kernel.org>
	<20130115183858.GF5826@ghostprotocols.net>
Date: Wed, 16 Jan 2013 19:33:52 +0900
In-Reply-To: <20130115183858.GF5826@ghostprotocols.net> (Arnaldo Carvalho de
	Melo's message of "Tue, 15 Jan 2013 15:38:58 -0300")
Message-ID: <87622xmn73.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Jan 2013 15:38:58 -0300, Arnaldo Carvalho de Melo wrote:
> Em Tue, Jan 15, 2013 at 04:31:44PM +0900, Namhyung Kim escreveu:
>> This is my 8th attempt to enable the event group view for perf report.
>> For basic idea and usage example, please see my initial post [1].
>> 
>> This version is rebased on the current acme/perf/core and it's mainly
>> changed due to a refactoring of gtk browser.
>> 
>> You can get this via 'perf/group-v8' branch on my tree:
>> 
>> git://git.kernel.org/pub/scm/linux/kernel/git/namhyung/linux-perf.git
>> 
>> Any comments are welcome, thanks,
>
> It would be great if examples of this in use were provided.
>
> Detailed ones at that, showing how things were in the past, how the info
> can be retrieved when using 'perf report --stdio', perhaps 'perf evlist'
> can show the stored group information too, how the 'perf report' output
> looks like when showing group info, things like that.

I think most of aforementioned things were on the initial post.  I
thought it's too verbose to be contained to the cover letter every time
so I just put the link.

But I'll include it next time and work on the perf evlist too.

Thanks,
Namhyung
