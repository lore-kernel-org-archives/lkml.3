Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761356Ab3BNQKx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 11:10:53 -0500
Received: from mail-wi0-f181.google.com ([209.85.212.181]:52969 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758124Ab3BNQKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 11:10:52 -0500
MIME-Version: 1.0
In-Reply-To: <1360786482-881-1-git-send-email-dirk.brandewie@gmail.com>
References: <20130212214949.GA1003@redhat.com>
	<1360786482-881-1-git-send-email-dirk.brandewie@gmail.com>
Date: Thu, 14 Feb 2013 21:40:43 +0530
X-Google-Sender-Auth: QkMb60JFWWdjpY-NQDfXKI0im-U
Message-ID: <CAOh2x=mhtFsEJx57GTASAq+p4Ri-fvTmnkxZJzgifJ=3yTawXw@mail.gmail.com>
Subject: Re: [PATCH] cpufreq/intel_pstate: Change to disallow module build
From: Viresh Kumar <viresh.kumar@linaro.org>
To: dirk.brandewie@gmail.com
Cc: davej@redhat.com, rjw@sisk.pl, linux-kernel@vger.kernel.org,
        cpufreq@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 14, 2013 at 1:44 AM,  <dirk.brandewie@gmail.com> wrote:
> From: Dirk Brandewie <dirk.brandewie@gmail.com>
>
> Load order is important in order for intel_pstate to take over as the
> default scaling driver from acpi-cpufreq.
>
> If both are built-in acpi-cpufreq uses late_initcall() and
> intel_pstate uses device_initcall() so it will be able to register as
> the scaling before acpi-cpufreq for the processors supported by
> intel_pstate.
>
> If acpi-cpufreq is built as a module then intel_pstate still gets
> first option to become the scaling driver.
>
> Signed-off-by: Dirk Brandewie <dirk.brandewie@gmail.com>

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
