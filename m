Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752045AbaLRGyV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 01:54:21 -0500
Received: from mail-la0-f50.google.com ([209.85.215.50]:43111 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113AbaLRGyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 01:54:19 -0500
MIME-Version: 1.0
In-Reply-To: <20141216164527.GA21863@redhat.com>
References: <1418575877-21488-1-git-send-email-mst@redhat.com>
	<CAFiDJ5_fGWx2E1jvU+k0Tv_esRpWmC-p+kq7Y_VOr5bx2ZUFzg@mail.gmail.com>
	<20141215101703.GA26156@redhat.com>
	<CAFiDJ5_BSMXBsv0gmzogyJi1x9-4vAhPpZBwn-_CHYDs0pOfvA@mail.gmail.com>
	<20141216164527.GA21863@redhat.com>
Date: Thu, 18 Dec 2014 14:54:17 +0800
X-Google-Sender-Auth: 6oPqZYGFiKjhPpRW5MyxVLar0Ec
Message-ID: <CAFiDJ5862C1bjeh+jAp2saJHUtTBOvjp9Vz2PvfuwZ2MBocFQw@mail.gmail.com>
Subject: Re: [PATCH 00/18] uaccess: fix sparse warning on get_user for bitwise types
From: Ley Foon Tan <lftan@altera.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Linux-Arch <linux-arch@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 17, 2014 at 12:45 AM, Michael S. Tsirkin <mst@redhat.com> wrote:
> On Tue, Dec 16, 2014 at 02:06:50PM +0800, Ley Foon Tan wrote:
>> On Mon, Dec 15, 2014 at 6:17 PM, Michael S. Tsirkin <mst@redhat.com> wrote:
>> > Thanks for the heads up.
>> > No - it will probably need a similar fix for __get_user and get_user.
>> > It's just a parse warning so it's not a blocker.
>> > Can you fix it yourself or prefer me to?
>> Do you have newer revision of this series?
>> If yes, then it is great if you can include it. Otherwise, I can fix it.
>>
>> Regards
>>
>> Ley Foon
>
> Arnd said he'll merge whatever is not fixed in -rc1 through his tree for
> 3.20.
> So it's up to you - fix it up in your tree before -rc1 or wait for
> mer to fix it after rc1 and have Arnd merge it for 3.20.
I will fix it in nios2 tree.

Thanks.

Regards
Ley Foon
