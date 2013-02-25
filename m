Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757947Ab3BYXAs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 18:00:48 -0500
Received: from mga01.intel.com ([192.55.52.88]:33535 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753518Ab3BYXAr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 18:00:47 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,736,1355126400"; 
   d="scan'208";a="291683936"
Date: Mon, 25 Feb 2013 15:00:35 -0800
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, santosh.shilimkar@ti.com,
        linux-pm@vger.kernel.org, fweisbec@gmail.com, john.stultz@linaro.org,
        linaro-kernel@lists.linaro.org
Subject: Re: [PATCH 2/2][RFC] time : set broadcast irq affinity
Message-ID: <20130225150035.7ddf6643@chromoly>
In-Reply-To: <512BEAAF.1070500@linaro.org>
References: <5123C299.3080005@linaro.org>
	<1361484083-5906-1-git-send-email-daniel.lezcano@linaro.org>
	<1361484083-5906-2-git-send-email-daniel.lezcano@linaro.org>
	<20130222095530.377fd218@chromoly>
	<512BEAAF.1070500@linaro.org>
Organization: OTC
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Feb 2013 23:50:23 +0100
Daniel Lezcano <daniel.lezcano@linaro.org> wrote:

> Do you mean a cpumask static variable ? and something like:
> 
> if (!cpumask_test_cpu(cpu, &affinitymask)) {
> 	cpumask_set_cpu(cpu, &affinitymask);
> 	irq_set_affinity(bc->irq, &affinitymask)
> }
yeah. but i think you can use the cpumask in struct clock_event_device.

-- 
Thanks,

Jacob
