Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754753Ab3HaS55 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Aug 2013 14:57:57 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:62329 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753088Ab3HaS5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Aug 2013 14:57:55 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH] Remove support for score architecture
Date: Sat, 31 Aug 2013 20:55:16 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Jiang Liu <jiang.liu@huawei.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Lennox Wu <lennox.wu@gmail.com>, Chen Liqin <liqin.chen@sunplusct.com>,
        Liqin Chen <liqin299@gmail.com>
References: <1377914435-24206-1-git-send-email-linux@roeck-us.net>
In-Reply-To: <1377914435-24206-1-git-send-email-linux@roeck-us.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201308312055.17209.arnd@arndb.de>
X-Provags-ID: V02:K0:MpwDYsI2ewTtkqu0JBavJk9wg+PdOJjnlBfxWFDT3jn
 CQ+yYn1K1EFtLH9j+IHJ/aDZRj9LAdCsudrRB6AV9E8u7vqhab
 vRFXoaKv0V95UtBvvbKnDb0sONpA9JgVYSQE99oaqs7al9VNiW
 jVDXYTHcugsojwl0jWKtgNh6IT/aDu/ktJ71tIQ2zl4DkbAsgt
 0JOqel+eD8+smd9LS+LGQ7rMnbRxZFv23RTEbivVKx6EU36etL
 YaYP6bBg5oqUzQYWzjhXutiSyYSd2NcuhxMBWj6O5zYoDLkxmf
 jKhtPWY7Sj5SeskoAlU/RJErFtXywhDj4ijZvxs6D6x0/ZWh4T
 2D4uYmzuHNzxikPzcKa4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 31 August 2013, Guenter Roeck wrote:
> The web site associated with the score architecture in MAINTAINERS
> is non-functional and available for sale. The last Ack from one
> of the maintainers was in December 2012. The main maintainer's last
> commit was in 2011. The last maintainer pull request was early 2011.
> 
> Cc: Lennox Wu <lennox.wu@gmail.com>
> Cc: Chen Liqin <liqin.chen@sunplusct.com>
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> ---
> More housekeeping.
> 
> Maybe this removal request is a bit early, but architecture support seems
> to have vanished entirely. At the very least this puts interested parties
> (if there are any) on notice.

AFAICT, this is the least maintained architecture we have at the moment,
and your analysis is correct.

I think it can be removed unless we the maintainers have plans to become
more active in the future or someone else steps up to maintain the
architecture.

Acked-by: Arnd Bergmann <arnd@arndb.de>
