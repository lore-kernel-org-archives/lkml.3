Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758369Ab3DYMGh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 08:06:37 -0400
Received: from mail-ia0-f180.google.com ([209.85.210.180]:51203 "EHLO
	mail-ia0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755185Ab3DYMGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 08:06:35 -0400
MIME-Version: 1.0
In-Reply-To: <20130418223344.GB8798@zurbaran>
References: <1366012021-9039-1-git-send-email-linus.walleij@stericsson.com>
	<20130418223344.GB8798@zurbaran>
Date: Thu, 25 Apr 2013 14:06:35 +0200
Message-ID: <CACRpkdZd2wGUR=kMeFBJxhDZrWcX-8mEk+_jvjj5PFQdAK-zmg@mail.gmail.com>
Subject: Re: [PATCH v3] MFD: ab8500: pass AB8500 IRQ to debugfs code by resource
From: Linus Walleij <linus.walleij@linaro.org>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Anmar Oueja <anmar.oueja@linaro.org>, Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 19, 2013 at 12:33 AM, Samuel Ortiz <sameo@linux.intel.com> wrote:

>> Sam this would have to go into the v3.10-targetted stuff...
>> Either immediately before you send it upstream or as a fixup.
>
> I usually try to send one single pull request during the merge window, so I'll
> add this one to my 3.10 MFD fixup pull request.

But the merge winow isn't even open yet ... now you will break it in the
merge window and the un-break it later. Well whatever as long as it
gets fixed. But it causes some annoyance when trying to bisect in the
merge window.

Yours,
Linus Walleij
