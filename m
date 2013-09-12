Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756558Ab3ILGAS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 02:00:18 -0400
Received: from mail-qe0-f52.google.com ([209.85.128.52]:56401 "EHLO
	mail-qe0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754088Ab3ILGAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 02:00:16 -0400
MIME-Version: 1.0
In-Reply-To: <5230BE75.7040307@wwwdotorg.org>
References: <522E1FEF.6080803@wwwdotorg.org>
	<1775778.MeiRhuYy7o@vostro.rjw.lan>
	<522F86AD.6010603@wwwdotorg.org>
	<2521560.SfeNbV74nj@vostro.rjw.lan>
	<52304439.3030301@linux.vnet.ibm.com>
	<523094CD.3000506@wwwdotorg.org>
	<5230B078.3070306@linux.vnet.ibm.com>
	<5230B991.3040702@linux.vnet.ibm.com>
	<5230BE75.7040307@wwwdotorg.org>
Date: Thu, 12 Sep 2013 11:30:15 +0530
Message-ID: <CAKohpom5eNzn=7X1VUpdjRnfQ4L9Gk+icBvt0BOvAFeFj4Tk8A@mail.gmail.com>
Subject: Re: cpufreq_stats NULL deref on second system suspend
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        cpufreq <cpufreq@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12 September 2013 00:33, Stephen Warren <swarren@wwwdotorg.org> wrote:
> For the record, I'm testing on a 2-CPU system, so I'm not sure whether
> your explanation applies; it talks about CPUs 2 and 3 whereas I only
> have CPUs 0 and 1, but perhaps your explanation applies equally to any
> pair of CPUs?

It does apply to your system as well.. We remove cpu 1 in suspend and so
try to nominate cpu 0 as policy->cpu, which it already is :)
