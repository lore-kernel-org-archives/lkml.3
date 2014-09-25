Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753245AbaIYPWu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 11:22:50 -0400
Received: from mail-oi0-f44.google.com ([209.85.218.44]:50940 "EHLO
	mail-oi0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751921AbaIYPWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 11:22:47 -0400
MIME-Version: 1.0
In-Reply-To: <1411579056-16966-5-git-send-email-will.deacon@arm.com>
References: <1411579056-16966-1-git-send-email-will.deacon@arm.com>
	<1411579056-16966-5-git-send-email-will.deacon@arm.com>
Date: Thu, 25 Sep 2014 19:22:46 +0400
Message-ID: <CAMo8BfJN0VJXsCa92b156KXiX_LbbXGr+mDEokEqH9pwGxKr4g@mail.gmail.com>
Subject: Re: [PATCH v3 04/17] xtensa: io: remove dummy relaxed accessor macros
 for reads
From: Max Filippov <jcmvbkbc@gmail.com>
To: Will Deacon <will.deacon@arm.com>
Cc: Linux-Arch <linux-arch@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Chris Zankel <chris@zankel.net>, Chris Metcalf <cmetcalf@tilera.com>,
        "David S. Miller" <davem@davemloft.net>, Helge Deller <deller@gmx.de>,
        David Howells <dhowells@redhat.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>, heiko.carstens@de.ibm.com,
        "H. Peter Anvin" <hpa@zytor.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        Ingo Molnar <mingo@redhat.com>, Michal Simek <monstr@monstr.eu>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Randy Dunlap <rdunlap@infradead.org>, Sam Ravnborg <sam@ravnborg.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Mikael Starvik <starvik@axis.com>,
        Hirokazu Takata <takata@linux-m32r.org>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Luck <tony.luck@intel.com>,
        daniel.thompson@linaro.org, Mark Brown <broonie@linaro.org>,
        Russell King <linux@arm.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 9:17 PM, Will Deacon <will.deacon@arm.com> wrote:
> These are now defined by asm-generic/io.h, so we don't need the private
> definitions anymore.
>
> Cc: Chris Zankel <chris@zankel.net>
> Cc: Max Filippov <jcmvbkbc@gmail.com>
> Signed-off-by: Will Deacon <will.deacon@arm.com>
> ---
>  arch/xtensa/include/asm/io.h | 7 -------
>  1 file changed, 7 deletions(-)

Acked-by: Max Filippov <jcmvbkbc@gmail.com>

-- 
Thanks.
-- Max
