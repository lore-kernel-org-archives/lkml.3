Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932207AbaAWPFA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 10:05:00 -0500
Received: from mail-oa0-f41.google.com ([209.85.219.41]:58661 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753817AbaAWPE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 10:04:57 -0500
MIME-Version: 1.0
In-Reply-To: <20140123133141.GD8586@lee--X1>
References: <1390481008-23900-1-git-send-email-linus.walleij@linaro.org>
	<20140123133141.GD8586@lee--X1>
Date: Thu, 23 Jan 2014 16:04:57 +0100
Message-ID: <CACRpkdZjRG=cmWHmmFNS+=guCwQoFpu8T3r4YHr6t_XihvmaWA@mail.gmail.com>
Subject: Re: [PATCH 2/3 RESEND] mfd: tc3589x: Reform device tree probing
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Linux Input <linux-input@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Mark Rutland <mark.rutland@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 23, 2014 at 2:31 PM, Lee Jones <lee.jones@linaro.org> wrote:

> Patch looks good to me. Is there any reason why we should rush this in
> for v3.14, or is it okay to go to -next?

No rush, but it's been on review like forever so unless there is
some noise from the DT people at -rc1 I'd be very happy if you
could apply patches 1 & 2 by then.

The third one can be applied out-of-order to the input tree after
that.

Yours,
Linus Walleij
