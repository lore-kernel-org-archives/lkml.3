Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756897Ab3LTBV7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 20:21:59 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:54920 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756756Ab3LTBV6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 20:21:58 -0500
X-AuditID: 9c930179-b7bedae000000f15-cc-52b39bb51b76
From: Namhyung Kim <namhyung@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>
Subject: Re: [PATCHSET 0/6] perf tools: A couple of TUI improvements
References: <1387436411-20160-1-git-send-email-namhyung@kernel.org>
	<20131219133915.GE3568@krava.brq.redhat.com>
	<20131219155316.GB27508@gmail.com>
Date: Fri, 20 Dec 2013 10:21:57 +0900
In-Reply-To: <20131219155316.GB27508@gmail.com> (Ingo Molnar's message of
	"Thu, 19 Dec 2013 16:53:16 +0100")
Message-ID: <87r498e2q2.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Dec 2013 16:53:16 +0100, Ingo Molnar wrote:
> * Jiri Olsa <jolsa@redhat.com> wrote:
>
>> On Thu, Dec 19, 2013 at 04:00:05PM +0900, Namhyung Kim wrote:
>> > Hello,
>> > 
>> > I was playing with TUI code and added two new windows.  One for
>> > showing log messages and another for showing header information.
>> > (Maybe they can be implemented on the GTK code too someday.)
>> > 
>> > Please try to use it! :)
>> 
>> hi,
>> I'm sure the 'i' header display will be appreciated!
>> 
>> Any chance of searching capability in the 'l' log window?
>> mutt-like limit('l') command would be great ;-)
>
> A bit like how '/' works in histogram view, it will filter on partial 
> matches as well, making it really easy to filter down to larger 
> classes of functions (in projects that have good function name 
> namespaces).

Yes, I was thinking about that too.  Will send a patch soon.

Thanks,
Namhyung
