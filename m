Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753312Ab3H0QbB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 12:31:01 -0400
Received: from www.linutronix.de ([62.245.132.108]:38301 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751954Ab3H0Qa7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 12:30:59 -0400
Message-ID: <521CD43A.4040000@linutronix.de>
Date: Tue, 27 Aug 2013 18:30:50 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130821 Icedove/17.0.8
MIME-Version: 1.0
To: Olof Johansson <olof@lixom.net>
CC: Kevin Hilman <khilman@linaro.org>, Benoit Cousson <bcousson@baylibre.com>,
        Javier Martinez Canillas <javier@dowhile0.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, Greg KH <greg@kroah.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        Felipe Balbi <balbi@ti.com>, linux-next@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: linux-next: manual merge of the arm-soc tree with the usb tree
References: <20130827181353.319c150858829df1bb68d60b@canb.auug.org.au> <521C6961.9020103@linutronix.de> <CABxcv=mg6t5wPqpF3j5sr_76qfZ7N7KgpWhcKSGoPTOcaR=V6A@mail.gmail.com> <521CA888.1080909@baylibre.com> <521CAF59.1090203@linutronix.de> <521CB046.9070408@baylibre.com> <878uznxjnl.fsf@linaro.org> <521CC4E3.8030204@linutronix.de> <20130827161203.GA22852@quad.lixom.net>
In-Reply-To: <20130827161203.GA22852@quad.lixom.net>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/27/2013 06:12 PM, Olof Johansson wrote:
> No. Read that email again. What Benoit said was that if Felipe was fine
> with the change _HE_ would take it. Huge difference, and one that would have
> avoided this situation.

Yes, I'm sorry.

> The only way to solve these things in the future is to make the driver handle
> both the new and the old binding. Bindings are not supposed to change in
> incompatible ways any more, unless for special circumstances and/or when the
> old binding was completely broken.
The old bindings were completly broken.

> -Olof

Sebastian
