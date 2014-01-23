Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932082AbaAWPLd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 10:11:33 -0500
Received: from mail-we0-f179.google.com ([74.125.82.179]:55642 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753063AbaAWPLb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 10:11:31 -0500
Date: Thu, 23 Jan 2014 15:11:23 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Linux Input <linux-input@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH 2/3 RESEND] mfd: tc3589x: Reform device tree probing
Message-ID: <20140123151123.GE8586@lee--X1>
References: <1390481008-23900-1-git-send-email-linus.walleij@linaro.org>
 <20140123133141.GD8586@lee--X1>
 <CACRpkdZjRG=cmWHmmFNS+=guCwQoFpu8T3r4YHr6t_XihvmaWA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdZjRG=cmWHmmFNS+=guCwQoFpu8T3r4YHr6t_XihvmaWA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Patch looks good to me. Is there any reason why we should rush this in
> > for v3.14, or is it okay to go to -next?
> 
> No rush, but it's been on review like forever so unless there is
> some noise from the DT people at -rc1 I'd be very happy if you
> could apply patches 1 & 2 by then.

I'm just waiting for their Ack. If I don't have it soon I'll review it
myself and any changes will have to come in via subsequent patch
submissions.

I think it's sensible to head for v3.15 for this set.

> The third one can be applied out-of-order to the input tree after
> that.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
