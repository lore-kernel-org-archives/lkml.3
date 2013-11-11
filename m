Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753712Ab3KKMwW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 07:52:22 -0500
Received: from mail-bk0-f50.google.com ([209.85.214.50]:37500 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753222Ab3KKMwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 07:52:15 -0500
MIME-Version: 1.0
In-Reply-To: <CAE3RKNng9A6Bp7wa4+6iCprwEQpzGueagLc8iob+aFabJW4nnw@mail.gmail.com>
References: <CAEPa5ym2Xz3F19fJJqNawkRLOKk6Ao6oXrzSrHU051V7p=9otA@mail.gmail.com>
	<CAE3RKNng9A6Bp7wa4+6iCprwEQpzGueagLc8iob+aFabJW4nnw@mail.gmail.com>
Date: Mon, 11 Nov 2013 13:52:13 +0100
Message-ID: <CAEPa5y=tgdGpDMBGY0ijyWSgQ0m5SZW8EMP072OF=sZZUjqN1g@mail.gmail.com>
Subject: Re: bridge not getting ip since 3.11.5 and 3.4.66
From: Mark Trompell <mark@foresightlinux.org>
To: Veaceslav Falico <veaceslav@falico.eu>
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 11, 2013 at 12:07 PM, Veaceslav Falico <veaceslav@falico.eu> wrote:
> On Mon, Nov 11, 2013 at 11:29 AM, Mark Trompell <mark@foresightlinux.org> wrote:
>> my bridge br0 doesn't get an ip from dhcp anymore after 3.11.5 and 3.4.66,
>> What information would be helpful and required to find out what's going wrong.
>
> CC netdev
>
> First thing would be to provide the network scheme. Do you use vlans?
> Which network
> cards/drivers are you using? Do you use some kind of virtualization?
> Is bonding involved?
>
Actually this is my desktop machine using kvm for a virtual machine
that uses eth0 which is connected to the bridge
which is used as interface for the host.

$ ip addr
2. eth0: <BROADCAST,MULTICAST,UP,10000> mtu 1500 qdisc pfifo_fast
master br0 qlen 1000
...
3. br0: <BROADCAST,MULTICAST,UP,10000> mtu 1500 qdisc noqueue
...

Anything else?

Greetings
Mark
