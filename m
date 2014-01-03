Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753131AbaACSlw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 13:41:52 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:53400 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752304AbaACSlv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 13:41:51 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arm/smp: Make boot_secondary() static
Date: Fri, 03 Jan 2014 19:41:42 +0100
Message-ID: <4243977.Rh2PlZQ4Sh@wuerfel>
User-Agent: KMail/4.11 rc1 (Linux/3.10.0-5-generic; KDE/4.11.2; x86_64; ; )
In-Reply-To: <CAMuHMdXoZJEgMXH0K1d5kDs+XSM_KMkigUq+mKYVQezdxZ929g@mail.gmail.com>
References: <1388763959-27491-1-git-send-email-geert@linux-m68k.org> <201401031804.34124.arnd@arndb.de> <CAMuHMdXoZJEgMXH0K1d5kDs+XSM_KMkigUq+mKYVQezdxZ929g@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:8XptjgDA0o7D51LuOCr/xnz75EJL4ncPHtULP9rTmHk
 A5VCTGxCt39rcBYu0pv6FUP73gTqW808UBdMRZ9y7NqkaCPRsz
 c8KRr2UObRUeqnLMpKgtO4/YZOV/iqSsAC77m6T6ezRQh6//Dz
 Osl0+VKWTgi+p+Cd3aK+pvcS6R9rRSh1pf5Zk3n5wVFekmF+EM
 RgCpcJrfr2fA7J6Swc3uyWDDj8Q5UoFLzNoxlfAh+dq5ECUtkc
 X1JtJDdTnZNLEWl7+5wjhPTShz3K18HTHRv0+KXigeNTevHS7D
 Kf/+caJpXv9+4SyXBUK/IeG/lc+6JbnOBx+Z1Y3jRfExf6euYX
 rQnHHdwtyztBC3YUws8Q=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 03 January 2014 19:24:19 Geert Uytterhoeven wrote:
> Fine for me.
> 
> Do you want me to fold this into my patch, or will you apply this on top?
> 
> 

The patch is for Russell anyway, so please fold my change into your
patch, unless he prefers your previous version of course.

	Arnd
