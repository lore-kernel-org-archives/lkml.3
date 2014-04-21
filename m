Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751719AbaDUKYb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 06:24:31 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:33895 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906AbaDUKYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 06:24:08 -0400
Message-ID: <5354F1A1.7010200@ti.com>
Date: Mon, 21 Apr 2014 15:53:29 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Stratos Karafotis <stratosk@semaphore.gr>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Russell King <linux@arm.linux.org.uk>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 3/8] davinci: da850: Use cpufreq_for_each_entry macro
 for iteration
References: <534DB1F9.8020105@semaphore.gr>
In-Reply-To: <534DB1F9.8020105@semaphore.gr>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 16 April 2014 03:56 AM, Stratos Karafotis wrote:
> The cpufreq core now supports the cpufreq_for_each_entry macro helper
> for iteration over the cpufreq_frequency_table, so use it.
> 
> It should have no functional changes.
> 
> Signed-off-by: Stratos Karafotis <stratosk@semaphore.gr>

I cannot test this (or even build this) since I do not have the patch
which adds cpufreq_for_each_entry(). The change as such looks fine to
me. Please prefix the subject line with "ARM: " as is the convention in
ARM world.

Thanks,
Sekhar

