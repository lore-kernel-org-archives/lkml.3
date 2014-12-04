Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753139AbaLDIr1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 03:47:27 -0500
Received: from mail-ie0-f175.google.com ([209.85.223.175]:58350 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751785AbaLDIr0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 03:47:26 -0500
MIME-Version: 1.0
In-Reply-To: <50B33AC5ED75F74F991980326F1C438D0FC6DDED@PGSMSX108.gar.corp.intel.com>
References: <1416977280-27319-1-git-send-email-rebecca.swee.fun.chang@intel.com>
 <1416977280-27319-4-git-send-email-rebecca.swee.fun.chang@intel.com>
 <CACRpkdba0XparJCKrV9XrU3dxTnuWhEYGQQMKzi+SDEiOAsapQ@mail.gmail.com> <50B33AC5ED75F74F991980326F1C438D0FC6DDED@PGSMSX108.gar.corp.intel.com>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Thu, 4 Dec 2014 17:47:05 +0900
Message-ID: <CAAVeFuKFHoEFYa7FizROTwQLOPqHO0ArAMJC8t7tzEYgMcV05Q@mail.gmail.com>
Subject: Re: [PATCHv4 3/3] gpio: sch: Enable IRQ support for Quark X1000
To: "Chang, Rebecca Swee Fun" <rebecca.swee.fun.chang@intel.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        GPIO Subsystem Mailing List <linux-gpio@vger.kernel.org>,
        "Westerberg, Mika" <mika.westerberg@intel.com>,
        Denis Turischev <denis.turischev@compulab.co.il>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 3, 2014 at 11:26 AM, Chang, Rebecca Swee Fun
<rebecca.swee.fun.chang@intel.com> wrote:
> Hi Linus,
> Noted, while I continue to work on this IRQ feature, can I resend patch 1 and patch 2 (rebase to devel branch) in v5 thread so that you can pull them in first?

Yes, please do so. The first two patches are independant from this
feature and it will allow everyone to get them off their head.
