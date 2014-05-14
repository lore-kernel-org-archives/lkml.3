Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751691AbaENS4j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 14:56:39 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:55844 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076AbaENS4f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 14:56:35 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Anders Berg <anders.berg@avagotech.com>
Cc: Olof Johansson <olof@lixom.net>, Linus Walleij <linus.walleij@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/6] Add platform support for LSI AXM55xx
Date: Wed, 14 May 2014 20:56:24 +0200
Message-ID: <6334605.NlytHCzYVP@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <cover.1400072260.git.anders.berg@avagotech.com>
References: <cover.1400072260.git.anders.berg@avagotech.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:+/J5bTA43d2nZFZgwooqfHc/a4NzJooIqwtvSjAAwu+
 dvEPqA6bfPEJjjrOFg7bSha9dzaJjsbUxiIZMZ1Y35Pu5968Rp
 XN/WPMeBbDsQl7VtDrUWJHfgf8TVpLWKFto0eQuWRRHgUSEqgr
 i6P4QvpIp6m8hHUIHNe3yKK7jOORM9CHrU/YaWKMLoGCaK9xbI
 EyhUTrbZAgZa6rMJFX7T4ADh3ncv10PTGDDnAURk3Gwvizg0/t
 fqAZLqW58soZCZtLOxmdV7psf2vmrSIJwIOmYCaT2X7bjgvDQS
 CXzVsFLOL/kMEyr7f8Ji5LAFnk7fWDrxx6nlOKVlTtkS3ERXRe
 yCmZY+0WLnHm0kCRj7os=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 14 May 2014 20:37:55 Anders Berg wrote:
> 
> This is version 3 of this series to introduces basic platform support for the LSI
> AXM5516 SoC.
> 
> No major changes since v2. Ready to be applied to the arm-soc tree?

I think it's good, but I'm not sure if we should put them all into arm-soc.
There are no dependencies between the drivers that I can see, so why not
merge the clock and reset drivers through the individual subsystem maintainers?

We can take patches 1/3/4/6, and the others if there is a good reason
not to have the regular maintainers pick them up.

The hip04 platform series is also adding a multi_v7_lpae_defconfig file.
it would be good to add axxia to that config and also to the regular
multi_v7_defconfig, but that can be an add-on patch once we have merged
hip04.

	Arnd
