Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754484AbaBDQqk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 11:46:40 -0500
Received: from mail-vc0-f175.google.com ([209.85.220.175]:51643 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751333AbaBDQqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 11:46:35 -0500
MIME-Version: 1.0
In-Reply-To: <CAFrcx1nKFffXtW4T-eDjsbXbCH-sW1DW1_fQt8fGbWBxRPRmZg@mail.gmail.com>
References: <1389098853-14466-1-git-send-email-jolsa@redhat.com>
	<20140117122431.GC1130@krava.brq.redhat.com>
	<CAFrcx1nadiFDq1hyha83Y9GEJmKvXDeW-+7mLA+zj3jE9H5iWA@mail.gmail.com>
	<20140128130408.GF1229@krava.brq.redhat.com>
	<CAFrcx1nKFffXtW4T-eDjsbXbCH-sW1DW1_fQt8fGbWBxRPRmZg@mail.gmail.com>
Date: Tue, 4 Feb 2014 17:46:34 +0100
Message-ID: <CAFrcx1m0e7QCqffVbCQDJMt5GY8KdNt9Ay42AVMG2Q2YYggBRA@mail.gmail.com>
Subject: Re: [PATCH 00/16] perf tools: Add libdw DWARF unwind support
From: Jean Pihet <jean.pihet@linaro.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        David Ahern <dsahern@gmail.com>,
        Jan Kratochvil <jan.kratochvil@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

On 28 January 2014 17:46, Jean Pihet <jean.pihet@linaro.org> wrote:
> Hi Jiri,
>
> On 28 January 2014 14:04, Jiri Olsa <jolsa@redhat.com> wrote:
>> On Fri, Jan 17, 2014 at 01:27:53PM +0100, Jean Pihet wrote:
>>> Hi Jiri,
>>>
>>> Let me start on it next week. Is that OK?
>>>
>>> Thx for the reminder, I had not entirely forgotten it though ;p
>> hi,
>> rebased patchset to latest acme's perf/core is in:
>>   https://git.kernel.org/cgit/linux/kernel/git/jolsa/perf.git/
>>   perf/core_libdw_unwind
> Great, that was needed.
>
>> aaand ping ;-)
> I checked that the build still works ok on ARM. I am now trying with libdw.
> I can give an Ack as soon as that is done, then implement the ARM specific code.

The build with and without libunwind and libdw has been tested
succesfully on ARM, including the paths to the desired libraries.
Of course I am getting a link error on
'libdw__arch_set_initial_registers' because the ARM support is not yet
in.

Here is an ack on the series:
Acked-by: Jean Pihet <jean.pihet@linaro.org>

Next on my plate: implement the ARM specifics.

Thanks!
Jean

>
>>
>> thanks,
>> jirka
