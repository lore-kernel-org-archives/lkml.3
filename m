Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752193AbaASNV3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jan 2014 08:21:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58191 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752078AbaASNV2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jan 2014 08:21:28 -0500
Message-ID: <52DBD150.3050205@redhat.com>
Date: Sun, 19 Jan 2014 08:21:20 -0500
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110419 Red Hat/3.1.10-1.el6_0 Thunderbird/3.1.10
MIME-Version: 1.0
To: Len Brown <lenb@kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Len Brown <len.brown@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Kristen Carlson Accardi <kristen@linux.intel.com>
Subject: Re: [PATCH] turbostat, servers do not support uncore power register
References: <1387499242-30364-1-git-send-email-prarit@redhat.com> <CAJvTdK=LuvjOphrETVkZL8a17c+tQDpD9JvHaEEw=WJrqnShjg@mail.gmail.com>
In-Reply-To: <CAJvTdK=LuvjOphrETVkZL8a17c+tQDpD9JvHaEEw=WJrqnShjg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 01/18/2014 10:50 PM, Len Brown wrote:
> On Thu, Dec 19, 2013 at 7:27 PM, Prarit Bhargava <prarit@redhat.com> wrote:
>> From the Intel Software Developer's Manual section 14.7.4,
>>
>> "For server platforms, PP1 domain is not supported, but its PP0 domain
>> supports the MSR_PP0_PERF_STATUS interface."
>>
>> When I run 'turbostat ls' I see the following error:
>>
>> /dev/cpu/0/msr offset 0x641 read failed
> 
> Let me know if you see this when running turbostat v3.6 or later.
> you can find  that version in the linux-next tree.
> 

Len, looks like v3.6 works -- I'll do some additional testing to confirm but
AFAICT it does work on the affected systems.

P.

> thanks,
> Len Brown, Intel Open Source Technology Center
