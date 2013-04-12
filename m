Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754108Ab3DLIlh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 04:41:37 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:55042 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753329Ab3DLIlf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 04:41:35 -0400
MIME-Version: 1.0
In-Reply-To: <201304121008.51300.arnd@arndb.de>
References: <1365669779-14953-1-git-send-email-linus.walleij@stericsson.com>
	<201304111633.54110.arnd@arndb.de>
	<CACRpkdaUMtNjODOGZ2TA+DKnA-T4TsTjhgM4TxaKV7N6fswVaQ@mail.gmail.com>
	<201304121008.51300.arnd@arndb.de>
Date: Fri, 12 Apr 2013 10:41:34 +0200
Message-ID: <CACRpkdatbhais8gP3rTRkz0Y1v816Uz8KL6ZhDsh+ByfbjXuxg@mail.gmail.com>
Subject: Re: [PATCH] MFD: ab8500: pass AB8500 IRQ to debugfs code by resource
From: Linus Walleij <linus.walleij@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Anmar Oueja <anmar.oueja@linaro.org>, Lee Jones <lee.jones@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 12, 2013 at 10:08 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Friday 12 April 2013, Linus Walleij wrote:

>> Actually, well, this one IRQ (the one I start to pass) is already
>> domain-mapped to the global IRQ numberspace, so that one will
>> be correct.
>
> I don't know if we're talking about the same thing here.
>
> My point was that passing a domain-mapped IRQ number into mfd_add_devices
> with another domain will result in the attempt to map that number into
> another domain, which does not work.

Ah, yes you're right ... now I need to find some other way
to pass this resource ... hm.

Yours,
Linus Walleij
