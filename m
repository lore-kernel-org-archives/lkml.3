Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753060AbaD2Fc6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 01:32:58 -0400
Received: from mail-ve0-f174.google.com ([209.85.128.174]:61634 "EHLO
	mail-ve0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437AbaD2Fc5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 01:32:57 -0400
MIME-Version: 1.0
In-Reply-To: <000601cf636b$3c2b39b0$b481ad10$@samsung.com>
References: <000601cf636b$3c2b39b0$b481ad10$@samsung.com>
Date: Tue, 29 Apr 2014 11:02:56 +0530
X-Google-Sender-Auth: Ze6k9J91uUuy5tcqS6yZacS1uBk
Message-ID: <CAOh2x=nzLNDe+vL5UvKkaRMDT7M+U9jG4HLHavS2ksmiOE_G+w@mail.gmail.com>
Subject: Re: [PATCH 1/2] PM / OPP: Use list_for_each_entry_reverse instead of list_for_each_entry
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Jonghwan Choi <jhbird.choi@samsung.com>
Cc: open list <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2014 at 10:54 AM, Jonghwan Choi <jhbird.choi@samsung.com> wrote:
> Most of the cpufreq table is sorted in descending order.

Which part of kernel says that?

> But when cpufreq table is made from dev_pm_opp_init_cpufreq_table,
> it is sorted in ascending order. So in some case to make cpufreq table
> with descending order it needs an extra work.

Order of this table shouldn't matter at all in cpufreq layer..
