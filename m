Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758077AbaKUH4H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 02:56:07 -0500
Received: from mail-oi0-f53.google.com ([209.85.218.53]:34150 "EHLO
	mail-oi0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757162AbaKUH4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 02:56:05 -0500
MIME-Version: 1.0
In-Reply-To: <1416554882-16566-2-git-send-email-Yuantian.Tang@freescale.com>
References: <1416554882-16566-1-git-send-email-Yuantian.Tang@freescale.com>
	<1416554882-16566-2-git-send-email-Yuantian.Tang@freescale.com>
Date: Fri, 21 Nov 2014 13:26:04 +0530
Message-ID: <CAKohpo=xLOxXrCJNO0LmrVxMDNsFy2Kxg6bNzHm=vQCJnBvSaw@mail.gmail.com>
Subject: Re: [PATCH 2/2] cpufreq: qoriq: rename the driver
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Tang Yuantian <Yuantian.Tang@freescale.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linuxppc-dev@ozlabs.org" <linuxppc-dev@ozlabs.org>,
        r64188@freescale.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21 November 2014 12:58, Tang Yuantian <Yuantian.Tang@freescale.com> wrote:
> This driver works on all QorIQ platforms which include
> ARM-based cores and PPC-based cores.
> Rename it in order to represent better.
>
> Signed-off-by: Tang Yuantian <Yuantian.Tang@freescale.com>
> ---
>  drivers/cpufreq/ppc-corenet-cpufreq.c | 371 ----------------------------------
>  drivers/cpufreq/qoriq-cpufreq.c       | 371 ++++++++++++++++++++++++++++++++++
>  2 files changed, 371 insertions(+), 371 deletions(-)
>  delete mode 100644 drivers/cpufreq/ppc-corenet-cpufreq.c
>  create mode 100644 drivers/cpufreq/qoriq-cpufreq.c

This is not reviewable at all.. How do I verify that you haven't changed
something in the files as well ?

To make life easy always create patches with:

git format-patch -C -M

Above options handle renames pretty well.
