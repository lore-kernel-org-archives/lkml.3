Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752971AbaJTTH6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 15:07:58 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:59414 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231AbaJTTHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 15:07:54 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH 1/2] clocksource: enable pxa_timer for SA-1100 platform
Date: Mon, 20 Oct 2014 21:07:16 +0200
Message-ID: <10546062.ah0Qvxpsuh@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1413377405-7503-1-git-send-email-dbaryshkov@gmail.com>
References: <1413377405-7503-1-git-send-email-dbaryshkov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:/NlICHkbS6Fn1iJz4zcaxKxHC1hX74/MIVuEQY0zleU
 I3qv4RVmiqHPumNH5d/1nMEsed16q8FC3TQB0bdPkbZYFOuptV
 NFASmYbfNe0mEFdsrjyUtvi4ixwV8ZZWRTbzCmjjN2al0sx613
 JP+JCHyWT/FLT/0z5lFOb7QmFf1otCFUmodOa+I6dn+lh+jqG7
 HhQbQ76A0jF0QmPlDENV5oVhsjn74ge9IyNymFPHmwNyDwH0bt
 GdnbUtPBlwRXY59wOwfdAPYSNxMLCRsxjfM2wYLHuR1/JzGS1C
 dtePHDlNKOL6YYSb+H4ce47vRmHGWtAH5wkQ9w2c0lobGv7l52
 cIKbmwDZvJSBTmyGuF24=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 15 October 2014 16:50:04 Dmitry Eremin-Solenikov wrote:
> SA-11x0 platform used the same IP block as was used on PXA. Consequently
> it makes sense to have only one driver. Enable pxa_timer clocksource for
> StrongARM platform.
> 
> Signed-off-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>

Both patches look good to me.

Acked-by: Arnd Bergmann <arnd@arndb.de>

Should we merge them through arm-soc or through the clocksource tree?

	Arnd
