Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753810AbaGPVLm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 17:11:42 -0400
Received: from forward19.mail.yandex.net ([95.108.253.144]:44311 "EHLO
	forward19.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751949AbaGPVLi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 17:11:38 -0400
X-Greylist: delayed 305 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 Jul 2014 17:11:37 EDT
From: Evgeniy Polyakov <zbr@ioremap.net>
Envelope-From: drustafa@yandex.ru
To: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <20140716205055.145238026@linutronix.de>
References: <20140716205018.175419210@linutronix.de> <20140716205055.145238026@linutronix.de>
Subject: Re: [patch V2 35/64] connector: Use ktime_get_ns()
MIME-Version: 1.0
Message-Id: <1514801405544786@web1g.yandex.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Thu, 17 Jul 2014 01:06:26 +0400
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=koi8-r
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

17.07.2014, 01:04, "Thomas Gleixner" <tglx@linutronix.de>:
> Replace the ever recurring:
> ššššššššts = ktime_get_ts();
> ššššššššns = timespec_to_ns(&ts);
> with
> ššššššššns = ktime_get_ns();
>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Evgeniy Polyakov <zbr@ioremap.net>

Looks good to me, thank you.
