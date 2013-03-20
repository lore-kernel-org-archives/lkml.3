Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756169Ab3CTOiY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 10:38:24 -0400
Received: from mail-vb0-f53.google.com ([209.85.212.53]:37398 "EHLO
	mail-vb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751239Ab3CTOiW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 10:38:22 -0400
MIME-Version: 1.0
In-Reply-To: <1363789270-29579-1-git-send-email-konrad.wilk@oracle.com>
References: <1363789270-29579-1-git-send-email-konrad.wilk@oracle.com>
Date: Wed, 20 Mar 2013 20:08:21 +0530
X-Google-Sender-Auth: frhVml3MaAQKpGdeW-I0UHMxnlQ
Message-ID: <CAOh2x=n3ENKNBLs6R84D_tZrWNhtEu6ATDyQgqX1nOO0vzDx3g@mail.gmail.com>
Subject: Re: [PATCH] intel-pstate: Use #defines instead of hard-coded values.
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        rafael.j.wysocki@intel.com, dirk.j.brandewie@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 20, 2013 at 7:51 PM, Konrad Rzeszutek Wilk
<konrad.wilk@oracle.com> wrote:
> They are defined in coreboot (MSR_PLATFORM) and the other
> one is already defined in msr-index.h.
>
> Lets use those.
>
> CC: rafael.j.wysocki@intel.com
> CC: dirk.j.brandewie@intel.com
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> ---
>  arch/x86/include/uapi/asm/msr-index.h | 1 +
>  drivers/cpufreq/intel_pstate.c        | 6 +++---
>  2 files changed, 4 insertions(+), 3 deletions(-)

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
