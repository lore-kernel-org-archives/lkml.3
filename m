Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754029Ab3ITEXl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 00:23:41 -0400
Received: from mail-ob0-f172.google.com ([209.85.214.172]:38129 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753958Ab3ITEXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 00:23:39 -0400
MIME-Version: 1.0
In-Reply-To: <CAE9FiQXP3DARdJYHBS8w0ATVM78Q9tGTd=8CeMJiwozBU0F_OA@mail.gmail.com>
References: <1379563520-7221-1-git-send-email-yinghai@kernel.org>
	<CAKohpomt+sASL=2i-v=HSkhOZhbPmnFesEfPoEqSE+WKcCfnmw@mail.gmail.com>
	<11319698.mBBnJVdnIk@vostro.rjw.lan>
	<CAE9FiQXP3DARdJYHBS8w0ATVM78Q9tGTd=8CeMJiwozBU0F_OA@mail.gmail.com>
Date: Fri, 20 Sep 2013 09:53:39 +0530
Message-ID: <CAKohpom-3orEns00DC2=uk4pgV_xnfRpM1hrdyK9pjPUEgBXrA@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: return EEXIST instead of EBUSY for second registering
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20 September 2013 07:01, Yinghai Lu <yinghai@kernel.org> wrote:
> Sorry,  looks like this one is not enough.
>
> please let me know if you prefer me send addon patch
> or revised one.

Atleast you can let us know what the problem is? And then we
can decide on that.. But anyway, you can send a new patch
based over latest linux-next (which will have your original patch),
and then leave it onto Rafael to merge it or have two patches..
(though I am quite sure he will not drop anything now, unless its
too screwed.., at worst he might revert it..)..
