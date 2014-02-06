Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753746AbaBFOVD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 09:21:03 -0500
Received: from www.linutronix.de ([62.245.132.108]:35080 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751946AbaBFOVA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 09:21:00 -0500
Date: Thu, 6 Feb 2014 15:20:30 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Nicolas Pitre <nicolas.pitre@linaro.org>
cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, linux-pm@vger.kernel.org,
        linaro-kernel@lists.linaro.org
Subject: Re: [PATCH 1/2] PPC: powernv: remove redundant cpuidle_idle_call()
In-Reply-To: <1391696188-14540-1-git-send-email-nicolas.pitre@linaro.org>
Message-ID: <alpine.DEB.2.02.1402061520040.21991@ionos.tec.linutronix.de>
References: <1391696188-14540-1-git-send-email-nicolas.pitre@linaro.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

An Thu, 6 Feb 2014, Nicolas Pitre wrote:

> The core idle loop now takes care of it.
> 
> Signed-off-by: Nicolas Pitre <nico@linaro.org>

Acked-by: Thomas Gleixner <tglx@linutronix.de>
