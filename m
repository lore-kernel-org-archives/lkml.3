Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758835AbaCSBbM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 21:31:12 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:37479 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757980AbaCSBbK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 21:31:10 -0400
MIME-Version: 1.0
In-Reply-To: <53286118.9070606@gmail.com>
References: <1395124359-11744-1-git-send-email-namhyung@kernel.org> <53286118.9070606@gmail.com>
From: Namhyung Kim <namhyung@kernel.org>
Date: Wed, 19 Mar 2014 01:30:49 +0000
X-Google-Sender-Auth: GqCI4Y0kStoLLjh7SBb8cpxcWfo
Message-ID: <CAM9d7cj8dptEDj+08G86_prE7sr85RHm4RtuNA1R6vBEQWyL5w@mail.gmail.com>
Subject: Re: [RFC/PATCHSET 00/14] perf report: Add -F option for specifying
 output fields (v2)
To: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Andi Kleen <andi@firstfloor.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On Tue, Mar 18, 2014 at 3:07 PM, David Ahern <dsahern@gmail.com> wrote:
> On 3/18/14, 12:32 AM, Namhyung Kim wrote:
>>
>> This is a patchset implementing -F/--field option to setup output
>> field/column as Ingo requested.  It depends on my perf/percentage
>> patchset (with minor updates) [1].
>
>
> perf-report should be consistent with perf-script which uses --fields.

Right.  Did you mean s/--field/--fields/ then?

Thanks,
Namhyung
