Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753204AbbA1Uxo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:53:44 -0500
Received: from zabrina.hetzner-de.towertech.it ([178.63.16.19]:50066 "EHLO
	zabrina.hetzner-de.towertech.it" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753072AbbA1Uxm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:53:42 -0500
Date: Wed, 28 Jan 2015 19:27:00 +0100
From: Alessandro Zummo <a.zummo@towertech.it>
To: Xunlei Pang <pang.xunlei@linaro.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Richard Henderson <rth@twiddle.net>,
        Uwe Kleine-Koenig <u.kleine-koenig@pengutronix.de>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        John Stultz <john.stultz@linaro.org>,
        Arnd Bergmann <arnd.bergmann@linaro.org>
Subject: Re: [RFC PATCH v3 0/8] Provide y2038/y2106 safe
 rtc_class_ops.set_mmss64()
Message-ID: <20150128192700.15269823@linux.lan.towertech.it>
In-Reply-To: <CADcy93WBXjHs8A3Wo4ajiRcM2CHkN0DXSR2uB8Ww5ywe5KTDdA@mail.gmail.com>
References: <1421770899-4136-1-git-send-email-pang.xunlei@linaro.org>
	<CADcy93WBXjHs8A3Wo4ajiRcM2CHkN0DXSR2uB8Ww5ywe5KTDdA@mail.gmail.com>
Organization: Tower Technologies
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Jan 2015 00:12:09 +0800
Xunlei Pang <pang.xunlei@linaro.org> wrote:

> ping Alessandro

  -EBUSY . saw that, looks fine anyhow, but would like to
 have a deeper look. we have still some time 'till 2038, right? ;)

-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

