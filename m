Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754433AbaDFQsa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2014 12:48:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42827 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754002AbaDFQs2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2014 12:48:28 -0400
Message-ID: <53418551.1000507@redhat.com>
Date: Sun, 06 Apr 2014 18:48:17 +0200
From: Daniel Borkmann <dborkman@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Sergei Trofimovich <slyich@gmail.com>
CC: linux-kernel@vger.kernel.org, Sergei Trofimovich <slyfox@gentoo.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH] cpts: add missing <linux/if_vlan.h>
References: <1396785331-26875-1-git-send-email-slyich@gmail.com>
In-Reply-To: <1396785331-26875-1-git-send-email-slyich@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/06/2014 01:55 PM, Sergei Trofimovich wrote:
> From: Sergei Trofimovich <slyfox@gentoo.org>
>
> gcc complains as:
>      drivers/net/ethernet/ti/cpts.c: In function 'cpts_match':
>      drivers/net/ethernet/ti/cpts.c:266:12: error: 'ETH_HLEN' undeclared (first use in this function)
>      drivers/net/ethernet/ti/cpts.c:266:12: note: each undeclared identifier is reported only once for each function it appears in
>      drivers/net/ethernet/ti/cpts.c:276:23: error: 'VLAN_HLEN' undeclared (first use in this function)
>
> Signed-off-by: Sergei Trofimovich <slyfox@gentoo.org>
> CC: "David S. Miller" <davem@davemloft.net>
> CC: netdev@vger.kernel.org

Thanks, fix is already in net tree:

https://git.kernel.org/cgit/linux/kernel/git/davem/net.git/commit/?id=79eb9d28c9b22fa419e2c3f1b2cc6e285720ae41
