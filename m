Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933684Ab3CUOmX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 10:42:23 -0400
Received: from casper.infradead.org ([85.118.1.10]:50675 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933538Ab3CUOmV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 10:42:21 -0400
Date: Thu, 21 Mar 2013 14:42:18 +0000
From: Thomas Graf <tgraf@suug.ch>
To: Andrey Vagin <avagin@openvz.org>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Pavel Emelyanov <xemul@parallels.com>,
        Eric Dumazet <edumazet@google.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>
Subject: Re: [PATCH] net: fix *_DIAG_MAX constants
Message-ID: <20130321144218.GF9046@casper.infradead.org>
References: <1363875500-14574-1-git-send-email-avagin@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363875500-14574-1-git-send-email-avagin@openvz.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <tgraf@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/21/13 at 06:18pm, Andrey Vagin wrote:
> Follow the common pattern and define *_DIAG_MAX like:
> 
>         [...]
>         __XXX_DIAG_MAX,
> };
> 
> Because everyone is used to do:
> 
>         struct nlattr *attrs[XXX_DIAG_MAX+1];
> 
>         nla_parse([...], XXX_DIAG_MAX, [...]
> 
> Reported-by: Thomas Graf <tgraf@suug.ch>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Pavel Emelyanov <xemul@parallels.com>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> Cc: David Howells <dhowells@redhat.com>
> Signed-off-by: Andrey Vagin <avagin@openvz.org>

Acked-by: Thomas Graf <tgraf@suug.ch>
