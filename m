Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756910Ab3FSOyn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 10:54:43 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:48438 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756762Ab3FSOym (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 10:54:42 -0400
MIME-Version: 1.0
In-Reply-To: <20130619122202.GB32292@verge.net.au>
References: <cover.1371630975.git.viresh.kumar@linaro.org>
	<859db6d3cfc0efbd5b96783967c10cfcb8b5a51a.1371630975.git.viresh.kumar@linaro.org>
	<20130619122202.GB32292@verge.net.au>
Date: Wed, 19 Jun 2013 20:24:41 +0530
Message-ID: <CAKohpomzWEX+VSNHzBAEJ1aFQtiODBTJfr1PSKxqDvXoWTtg3Q@mail.gmail.com>
Subject: Re: [PATCH 05/13] cpufreq: e_powersave: call CPUFREQ_POSTCHANGE
 notfier in error cases
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Simon Horman <horms@verge.net.au>, Dave Jones <davej@redhat.com>
Cc: rjw@sisk.pl, linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, arvind.chauhan@arm.com,
        dave.martin@arm.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19 June 2013 17:52, Simon Horman <horms@verge.net.au> wrote:
> I have no objections to this change but at the same time I don't
> feel that I know the code well enough to review it.

Probably I made a mistake adding your name. Don't know how I
made up my mind that you are the main contributor for this.

Probably Dave is?
