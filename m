Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965051Ab3E2H6U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 03:58:20 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:58632 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964850Ab3E2H6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 03:58:19 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Daniel Tang <dt.tangr@gmail.com>,
        "linux@arm.linux.org.uk ARM Linux" <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "fabian@ritter-vogt.de Vogt" <fabian@ritter-vogt.de>,
        Lionel Debroux <lionel_debroux@yahoo.fr>
Subject: Re: [RFC PATCHv4 1/6] arm: TI-Nspire platform code
Date: Wed, 29 May 2013 09:58:13 +0200
Message-ID: <1659233.o2ovIRIt66@wuerfel>
User-Agent: KMail/4.10.2 (Linux/3.10.0-rc3-next-20130527+; KDE/4.10.3; x86_64; ; )
In-Reply-To: <10704A21-6BEC-42DC-BB1E-88A0E87D288B@gmail.com>
References: <1369480087-24786-1-git-send-email-dt.tangr@gmail.com> <201305271715.02385.arnd@arndb.de> <10704A21-6BEC-42DC-BB1E-88A0E87D288B@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:QfS9RBw4LxjAtEvOedNVqex69zfiNPasDrCxzri6oqo
 +075YzdyXSVrL1peUFBey8Ps/r9fyWS3INXqFIqcyK9e1as/Vh
 3fyAQRi1i4sYZMgzpzuR1qlzhMGjSQifC3CGEj4kyhMfgBXS2R
 Hyc2/f1+QHD7Xo+gMr2RPtp2DsGNQ+tAmLdoqRCWWmWU4eYOqe
 EtqaJMvkrj+GoUXZEB0EW+B+jY1EOYtJxc5Scvql7S020n71ZZ
 BrVbeV6XfXUhPUCCPQSspQUsddd7ICgqIrRfZfowthtoIAKqv5
 hFxyuO8QuKviMCAcFSs1rsFBQgLNFAkfRW/kHtLumZSLX5fzpS
 oWzYOSYoFIuGWPCCSln8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 29 May 2013 15:14:41 Daniel Tang wrote:
> 
> That's the idea for the long term.
> 
> For now though, I'll probably just let the bootloader enable 
> everything and work on a proper driver for power management later.

Ok, sounds good.

	Arnd
