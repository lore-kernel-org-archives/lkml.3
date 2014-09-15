Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754360AbaIOQuy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 12:50:54 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:51025 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754046AbaIOQuw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 12:50:52 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: Re: [PATCH v2 1/2] gpio: Increase ARCH_NR_GPIOs to 512
Date: Mon, 15 Sep 2014 18:50:34 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-35-generic; KDE/4.3.2; x86_64; ; )
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>, Alan Cox <alan@linux.intel.com>,
        Ning Li <ning.li@intel.com>, linux-gpio@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1410790185-31101-1-git-send-email-mika.westerberg@linux.intel.com>
In-Reply-To: <1410790185-31101-1-git-send-email-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201409151850.34472.arnd@arndb.de>
X-Provags-ID: V02:K0:po9/FG4hbd5vqSad8g2yZrXnyrXSuZLshWNakRot62B
 3OO77O4mpqvhIxtwyZJevq9q2dbhqHn30HilTMl87mlhPmadAC
 8RQ9OxTGS9/JfWIpFZVsxPPZ2nQdJJekPVGtJW+EXz6zHSuiRG
 MyzmPhJvoZg0xlaLCGI66DPyZZDZ1sv92PblKRtKEyJQ5iOsiZ
 MDOC+EgO8+NicW5R7SXI8vWnI8PByaibNMZrc5k6N08OtbdwrH
 0kFTWSkdixDrhBOF9KpAxenidZlWuuBSLwhyPN6hFhfvTCDrS/
 w657Eix0WiicflWn+3dtQARm3cA4M9sCr+OyKPPDfePh8ygHN8
 qeWm++5nm2xkMgdN16CA=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 15 September 2014, Mika Westerberg wrote:
> Some newer Intel SoCs, like Braswell already have more than 256 GPIOs
> available so the default limit is exceeded. Instead of adding more
> architecture specific gpio.h files with custom ARCH_NR_GPIOs we increase
> the gpiolib default limit to be twice the current.
> 
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> ---
> Changes to previous version is that now we increase the common limit
> instead of adding x86 specific gpio.h

Can you please include the reasoning for this decision in the
changeset description? I'm sure you have your reasons, but from
the text above, it sounds like a rather bad idea. What other
architectures are impacted by this, and what is the kernel size
cost for it on those architectures?

	Arnd
