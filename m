Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934048AbaDIXDT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 19:03:19 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:59821 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932719AbaDIXDQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 19:03:16 -0400
Date: Thu, 10 Apr 2014 00:03:14 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Jonas Gorski <jogo@openwrt.org>
cc: Paul Bolle <pebolle@tiscali.nl>, Ralf Baechle <ralf@linux-mips.org>,
        MIPS Mailing List <linux-mips@linux-mips.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] MIPS: Replace CONFIG_MIPS64 and CONFIG_MIPS32_R2
In-Reply-To: <CAOiHx=mi3sW7C0ZGwAhobRryikMs=Hj0UL19ENuUMECqk0EW5g@mail.gmail.com>
Message-ID: <alpine.LFD.2.11.1404092356500.29561@eddie.linux-mips.org>
References: <1391952745.25424.6.camel@x220> <CAOiHx=mi3sW7C0ZGwAhobRryikMs=Hj0UL19ENuUMECqk0EW5g@mail.gmail.com>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 9 Feb 2014, Jonas Gorski wrote:

> While I agree about the CONFIG_MIPS64 => CONFIG_64BIT replacement, I
> wonder if CONFIG_MIPS32_R2 shouldn't rather be CONFIG_CPU_MIPSR2
> (maybe even the existing CONFIG_CPU_MIPS32_R2 are wrong here).

 Absolutely.  You should be able to build a 32-bit kernel (32BIT) for a 
MIPS64r2 processor (CPU_MIPS64_R2) and use the FP64 feature.

  Maciej
