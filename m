Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758780Ab3DYQPy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 12:15:54 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:34550 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757164Ab3DYQPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 12:15:52 -0400
Message-ID: <517956B3.2000201@samsung.com>
Date: Fri, 26 Apr 2013 01:15:47 +0900
From: Kukjin Kim <kgene.kim@samsung.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.16
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kukjin Kim <kgene.kim@samsung.com>
Subject: Re: linux-next: manual merge of the arm-soc tree with the pm tree
References: <20130424165417.5e2b74a01728d307e454750f@canb.auug.org.au>
In-Reply-To: <20130424165417.5e2b74a01728d307e454750f@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/24/13 15:54, Stephen Rothwell wrote:
> Hi all,
>
> Today's linux-next merge of the arm-soc tree got a conflict in
> arch/arm/mach-exynos/cpuidle.c between commit 554c06ba3ee2 ("cpuidle:
> remove en_core_tk_irqen flag") from the pm tree and commit 2eb89f893e44
> ("ARM: EXYNOS: factor out the idle states") from the arm-soc tree.
>
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

Looks OK to me, thanks.

- Kukjin
