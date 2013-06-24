Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751937Ab3FXUCS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 16:02:18 -0400
Received: from www.linutronix.de ([62.245.132.108]:51596 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092Ab3FXUBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 16:01:50 -0400
Date: Mon, 24 Jun 2013 22:01:47 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
cc: John Stultz <john.stultz@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Stuart Menefy <stuart.menefy@st.com>, Arnd Bergmann <arnd@arndb.de>,
        Rob Herring <robherring2@gmail.com>, Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH v5] clocksource:arm_global_timer: Add ARM global timer
 support.
In-Reply-To: <1372089195-29219-1-git-send-email-srinivas.kandagatla@st.com>
Message-ID: <alpine.DEB.2.02.1306242200460.4013@ionos.tec.linutronix.de>
References: <1372089195-29219-1-git-send-email-srinivas.kandagatla@st.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Jun 2013, Srinivas KANDAGATLA wrote:

> From: Stuart Menefy <stuart.menefy@st.com>
> 
> This is a simple driver for the global timer module found in the Cortex
> A9-MP cores from revision r1p0 onwards. This should be able to perform
> the functions of the system timer and the local timer in an SMP system.
> 
> The global timer has the following features:
>     The global timer is a 64-bit incrementing counter with an
> auto-incrementing feature. It continues incrementing after sending
> interrupts. The global timer is memory mapped in the private memory
> region.
>     The global timer is accessible to all Cortex-A9 processors in the
> cluster. Each Cortex-A9 processor has a private 64-bit comparator that
> is used to assert a private interrupt when the global timer has reached
> the comparator value. All the Cortex-A9 processors in a design use the
> banked ID, ID27, for this interrupt. ID27 is sent to the Interrupt
> Controller as a Private Peripheral Interrupt. The global timer is
> clocked by PERIPHCLK.
> 
> Signed-off-by: Stuart Menefy <stuart.menefy@st.com>
> Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@st.com>
> CC: Arnd Bergmann <arnd@arndb.de>
> CC: Rob Herring <robherring2@gmail.com>
> CC: Linus Walleij <linus.walleij@linaro.org>
> CC: Will Deacon <will.deacon@arm.com>
> CC: Thomas Gleixner <tglx@linutronix.de>

Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
