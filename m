Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932763Ab3DBPtU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 11:49:20 -0400
Received: from sema.semaphore.gr ([78.46.194.137]:56108 "EHLO
	sema.semaphore.gr" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760123Ab3DBPtT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 11:49:19 -0400
Message-ID: <515AFDFA.8090108@semaphore.gr>
Date: Tue, 02 Apr 2013 18:49:14 +0300
From: Stratos Karafotis <stratosk@semaphore.gr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Viresh Kumar <viresh.kumar@linaro.org>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 linux-next] cpufreq: ondemand: Calculate gradient of
 CPU load to early increase frequency
References: <51253715.7080600@semaphore.gr> <CAKohpokKCrvMYWQCRWccDJHbBNO7km5-vP=d3TwhDyU7HGX-YA@mail.gmail.com> <51561556.7020904@semaphore.gr> <1544183.cq3KaqH8x3@vostro.rjw.lan>
In-Reply-To: <1544183.cq3KaqH8x3@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02/2013 04:50 PM, Rafael J. Wysocki wrote:
> Do you have any numbers indicating that this actually makes things better?
> 
> Rafael

No, I don't.
The expected behaviour after this patch is to "force" max frequency few sampling periods earlier.
The idea was to increase system responsiveness especially on 'small' embedded systems (phones for example).

Actually, I thought to provide some numbers but I had no idea how to measure this.

Would it be enough to provide the number of times that the CPU increases frequency 
because of early_demand versus the total number of increments? 


Thanks,
Stratos
