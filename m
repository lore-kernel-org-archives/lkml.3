Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753383AbaCaEVH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 00:21:07 -0400
Received: from mail-oa0-f47.google.com ([209.85.219.47]:51999 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753316AbaCaEVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 00:21:05 -0400
MIME-Version: 1.0
In-Reply-To: <1396037484-23907-2-git-send-email-ego@linux.vnet.ibm.com>
References: <1396037484-23907-1-git-send-email-ego@linux.vnet.ibm.com>
	<1396037484-23907-2-git-send-email-ego@linux.vnet.ibm.com>
Date: Mon, 31 Mar 2014 09:51:03 +0530
Message-ID: <CAKohpokvHYH7xcQyQyKmbu_xqfX8dbwnBNhQ3y9ZyAm7i0z0Qg@mail.gmail.com>
Subject: Re: [PATCH v5 1/3] powernv, cpufreq: Select CPUFreq related Kconfig
 options for powernv
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Gautham R. Shenoy" <ego@linux.vnet.ibm.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "linuxppc-dev@ozlabs.org" <linuxppc-dev@ozlabs.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Anton Blanchard <anton@samba.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29 March 2014 01:41, Gautham R. Shenoy <ego@linux.vnet.ibm.com> wrote:
> From: "Gautham R. Shenoy" <ego@linux.vnet.ibm.com>
>
> Enable CPUFreq for PowerNV. Select "performance", "powersave",
> "userspace" and "ondemand" governors. Choose "ondemand" to be the
> default governor.
>
> Signed-off-by: Gautham R. Shenoy <ego@linux.vnet.ibm.com>
> Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
> ---
>  arch/powerpc/configs/pseries_defconfig    | 1 +
>  arch/powerpc/configs/pseries_le_defconfig | 1 +
>  arch/powerpc/platforms/powernv/Kconfig    | 6 ++++++
>  3 files changed, 8 insertions(+)

Probably it doesn't make much sense to keep this as the first patch
as you still don't have the driver available yet.
