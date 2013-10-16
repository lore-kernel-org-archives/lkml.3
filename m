Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760215Ab3JPIZR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 04:25:17 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:48785 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757316Ab3JPIZO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 04:25:14 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkdYTJ_JQvFmf+AuCxmk5kGGw_CLGn0-xnO+PqGav45Se3Q@mail.gmail.com>
References: <1381515273-25466-1-git-send-email-acourbot@nvidia.com>
	<1381515273-25466-2-git-send-email-acourbot@nvidia.com>
	<CACRpkdYTJ_JQvFmf+AuCxmk5kGGw_CLGn0-xnO+PqGav45Se3Q@mail.gmail.com>
Date: Wed, 16 Oct 2013 10:25:13 +0200
Message-ID: <CACRpkdZUPGQq_9o0Qfjh3rC8rGcWOJa8WNqWHwirye9of-TnEw@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] gpiolib: export descriptor-based GPIO interface
From: Linus Walleij <linus.walleij@linaro.org>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Grant Likely <grant.likely@linaro.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Alexandre Courbot <gnurou@gmail.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 16, 2013 at 10:11 AM, Linus Walleij
<linus.walleij@linaro.org> wrote:

> Would you mind rebasing this on top of my "devel" branch?

Or wait ... if it depends on the two fixes I just sent off to Torvalds
as well, you'd better use my for-next branch, so I have it on top of
everything.

Yours,
Linus Walleij
