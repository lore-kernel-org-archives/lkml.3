Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752258AbaDDG3O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 02:29:14 -0400
Received: from mail-yk0-f170.google.com ([209.85.160.170]:42638 "EHLO
	mail-yk0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752224AbaDDG3K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 02:29:10 -0400
MIME-Version: 1.0
In-Reply-To: <1396009796-31598-1-git-send-email-daniel.lezcano@linaro.org>
References: <1396009796-31598-1-git-send-email-daniel.lezcano@linaro.org>
Date: Fri, 4 Apr 2014 02:29:09 -0400
X-Google-Sender-Auth: GJN6g7YRzZaHnViLT649y65LgL0
Message-ID: <CAJvTdKk9AJUfCKGDS1RGDNJwP-Q9gTYswBEHHji6L6Lq3yd8JA@mail.gmail.com>
Subject: Re: [RFC PATCHC 0/3] sched/idle : find the idlest cpu with cpuidle info
From: Len Brown <lenb@kernel.org>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, nicolas.pitre@linaro.org,
        Linux PM list <linux-pm@vger.kernel.org>, alex.shi@linaro.org,
        vincent.guittot@linaro.org, morten.rasmussen@arm.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

Interesting idea.

The benefit of this patch is to reduce power.
Have you been able to measure a power reduction, via power meter, or
via built-in RAPL power meter?
(turbostat will show RAPL watts, or if you have constant quantity of
work, use turbostat -J)

thanks,
-Len
