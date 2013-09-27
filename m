Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753527Ab3I0Bd5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 21:33:57 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:43916 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753440Ab3I0Bd4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 21:33:56 -0400
X-AuditID: 9c930179-b7c8bae000006c65-19-5244e081332d
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: David Ahern <dsahern@gmail.com>, Sonny Rao <sonnyrao@chromium.org>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH] perf: fix infinite loop with corrupted header
References: <1380172836-13936-1-git-send-email-sonnyrao@chromium.org>
	<52443800.5080200@gmail.com>
	<20130926134640.GA26159@ghostprotocols.net>
	<1380203977.1810.0.camel@leonhard>
	<20130926140613.GB26159@ghostprotocols.net>
Date: Fri, 27 Sep 2013 10:33:53 +0900
In-Reply-To: <20130926140613.GB26159@ghostprotocols.net> (Arnaldo Carvalho de
	Melo's message of "Thu, 26 Sep 2013 11:06:13 -0300")
Message-ID: <87mwmzoxoe.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, 26 Sep 2013 11:06:13 -0300, Arnaldo Carvalho de Melo wrote:
> Em Thu, Sep 26, 2013 at 10:59:37PM +0900, Namhyung Kim escreveu:
>> 2013-09-26 (목), 10:46 -0300, Arnaldo Carvalho de Melo:
>> > Em Thu, Sep 26, 2013 at 07:34:56AM -0600, David Ahern escreveu:
>> > > Other changes went in around that time as well. Are you still seeing
>> > > the loop on latest source?
>> 
>> Did you mean this?
>
> Not at that moment, but yes, I looked up the discussion and found this,
> which I think is sensible, would like just to do some testing, and if
> you could submit a patch combining your change with David's, I think it
> would be good.

I'll resend it after some testing.

Thanks,
Namhyung
