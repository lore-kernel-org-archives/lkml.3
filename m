Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760793Ab3LIIal (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 03:30:41 -0500
Received: from mail-ob0-f175.google.com ([209.85.214.175]:37904 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759949Ab3LIIaj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 03:30:39 -0500
MIME-Version: 1.0
In-Reply-To: <1386565230-19228-1-git-send-email-michael.opdenacker@free-electrons.com>
References: <1381550411-5824-1-git-send-email-michael.opdenacker@free-electrons.com>
	<1386565230-19228-1-git-send-email-michael.opdenacker@free-electrons.com>
Date: Mon, 9 Dec 2013 09:30:38 +0100
Message-ID: <CACRpkdb5EchUkdA4vUnyaWp5AS2b1p6UNcA9emwivDTxQzPzuw@mail.gmail.com>
Subject: Re: [PATCH][RESEND] ARM: misc: remove deprecated IRQF_DISABLED
From: Linus Walleij <linus.walleij@linaro.org>
To: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Greg Ungerer <gerg@uclinux.org>, Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 9, 2013 at 6:00 AM, Michael Opdenacker
<michael.opdenacker@free-electrons.com> wrote:

> This patch proposes to remove the use of the IRQF_DISABLED flag
> from miscellaneous code in mach-xxx and plat-xxx
>
> This flag is a NOOP since 2.6.35 and it will be removed one day.
>
> Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
