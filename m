Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933106Ab3CVHMy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 03:12:54 -0400
Received: from sema.semaphore.gr ([78.46.194.137]:54458 "EHLO
	sema.semaphore.gr" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932464Ab3CVHMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 03:12:53 -0400
Message-ID: <514C0471.5000306@semaphore.gr>
Date: Fri, 22 Mar 2013 09:12:49 +0200
From: Stratos Karafotis <stratosk@semaphore.gr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Viresh Kumar <viresh.kumar@linaro.org>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 linux-next] cpufreq: governors: Calculate iowait time
 only when necessary
References: <512E45E9.5020801@semaphore.gr> <512F8C7C.2020101@semaphore.gr> <CAKohponkj++4AkW__i7vWykURkAkgiHGLMX973KWMjQw9sTQYg@mail.gmail.com> <1776032.T2F0vtOmT3@vostro.rjw.lan>
In-Reply-To: <1776032.T2F0vtOmT3@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22/2013 01:54 AM, Rafael J. Wysocki wrote:
> 
> Applied to linux-pm.git/bleeding-edge and will be moved to linux-next if there
> are no build problems in the bleeding-edge branch.
> 
> Thanks,
> Rafael

Hi Rafael,

I just noticed a regression with this patch with the calculation of wall time
in get get_cpu_idle_time that prevents the CPU to increase to max frequency,
when we use ondemand with io_is_busy = 1.

I'm sorry about that, I'm sending a patch to fix it.

Regards,
Stratos 

