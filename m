Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161192AbaDPNfz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 09:35:55 -0400
Received: from mail-oa0-f54.google.com ([209.85.219.54]:45317 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161002AbaDPNfy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 09:35:54 -0400
MIME-Version: 1.0
In-Reply-To: <20140416105121.GR4754@lee--X1>
References: <534DB213.7080802@semaphore.gr>
	<20140416105121.GR4754@lee--X1>
Date: Wed, 16 Apr 2014 19:05:53 +0530
Message-ID: <CAKohpongiw9kZJDBsnp4U5obzX_W-sWHX3GoKd3STtQmsw6GcA@mail.gmail.com>
Subject: Re: [PATCH v2 5/8] mfd: db8500-prcmu: Use cpufreq_for_each_entry
 macro for iteration
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Stratos Karafotis <stratosk@semaphore.gr>,
        Linus Walleij <linus.walleij@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16 April 2014 16:21, Lee Jones <lee.jones@linaro.org> wrote:
>> The cpufreq core now supports the cpufreq_for_each_entry macro helper
>> for iteration over the cpufreq_frequency_table, so use it.
>>
>> It should have no functional changes.
>>
>> Signed-off-by: Stratos Karafotis <stratosk@semaphore.gr>
>> ---
>>  drivers/mfd/db8500-prcmu.c | 19 ++++++++-----------
>>  1 file changed, 8 insertions(+), 11 deletions(-)
>
> Applied untested by me.

Wouldn't build. Let it go via Rafael.
