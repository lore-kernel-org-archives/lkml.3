Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757403Ab3FDPNA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 11:13:00 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:56549 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753109Ab3FDPM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 11:12:58 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH, resend] pch_phub: re-use native MAC address parser
Date: Tue, 04 Jun 2013 17:12:53 +0200
Message-ID: <3998159.hQfFS0IV84@wuerfel>
User-Agent: KMail/4.10.3 (Linux/3.9.0-2-generic; KDE/4.10.3; x86_64; ; )
In-Reply-To: <CAHp75VdrsbPfAx8z2nhAtD2dj-YA9b9bZ-MiYW-aNndTFRRHgg@mail.gmail.com>
References: <1369756498-5670-1-git-send-email-andriy.shevchenko@linux.intel.com> <3489856.nvZgTyoe0K@wuerfel> <CAHp75VdrsbPfAx8z2nhAtD2dj-YA9b9bZ-MiYW-aNndTFRRHgg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:cZH9vy9NkUpqT3RHIayqd7C76dgLC6M+hppmB2c/x9L
 HFwzBSn5kDZfyfzecJLyFklEhk9+AgixeCh0QE6YmuWuKTAqlS
 HzHJkAEXRel/lZhakN+G9E9NPWmn399vwPt9sQI0FNMFkqhhgx
 VtxL1DUC1q6Vm+3taGfoHVKvwIYp6WgGmaV7w377+f8NB3ZicA
 j+591+ML7wQSGz0UvAAC8XAULGb4z2Y/OapyRKcX+ogMuHx5Q2
 7uPVg397SBIX7iDdp7ZdTdQ7WkmaGgMVlTKUutyHt8MY39S6/F
 dyQ151Hqxbrc2YRct+3ZH7WENzdBOEHCumYAWVtKcROXXMCd2E
 TLrNxvE4ifd2fwDwpGWU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 04 June 2013 17:57:38 Andy Shevchenko wrote:
> On Tue, Jun 4, 2013 at 5:38 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> > On Tuesday 04 June 2013 17:21:16 Andy Shevchenko wrote:

> >> It seems proper solution is to move mac_pton() outside of CONFIG_NET,
> >> though I don't know how to do this easily.
> >
> > If we want to use it outside of CONFIG_NET, it cannot be part of net/core/*.c.
> > Maybe we can move the function to lib/mac_pton.c instead and create a
> > Kconfig symbol that gets selected by CONFIG_NET and by any driver lib
> > PCH_PHUB that needs it.
> 
> Sounds like a solution. Would you like me to implement this?

Yes, that would be good.

Thanks,

	Arnd
