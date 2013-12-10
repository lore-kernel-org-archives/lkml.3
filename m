Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751706Ab3LJTet (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 14:34:49 -0500
Received: from mail-pd0-f177.google.com ([209.85.192.177]:54538 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776Ab3LJTes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 14:34:48 -0500
From: Kevin Hilman <khilman@linaro.org>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        <arm@kernel.org>, Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        <Josh.wu@atmel.com>, Ludovic Desroches <ludovic.desroches@atmel.com>
Subject: Re: [GIT PULL] at91: soc updates for 3.14 #1
References: <1386583059-22281-1-git-send-email-nicolas.ferre@atmel.com>
Date: Tue, 10 Dec 2013 11:34:45 -0800
In-Reply-To: <1386583059-22281-1-git-send-email-nicolas.ferre@atmel.com>
	(Nicolas Ferre's message of "Mon, 9 Dec 2013 10:57:39 +0100")
Message-ID: <87k3fc7b56.fsf@linaro.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nicolas Ferre <nicolas.ferre@atmel.com> writes:

> Arnd, Olof, Kevin,
>
> This pull-request is for addition of sama5d36 and its Evaluation Kit. The
> patches are stacked on the "cleanup" material already in arm-soc tree
> (at91/sama5-ccf) like all other AT91 pull-requests for 3.14.
>
> Thanks, best regards,
>
> The following changes since commit b46e837d8ef1f3c777bbf9513e2cdb5d87d6c374:
>
>   ARM: at91/dt: remove old clk material (2013-12-02 15:31:29 +0100)
>
> are available in the git repository at:
>
>   git://github.com/at91linux/linux-at91.git tags/at91-soc
>
> for you to fetch changes up to 0a72922b8dab2a1ce9cc977e9b1850556b48b4aa:
>
>   ARM: at91: sama5d3/dt: add sama5d36ek dts files (2013-12-09 09:50:53 +0100)
>
> ----------------------------------------------------------------
> First soc pull-request for 3.14
> Addition of the sama5d36 SoC as a member of the sama5d3 family
> - SoC code and Device Tree file
> - Evaluation Kit (EK board) Device Tree file
>
> ----------------------------------------------------------------
> Josh Wu (2):
>       ARM: at91: sama5d3: add support for sama5d36 chip

I cherry-picked this one into next/soc.

>       ARM: at91: sama5d3/dt: add sama5d36ek dts files

And this one into next/dt because it's just the DT data.  

Due to the dependencies on the cleanup branch (thanks for pointing them
out in the pull request!), the cleanup branch was also merged intot
next/dt.

Kevin
