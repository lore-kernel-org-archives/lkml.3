Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423271Ab3FUPW0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 11:22:26 -0400
Received: from merlin.infradead.org ([205.233.59.134]:41477 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423160Ab3FUPWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 11:22:24 -0400
Message-ID: <51C46F9C.7020500@infradead.org>
Date: Fri, 21 Jun 2013 08:22:04 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jesse Gross <jesse@nicira.com>, dev@openvswitch.org
Subject: Re: linux-next: Tree for Jun 21 (netdev: openvswitch)
References: <20130621181721.11783d80583444868725b62c@canb.auug.org.au>
In-Reply-To: <20130621181721.11783d80583444868725b62c@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/21/13 01:17, Stephen Rothwell wrote:
> Hi all,
> 
> Happy solstice!
> 
> Changes since 20130620:
> 

when CONFIG_INET is not enabled:

  CC      net/openvswitch/flow.o
In file included from net/openvswitch/flow.c:43:0:
include/net/ip_tunnels.h: In function 'tunnel_ip_select_ident':
include/net/ip_tunnels.h:155:3: error: implicit declaration of function '__ip_select_ident' [-Werror=implicit-function-declaration]



-- 
~Randy
