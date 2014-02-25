Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752746AbaBYXYP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 18:24:15 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:64885 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344AbaBYXYN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 18:24:13 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Russ Dill <Russ.Dill@ti.com>, "Thomas Gleixner" <tglx@linutronix.de>
From: Sebastian Capella <sebastian.capella@linaro.org>
In-Reply-To: <530CCFB5.5030205@ti.com>
Cc: "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        linaro-kernel@lists.linaro.org, linux-arm-kernel@lists.infradead.org,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Will Deacon" <will.deacon@arm.com>, "Robin Holt" <holt@sgi.com>
References: <1392774729-3235-1-git-send-email-sebastian.capella@linaro.org>
 <1392774729-3235-2-git-send-email-sebastian.capella@linaro.org>
 <20140222102616.GG21483@n2100.arm.linux.org.uk>
 <20140224231345.10580.62916@capellas-linux> <530C4CAE.5000202@ti.com>
 <alpine.DEB.2.02.1402251125500.21251@ionos.tec.linutronix.de>
 <530CCFB5.5030205@ti.com>
Message-ID: <20140225232409.18229.4284@capellas-linux>
User-Agent: alot/0.3.4
Subject: Re: [PATCH RFC v1 1/3] ARM: Add irq disabled version of soft_restart.
Date: Tue, 25 Feb 2014 15:24:09 -0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Russ Dill (2014-02-25 09:15:33)
> On 02/25/2014 02:27 AM, Thomas Gleixner wrote:
> > If you want escape the tracer and in that case you really want it 
> > being on a different stack, use raw_local_irq_* which are not
> > traced.
> 
> So it might make sense to change soft_restart to use the
> raw_local_irq_* calls.

I've added this change.  So far it's working well.

Thanks!

Sebastian
