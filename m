Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933448AbaCSBnX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 21:43:23 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:59101 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933160AbaCSBnV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 21:43:21 -0400
Message-ID: <5328F62E.3040603@gmail.com>
Date: Tue, 18 Mar 2014 19:43:10 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [RFC/PATCHSET 00/14] perf report: Add -F option for specifying
 output fields (v2)
References: <1395124359-11744-1-git-send-email-namhyung@kernel.org> <53286118.9070606@gmail.com> <CAM9d7cj8dptEDj+08G86_prE7sr85RHm4RtuNA1R6vBEQWyL5w@mail.gmail.com>
In-Reply-To: <CAM9d7cj8dptEDj+08G86_prE7sr85RHm4RtuNA1R6vBEQWyL5w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/18/14, 7:30 PM, Namhyung Kim wrote:
> Hi David,
>
> On Tue, Mar 18, 2014 at 3:07 PM, David Ahern <dsahern@gmail.com> wrote:
>> On 3/18/14, 12:32 AM, Namhyung Kim wrote:
>>>
>>> This is a patchset implementing -F/--field option to setup output
>>> field/column as Ingo requested.  It depends on my perf/percentage
>>> patchset (with minor updates) [1].
>>
>>
>> perf-report should be consistent with perf-script which uses --fields.
>
> Right.  Did you mean s/--field/--fields/ then?

yes. consistency is huge.

