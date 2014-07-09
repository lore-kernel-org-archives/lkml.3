Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755632AbaGIOnJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 10:43:09 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:40363 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753293AbaGIOnH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 10:43:07 -0400
Message-ID: <53BD54EA.4020207@ti.com>
Date: Wed, 9 Jul 2014 10:42:50 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>, <rjw@rjwysocki.net>,
        <shawn.guo@linaro.org>
CC: <nm@ti.com>, <linaro-kernel@lists.linaro.org>, <linux-pm@vger.kernel.org>,
        <linux-arm-msm@vger.kernel.org>, <t.figa@samsung.com>,
        <sboyd@codeaurora.org>, <linux-kernel@vger.kernel.org>,
        <thomas.ab@samsung.com>, <arvind.chauhan@arm.com>,
        <spk.linux@gmail.com>
Subject: Re: [PATCH 05/14] cpufreq: cpu0: don't validate clock on clk_put()
References: <cover.1404231535.git.viresh.kumar@linaro.org> <a5279afda849ca394552dbae6a1364769da0dc98.1404231535.git.viresh.kumar@linaro.org>
In-Reply-To: <a5279afda849ca394552dbae6a1364769da0dc98.1404231535.git.viresh.kumar@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 01 July 2014 12:32 PM, Viresh Kumar wrote:
> CPU clk is not optional for this driver and probe would fail if it couldn't find
> a suitable clock.
> 
> And so, while calling clk_put() we don't need to validate clocks.
> 
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>


