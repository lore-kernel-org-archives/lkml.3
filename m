Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759255Ab3K1Pmh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 10:42:37 -0500
Received: from mail-ob0-f181.google.com ([209.85.214.181]:52875 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756190Ab3K1Pmf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 10:42:35 -0500
MIME-Version: 1.0
In-Reply-To: <CACRpkda-TtKQr6hDx4corjxYv7r7f6_9sNp_2ocbvg9MHyOk7Q@mail.gmail.com>
References: <1385628388-23827-1-git-send-email-acourbot@nvidia.com>
	<CACRpkda-TtKQr6hDx4corjxYv7r7f6_9sNp_2ocbvg9MHyOk7Q@mail.gmail.com>
Date: Thu, 28 Nov 2013 17:42:35 +0200
Message-ID: <CAHp75Vc_NZiukvRaBUkexQXTsAij1ZcPGHDBMBeN-a5m77k=jA@mail.gmail.com>
Subject: Re: [PATCH] gpio: better lookup method for platform GPIOs
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Alexandre Courbot <acourbot@nvidia.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Rhyland Klein <rklein@nvidia.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 28, 2013 at 4:45 PM, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Thu, Nov 28, 2013 at 9:46 AM, Alexandre Courbot <acourbot@nvidia.com> wrote:

[]

>> Let's change this bad design before more users start using it. ;)
>
> OK given that Mika has based his patches on this

Not only him, since I\have started to look for SFI GPIO solution :-)

P.S. Whenever Mika ACKs I will agree with that.

-- 
With Best Regards,
Andy Shevchenko
