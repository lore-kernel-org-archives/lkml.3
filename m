Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161585Ab3FUXZM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 19:25:12 -0400
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:37749 "HELO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1161490Ab3FUXZL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 19:25:11 -0400
MIME-Version: 1.0
In-Reply-To: <51C46F9C.7020500@infradead.org>
References: <20130621181721.11783d80583444868725b62c@canb.auug.org.au> <51C46F9C.7020500@infradead.org>
From: Jesse Gross <jesse@nicira.com>
Date: Fri, 21 Jun 2013 16:18:11 -0700
Message-ID: <CAEP_g=8Oka3RXns4sazz5hX=nbUvXHgjAHCZkhKcwaNvBHxr-g@mail.gmail.com>
Subject: Re: linux-next: Tree for Jun 21 (netdev: openvswitch)
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "dev@openvswitch.org" <dev@openvswitch.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 21, 2013 at 8:22 AM, Randy Dunlap <rdunlap@infradead.org> wrote:
> On 06/21/13 01:17, Stephen Rothwell wrote:
>> Hi all,
>>
>> Happy solstice!
>>
>> Changes since 20130620:
>>
>
> when CONFIG_INET is not enabled:
>
>   CC      net/openvswitch/flow.o
> In file included from net/openvswitch/flow.c:43:0:
> include/net/ip_tunnels.h: In function 'tunnel_ip_select_ident':
> include/net/ip_tunnels.h:155:3: error: implicit declaration of function '__ip_select_ident' [-Werror=implicit-function-declaration]

Thanks, I just sent out a couple of patches to fix config issues with
the recent tunneling series.
