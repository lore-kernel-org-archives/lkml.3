Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758894AbaCSBs4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 21:48:56 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:50628 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758874AbaCSBsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 21:48:55 -0400
MIME-Version: 1.0
In-Reply-To: <5328F62E.3040603@gmail.com>
References: <1395124359-11744-1-git-send-email-namhyung@kernel.org>
 <53286118.9070606@gmail.com> <CAM9d7cj8dptEDj+08G86_prE7sr85RHm4RtuNA1R6vBEQWyL5w@mail.gmail.com>
 <5328F62E.3040603@gmail.com>
From: Namhyung Kim <namhyung@kernel.org>
Date: Wed, 19 Mar 2014 01:48:34 +0000
X-Google-Sender-Auth: Yq91Dl-ZnVGExzt-_vRXL-8QGv4
Message-ID: <CAM9d7cjsOhY9tPb3Hf2epnPEVbg3Pz8Y=0Axkxajm7y0-+70Cg@mail.gmail.com>
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

On Wed, Mar 19, 2014 at 1:43 AM, David Ahern <dsahern@gmail.com> wrote:
> On 3/18/14, 7:30 PM, Namhyung Kim wrote:
>>
>> Hi David,
>>
>> On Tue, Mar 18, 2014 at 3:07 PM, David Ahern <dsahern@gmail.com> wrote:
>>>
>>> On 3/18/14, 12:32 AM, Namhyung Kim wrote:
>>>>
>>>>
>>>> This is a patchset implementing -F/--field option to setup output
>>>> field/column as Ingo requested.  It depends on my perf/percentage
>>>> patchset (with minor updates) [1].
>>>
>>>
>>>
>>> perf-report should be consistent with perf-script which uses --fields.
>>
>>
>> Right.  Did you mean s/--field/--fields/ then?
>
>
> yes. consistency is huge.

Okay, I'll keep that in mind.  Actually I wasn't aware of the
'perf-script --fields' when working on this. :)

Thanks,
Namhyung
