Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933582Ab3GPRes (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 13:34:48 -0400
Received: from b.ns.miles-group.at ([95.130.255.144]:1660 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933481Ab3GPRer (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 13:34:47 -0400
Message-ID: <51E58431.5030708@nod.at>
Date: Tue, 16 Jul 2013 19:34:41 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Ramkumar Ramachandra <artagnon@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>, Jeff Dike <jdike@addtoit.com>
Subject: Re: [PATCH] um/configs: don't use devtmpfs in defconfig
References: <1373993525-25629-1-git-send-email-artagnon@gmail.com> <51E57BC1.4090904@nod.at> <CALkWK0nrDsZiHe2==DQZuHV7id=6gc4UHUj1xXu9jN5cr3SUcQ@mail.gmail.com> <51E57DF3.90304@nod.at> <CALkWK0m0LkjFzOUXRQmdDuS+L7mKA87qCMq=MYX6UrnHXi+XRg@mail.gmail.com> <CALkWK0=qw_K=6+6btjzcMS9VmDdVbF++rN=3-=Kgzu-3xSErrQ@mail.gmail.com> <CALkWK0kN8Lprp5RoBSjBngJG08LwbVy-oaWaHfzLHZc_OMueyA@mail.gmail.com>
In-Reply-To: <CALkWK0kN8Lprp5RoBSjBngJG08LwbVy-oaWaHfzLHZc_OMueyA@mail.gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 16.07.2013 19:31, schrieb Ramkumar Ramachandra:
> Ramkumar Ramachandra wrote:
>> Ramkumar Ramachandra wrote:
>>> No, systemd does not have a hard dependency on devtmpfs.
>>
>> Wait, let me double-check that.
> 
> Sorry about the stupidity; devtmpfs is very much a hard dependency.  I
> just realized that CONFIG_VT is on, and can't be turned off (!).  See
> drivers/tty/Kconfig:
> 
>   config VT
>   	  bool "Virtual terminal" if EXPERT
> 	  depends on !S390 && !UML
> 
> Wait, shouldn't it be always off then?

/me hands you a fresh cup of coffee over. :-)
Please note the depends on !UML.

Thanks,
//richard
