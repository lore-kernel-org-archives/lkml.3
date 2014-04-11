Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754620AbaDKCo1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 22:44:27 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:41116 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754132AbaDKCoZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 22:44:25 -0400
MIME-Version: 1.0
In-Reply-To: <5346BBDF.4050901@wwwdotorg.org>
References: <1393876300-3061-1-git-send-email-swarren@wwwdotorg.org>
 <1393876300-3061-4-git-send-email-swarren@wwwdotorg.org> <CAAVeFuJY67zdoHiZufxDbkaw=xt8YwxyDAwHW_T7UZeSOt35NA@mail.gmail.com>
 <5346BBDF.4050901@wwwdotorg.org>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Fri, 11 Apr 2014 11:44:04 +0900
Message-ID: <CAAVeFu++TPMG_TP1T2EEc5a04uqx_g2mtbrG1RWb2KLn+wvoxQ@mail.gmail.com>
Subject: Re: [PATCH V3 4/5] mfd: palmas: support IRQ inversion at the board level
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Stephen Warren <swarren@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 11, 2014 at 12:42 AM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 04/10/2014 01:04 AM, Alexandre Courbot wrote:
>> Stephen, any news about this patch? I'm waiting for it to be merged in
>> order to resend some Tegra DTs, but still cannot see it in -next.
>
> To be honest, this became too painful to work on just to fix a warning
> at boot which has no practical side-effect in our case. The best thing
> to do is just merge your DTs for 3.16, and keep ignoring the warning
> just like we always have on Dalmore. Hopefully at some point I (or
> someone) will run out of higher priority work items and get back to this.

Ok, fine by me. I will wait for -rc1, see if I can enable more devices
with 3.16 and send you the updated DTs soon after.

Thanks,
Alex.
