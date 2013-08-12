Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754481Ab3HLTL1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 15:11:27 -0400
Received: from cassarossa.samfundet.no ([193.35.52.29]:60640 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751429Ab3HLTLZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 15:11:25 -0400
Date: Mon, 12 Aug 2013 21:11:21 +0200
From: Hans-Christian Egtvedt <egtvedt@samfundet.no>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: rjw@sisk.pl, linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/44] cpufreq: at32ap: Use generic cpufreq routines
Message-ID: <20130812191121.GA18863@samfundet.no>
References: <cover.1376116344.git.viresh.kumar@linaro.org>
 <c70729588f2f21d10fa5d53e5189890af4248a93.1376116345.git.viresh.kumar@linaro.org>
 <20130810082333.GA27640@samfundet.no>
 <CAKohpon63d40c8eGKqY9EHZhb18ipKHhvBffo=buLLpP=CP0rA@mail.gmail.com>
 <20130812071042.GA30670@samfundet.no>
 <CAKohpomMmCbSd=H=Jh_dvbSWsv7z_Od_m=UG6-TX91SfXMez9w@mail.gmail.com>
 <20130812073058.GA7776@samfundet.no>
 <CAKohpon=pRK9WX=BqPtN3gSZXBxX62J=PW4sbzUxsoc0fJGhkQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKohpon=pRK9WX=BqPtN3gSZXBxX62J=PW4sbzUxsoc0fJGhkQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Around Mon 12 Aug 2013 13:09:25 +0530 or thereabout, Viresh Kumar wrote:
> On 12 August 2013 13:00, Hans-Christian Egtvedt <egtvedt@samfundet.no> wrote:
>> I'll add it on my todo-list and have a look at it in the evening (-:
> 
> Thanks.
> 
>> How hard can it be™
> 
> Its not about being hard but about knowing your platform well..

Turned out to be quite easy, but I couldn't get around to test it on
hardware (excuse: just moved, all HW is still in a box somewhere).

I'll submit the patch to cpufreq@vger.kernel.org for a sanity check, perhaps
you'll pull it into your series?

-- 
mvh
Hans-Christian Egtvedt
