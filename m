Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751855Ab3GNIfU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jul 2013 04:35:20 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:52110 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751680Ab3GNIfS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jul 2013 04:35:18 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Paul Bolle <pebolle@tiscali.nl>
Subject: Re: [PATCH] ARM: multiplatform: remove reference to ARCH_MULTI_V4
Date: Sun, 14 Jul 2013 10:34:42 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <1373746191.1359.37.camel@x61.thuisdomein>
In-Reply-To: <1373746191.1359.37.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201307141034.42868.arnd@arndb.de>
X-Provags-ID: V02:K0:mN+NO8ME7081Jgny0vv5p7+JjQamDgeEk/kVhA6m2PA
 s2pFdcDEdNqttBlKDvVFqOt6Raj2gAD3lHVM5Pb3kuQ1NbL4K9
 sjA2/yUIVuVR/XvUAQ4SMCWWAknzBEt6+Hcv2I1yKZszkkwB3R
 KIKZC0F1oWInnsp1Q/U5YOF+sS63GVdrPC+gla55JwQLd1gOU+
 PLsDdPvSz6UEZ1Dn5VBzBYlJh/nBPYxFpr7GWFNqBFYUXN5TLH
 0g2MJ8fE2Paz/aWHHBal83tozLv8M2UQZFRblBNOjpz+cXDzzq
 bB9YrL/fR12/J83xL26mNmDiWooEsRNZVYD+PIFzjCe3oKJidE
 hjovynPHRiyzFLPyPDwQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 13 July 2013, Paul Bolle wrote:
> The Kconfig symbol ARCH_MULTI_V4 was removed in commit 24e860fbfd
> ("ARM: multiplatform: always pick one CPU type"). Remove the last
> reference to it too.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> 0) Untested.
> 
> 1) Commit 24e860fbfd is silent on the reason to drop ARCH_MULTI_V4. And
> the ARM section of the Kconfig files is rather complicated for people,
> like me, that aren't familiar with the way the ARM universe is divided
> in architectures, machines, platforms, etc. That makes it hard to say
> whether ARCH_MULTI_V4 was dropped on purpose or by accident.

It was dropped on purpose because it is unused in 3.11 but it will
be used again in 3.12, so I wouldn't bother with your patch.

Thanks anyway for looking into unused symbols, I think checking for
unused code like this is very useful in general.

	Arnd
