Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751519AbaL0FXY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2014 00:23:24 -0500
Received: from mail-ob0-f171.google.com ([209.85.214.171]:52894 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838AbaL0FXX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2014 00:23:23 -0500
MIME-Version: 1.0
In-Reply-To: <20141226140234.GB20929@krava.redhat.com>
References: <1419405333-27952-1-git-send-email-namhyung@kernel.org> <20141226140234.GB20929@krava.redhat.com>
From: Namhyung Kim <namhyung@kernel.org>
Date: Sat, 27 Dec 2014 14:23:02 +0900
X-Google-Sender-Auth: vdGdbijuexeLIqvf1OF5OTE5RCE
Message-ID: <CAM9d7chwgcXxm8D_B=dU80+gJw-sv5JeJHLucFWigQ_CY1QC=g@mail.gmail.com>
Subject: Re: [RFC/PATCHSET 00/37] perf tools: Speed-up perf report by using
 multi thread (v1)
To: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Stephane Eranian <eranian@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <andi@firstfloor.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 26, 2014 at 11:02 PM, Jiri Olsa <jolsa@redhat.com> wrote:
> On Wed, Dec 24, 2014 at 04:14:56PM +0900, Namhyung Kim wrote:
>
> SNIP
>
>>
>>
>> You can get it from 'perf/threaded-v1' branch on my tree at:
>>
>>   git://git.kernel.org/pub/scm/linux/kernel/git/namhyung/linux-perf.git
>>
>> Please take a look and play with it.  Any comments are welcome! :)
>
> very nice at first round check ;-)
>
> I'll do detailed review next week

Thank you very much!
Namhyung
