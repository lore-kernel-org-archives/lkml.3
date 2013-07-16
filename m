Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754956Ab3GPOEJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 10:04:09 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:54926 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754599Ab3GPOEH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 10:04:07 -0400
MIME-Version: 1.0
In-Reply-To: <20130716131332.GL22506@sirena.org.uk>
References: <1373550711-18828-1-git-send-email-jonas.jensen@gmail.com>
	<1373978485-17496-1-git-send-email-jonas.jensen@gmail.com>
	<20130716131332.GL22506@sirena.org.uk>
Date: Tue, 16 Jul 2013 16:04:07 +0200
Message-ID: <CACmBeS3jU2csACZCqXfRvCYAEHaK7S3AcJ++Yd=L-mgfeqg68A@mail.gmail.com>
Subject: Re: [PATCH v3] rtc: Add MOXA ART RTC driver
From: Jonas Jensen <jonas.jensen@gmail.com>
To: Mark Brown <broonie@kernel.org>
Cc: rtc-linux@googlegroups.com, a.zummo@towertech.it,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org, arnd@arndb.de
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16 July 2013 15:13, Mark Brown <broonie@kernel.org> wrote:
> Since you're now using OF you should also be including a binding
> document.

The binding document already exist in set of patches adding MOXA ART
SoC support ( I intend to mail out v4 once I know how to proceed ):

"[PATCH v3 2/4] ARM: mach-moxart: add MOXA ART device tree files" -
http://lists.infradead.org/pipermail/linux-arm-kernel/2013-July/181757.html

Can it remain as a part of that set?

Or should it be moved here to a new v4 patch?

Changes are available in my public git repository, see
Documentation/devicetree/bindings/rtc/moxa,moxart-rtc.txt:

http://code.google.com/p/linux-next-20130703-moxart/source/detail?r=55b2a92724f36ecc852208bb1f8e1b7bd7c7904b

Best regards,
Jonas
