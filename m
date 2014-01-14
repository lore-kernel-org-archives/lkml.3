Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752437AbaANXqi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 18:46:38 -0500
Received: from mail-pb0-f41.google.com ([209.85.160.41]:57443 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751693AbaANXqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 18:46:36 -0500
From: Kevin Hilman <khilman@linaro.org>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        <arm@kernel.org>, Boris BREZILLON <b.brezillon@overkiz.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>
Subject: Re: [GIT PULL] at91: cleanup for 3.14 #2
References: <1389190989-8261-1-git-send-email-nicolas.ferre@atmel.com>
Date: Tue, 14 Jan 2014 15:46:33 -0800
In-Reply-To: <1389190989-8261-1-git-send-email-nicolas.ferre@atmel.com>
	(Nicolas Ferre's message of "Wed, 8 Jan 2014 15:23:09 +0100")
Message-ID: <877ga25dpi.fsf@linaro.org>
User-Agent: Gnus/5.130008 (Ma Gnus v0.8) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nicolas Ferre <nicolas.ferre@atmel.com> writes:

> Arnd, Olof, Kevin,
>
> A little "cleanup" pull-request for 3.14 that goes on top of the previous
> AT91 cleanup material.
> The thing to note from this pull-request is the beginning of board file removal
> thank to the conversion to DT. We are still waiting for more feedback from
> board maintainer to intensify the effort.
>
> Thanks, best regards,
>
> The following changes since commit b46e837d8ef1f3c777bbf9513e2cdb5d87d6c374:
>
>   ARM: at91/dt: remove old clk material (2013-12-02 15:31:29 +0100)
>
> are available in the git repository at:
>
>   git://github.com/at91linux/linux-at91.git tags/at91-cleanup2
>
> for you to fetch changes up to e91a5555df5883bbc204b0e1f8e0489d3f7f3f2e:
>
>   ARM: at91: switch Calao QIL-A9260 board to DT (2013-12-19 17:27:30 +0100)
>
> ----------------------------------------------------------------
> Second cleanup pull-request for 3.14:
> - a tiny fix for the recent AT91 CCF implementation
> - the switch of one platform to DT with board file removal
>
> ----------------------------------------------------------------

Pulled into next/cleanup.

Thanks,

Kevin
