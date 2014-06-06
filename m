Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752465AbaFFI2F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 04:28:05 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:61036 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751098AbaFFI2C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 04:28:02 -0400
MIME-Version: 1.0
X-Originating-IP: [90.207.204.193]
In-Reply-To: <20140605232949.GF16855@tassilo.jf.intel.com>
References: <CADknwL71NC5wBG1tnqgJ6iiA4y+HYomGpufOn7V+MP2=m7+Mig@mail.gmail.com>
	<CABPqkBTEafZ5MbYM4UQxX92uWcPiphPeXMoJRKTt8jnrB+5j2w@mail.gmail.com>
	<20140605132750.GA16811@pd.tnic>
	<CABPqkBT9ExD4unz0VZ5G1d+oGpkepiwXskgBpv5GTavs=tYAKA@mail.gmail.com>
	<20140605140316.GB16811@pd.tnic>
	<CAHzUATiVCHytrG3sz8AmC8anZTQcPDRHp91-kWEoeq=RU7UNiw@mail.gmail.com>
	<20140605151734.GD16811@pd.tnic>
	<CAHzUATioT8e=RxypbqBsHw-QkcYsdQEiKhb3e44A4S+98Ut6=Q@mail.gmail.com>
	<20140605165213.GI16642@pd.tnic>
	<CAHzUATiOi0_U4r+TN_okYh_5_VB-NpW+A5qgg6Vkz9kyrwqZug@mail.gmail.com>
	<20140605232949.GF16855@tassilo.jf.intel.com>
Date: Fri, 6 Jun 2014 09:28:00 +0100
Message-ID: <CADknwL74dtHTZEY1UswvD7wC_mb1MCBuXfYkjHHBus735JiWPg@mail.gmail.com>
Subject: Re: [PATCH 9/9] perf/x86: add syfs entry to disable HT bug workaround
From: Matt Fleming <matt@console-pimps.org>
To: Andi Kleen <ak@linux.intel.com>
Cc: Maria Dimakopoulou <maria.n.dimakopoulou@gmail.com>,
        Borislav Petkov <bp@alien8.de>, Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, "mingo@elte.hu" <mingo@elte.hu>,
        Jiri Olsa <jolsa@redhat.com>, "Yan, Zheng" <zheng.z.yan@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6 June 2014 00:29, Andi Kleen <ak@linux.intel.com> wrote:
>> As Stephane pointed out, the sysfs entry is optional and the workaround
>> can be disabled only as root.
>>
>> It is not absolutely necessary and it's not important.
>> We will drop it in V2.
>
> I would prefer to keep it. It's fairly complex and it's always good
> to have a way to disable complex things in case something goes wrong.

You want to be able to disable the workaround in case it doesn't work?
I'm having a hard time buying that as a valid reason for this knob.

If someone runs into issues with the workaround we want them to report
those issues so that we can tweak the code. If they've got the ability
to simply disable the code they're less likely to report the problem
and we'll all be worse for it.

Having the knob increase the number of configurations and increases
complexity, it doesn't reduce it.
