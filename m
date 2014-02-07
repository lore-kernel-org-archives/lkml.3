Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751768AbaBGJuk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 04:50:40 -0500
Received: from mail-pd0-f170.google.com ([209.85.192.170]:38936 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751280AbaBGJuh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 04:50:37 -0500
MIME-Version: 1.0
In-Reply-To: <1391696188-14540-2-git-send-email-nicolas.pitre@linaro.org>
References: <1391696188-14540-1-git-send-email-nicolas.pitre@linaro.org> <1391696188-14540-2-git-send-email-nicolas.pitre@linaro.org>
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Fri, 7 Feb 2014 09:50:17 +0000
X-Google-Sender-Auth: 7-SOPqSyp-asLxlhGqc_rK_4CyU
Message-ID: <CAHkRjk7O4L9SaZVJqWxwbtpp6Qiy5ageQLa8hz4Wepe4LzagLw@mail.gmail.com>
Subject: Re: [PATCH 2/2] ARM64: powernv: remove redundant cpuidle_idle_call()
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        linuxppc-dev@lists.ozlabs.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6 February 2014 14:16, Nicolas Pitre <nicolas.pitre@linaro.org> wrote:
> The core idle loop now takes care of it.
>
> Signed-off-by: Nicolas Pitre <nico@linaro.org>

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
