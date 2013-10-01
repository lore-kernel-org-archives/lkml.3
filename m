Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753414Ab3JAPUi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 11:20:38 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:49689 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751350Ab3JAPUb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 11:20:31 -0400
Message-ID: <524AE83D.8040407@hurleysoftware.com>
Date: Tue, 01 Oct 2013 11:20:29 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "viresh.kumar@linaro.org" <viresh.kumar@linaro.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] 3.12.0-rc2: cpufreq_get(0) crashes since commit 6eed9404a
 (cpufreq: Use rwsem for protecting critical sections)
References: <524AE58B.9060902@hurleysoftware.com> <dar7rckrq3w5r18opwepseky.1380640340764@email.android.com>
In-Reply-To: <dar7rckrq3w5r18opwepseky.1380640340764@email.android.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/01/2013 11:13 AM, Wysocki, Rafael J wrote:
> Have you tested -rc3?  This looks like the cpufreq_get() bug that was fixed there.

I haven't but I will. Apologies if this is already fixed :)

Regards,
Peter Hurley

