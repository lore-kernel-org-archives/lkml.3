Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756941Ab3GEBRZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 21:17:25 -0400
Received: from mail-oa0-f44.google.com ([209.85.219.44]:44748 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750959Ab3GEBRX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 21:17:23 -0400
MIME-Version: 1.0
In-Reply-To: <20130704.142951.1908678475285188106.davem@davemloft.net>
References: <20130704210434.GA6381@Linus-Debian>
	<20130704.142951.1908678475285188106.davem@davemloft.net>
Date: Fri, 5 Jul 2013 09:17:22 +0800
Message-ID: <CAM_iQpWPDH3XGjtHXAjBjtp2bBfqKC6YPK=R_rGDMV0rjrgaxw@mail.gmail.com>
Subject: Re: 'rmmod -f ipv6': BUG: unable to handle kernel paging request
From: Cong Wang <xiyou.wangcong@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: linus.luessing@web.de,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 5, 2013 at 5:29 AM, David Miller <davem@davemloft.net> wrote:
> From: Linus Lüssing <linus.luessing@web.de>
> Date: Thu, 4 Jul 2013 23:04:34 +0200
>
>> When trying to perform a forceful unload of an ipv6 kernel module
>> on a 3.10 kernel then I'm getting a kernel panic with the attached
>> trace.
>>
>> Is this supposed to happen due to the '-f' option or is this a bug
>> in the ipv6 code?
>
> The ipv6 module is not capable of being unloaded, sorry.
>

If so, we should remove inet6_exit()...
