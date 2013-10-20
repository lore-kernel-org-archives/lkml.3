Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751989Ab3JTWm5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Oct 2013 18:42:57 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:59985 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751868Ab3JTWm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Oct 2013 18:42:56 -0400
From: Tomasz Figa <tomasz.figa@gmail.com>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: Kukjin Kim <kgene@kernel.org>, linux-samsung-soc@vger.kernel.org,
        "'Russell King - ARM Linux'" <linux@arm.linux.org.uk>,
        oselas@community.pengutronix.de, linux-kernel@vger.kernel.org,
        "'Ben Dooks'" <ben-linux@fluff.org>, augulis.darius@gmail.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: s3c64xx: mini6410: Correct card detect type for HSMMC1
Date: Mon, 21 Oct 2013 00:42:48 +0200
Message-ID: <1538561.RlaZEsIrlT@thinkpad>
User-Agent: KMail/4.11.2 (Linux/3.11.6-gentoo; KDE/4.11.2; x86_64; ; )
In-Reply-To: <5264529C.1000601@samsung.com>
References: <1380471121-9478-1-git-send-email-tomasz.figa@gmail.com> <1e2a01cecb91$f790c700$e6b25500$@org> <5264529C.1000601@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kukjin,

On Monday 21 of October 2013 07:01:00 Kukjin Kim wrote:
> On 10/18/13 08:38, Kukjin Kim wrote:
> > Tomasz Figa wrote:
> >> Hi Kukjin,
> > 
> > Hi,
> > 
> >> On Sunday 29 of September 2013 18:12:01 Tomasz Figa wrote:
> >>> According to board schematics, for HSMMC1 a GPIO line is used to
> >>> detect
> >>> card presence, while currently it is being configured for internal
> >>> card
> >>> detect line, which is multiplexed with card detect line of HSMMC0 and
> >>> thus breaking it.
> >>> 
> >>> This patch adds proper sdhci platform data setting card detect type
> >>> to
> >>> external GPIO and fixing operation of HSMMC0.
> >>> 
> >>> Signed-off-by: Tomasz Figa<tomasz.figa@gmail.com>
> >>> ---
> >>> 
> >>>   arch/arm/mach-s3c64xx/mach-mini6410.c | 10 ++++++++++
> >>>   1 file changed, 10 insertions(+)
> >> 
> >> Would you mind taking this patch to your tree?
> > 
> > Applied, thanks.
> > Kukjin
> 
> Uhm...just small concern...it's possible to support dt for mini6410 but
> basic. I need to hold this on...

May I ask you to explain your concern about this?

I believe this bug fix is fine, since we still support board files for 
s3c64xx and DT based support is experimental at the moment.

Best regards,
Tomasz

