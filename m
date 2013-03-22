Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753929Ab3CVMGB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 08:06:01 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:47278 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753465Ab3CVMF7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 08:05:59 -0400
MIME-Version: 1.0
In-Reply-To: <1790330.ctnB4S9NpK@vostro.rjw.lan>
References: <cover.1362381470.git.viresh.kumar@linaro.org>
	<1483775.d1txvSJx9o@vostro.rjw.lan>
	<CAOh2x=n8G+g8EE-9mGovbiB-oXV3pP3bWUds8noATSc3LEYJ8A@mail.gmail.com>
	<1790330.ctnB4S9NpK@vostro.rjw.lan>
Date: Fri, 22 Mar 2013 17:35:59 +0530
Message-ID: <CAKohpok9zoq10UHCSQ5MC-dKcv89dqDkActLKng-6P6wd1oCFw@mail.gmail.com>
Subject: Re: [PATCH V3 2/4] cpufreq: governor: Implement per policy instances
 of governors
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        robin.randhawa@arm.com, Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22 March 2013 17:41, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> Well, if the submitter wants to cheat, she/he certainly can this way, but
> what's the benefit, honestly?  If the reviewer actually notices that there are
> more differences than the submitter admits to, the consequences may be quite
> unpleasant for the submitter (like the rejection of any future patches, for
> example).  And mistakes are possible anyway (and the more patches you deal
> with, the greater the chances of making a mistake are).

Agreed.. I was focusing on the last part: mistakes.. People learn over time
and can still commit mistakes.. So a diff is always better to see what changed.
