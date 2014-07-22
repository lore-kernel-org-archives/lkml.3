Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753714AbaGVIou (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 04:44:50 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:55114 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753418AbaGVIos (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 04:44:48 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Nick Krause <xerofoify@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Fix me in netx-regs.h
Date: Tue, 22 Jul 2014 10:44:17 +0200
Message-ID: <11713455.tffm2SOdyn@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAPDOMVhdK67Fc5KsamL8XKdRNy0VjKB3ub24krgwmRsnZGtQNQ@mail.gmail.com>
References: <CAPDOMVhdK67Fc5KsamL8XKdRNy0VjKB3ub24krgwmRsnZGtQNQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:bdSPwQ7IgkSdPsMEfGNNKAqMqyDZ+6Hgl6T1znEpeCl
 xJUALSDvLBh6EnQb/q8n4q5V3vWGPRbSuQVPpjUL+6I0fP6J6h
 sOQ3vNVpJKYUfFhUtO4/1U9KxYy8evg5/09vH88CQh679ZNMuA
 soB8tG2Bgp2Df4FbkCVoTv+ZJ+wdnif9ctCuSZnTBDMDdrjW+e
 amyYweqO+lGvn+wkbLQpykuk0jF4agbyZfILnmFYJxzKUwlxQ0
 M5ZJ2R2mZJkdqp1EVPle0Xj94Jj8Ia1ks5JeezyD6VV3IEeO3Q
 /KOzbmc6ZXDRRAlXro3vSvAOPgHRNNSD6osdJI/uwooV4XeYEh
 PQRhQ/2n9H1FWWFGgLPo=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 22 July 2014 00:16:26 Nick Krause wrote:
> Hey Russell,
> I did give thought to our previous conversations and I will still do
> fix mes but am going to be more careful
> with I submit them. Furthermore it seems  #define
> NETX_GPIO_COUNTER_CTRL_GPIO_RE is not defined
> correctly. As the maintainer what should I define it to?

Are you offering to become the maintainer for netx?

Try to get hold of a reference manual for the chip. More importantly
than the fixme, I think we should be able to move this platform into
ARCH_MULTIPLATFORM. This means moving the contents of the header files
into the places where they are used, and finding a better home for the
pfifo driver.

	Arnd
