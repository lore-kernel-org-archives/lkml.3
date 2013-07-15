Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933387Ab3GOQWH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 12:22:07 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:48694 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932566Ab3GOQWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 12:22:05 -0400
Message-ID: <51E421A8.1010302@linaro.org>
Date: Mon, 15 Jul 2013 17:22:00 +0100
From: Julien Grall <julien.grall@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130704 Icedove/17.0.7
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: stefano.stabellini@eu.citrix.com, ian.campbell@citrix.com,
        patches@linaro.org, linux-kernel@vger.kernel.org,
        xen-devel@lists.xen.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [Xen-devel] [PATCH] xen/arm: disable cpuidle when linux is running
 as dom0
References: <1373898101-15633-1-git-send-email-julien.grall@linaro.org> <20130715152532.GC5774@phenom.dumpdata.com>
In-Reply-To: <20130715152532.GC5774@phenom.dumpdata.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/15/2013 04:25 PM, Konrad Rzeszutek Wilk wrote:
> On Mon, Jul 15, 2013 at 03:21:41PM +0100, Julien Grall wrote:
>> When linux is running as dom0, Xen doesn't show the physical cpu but a
>> virtual CPU.
>> On some ARM SOC (for instance the exynos 5250), linux registers callbacks
>> for cpuidle. When these callbacks are called, they will modify
>> directly the physical cpu not the virtual one. It can impact the whole board
>> instead of dom0.
> 
> Should you also call disable_cpufreq() ?

I had some issue on the versatile express when cpufreq was disabled.
I will give another try and see the exact error.

-- 
Julien

