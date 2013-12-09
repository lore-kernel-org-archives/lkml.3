Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932661Ab3LIOyN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 09:54:13 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:32273 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1760952Ab3LIOyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 09:54:08 -0500
Date: Mon, 9 Dec 2013 09:54:04 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, stable <stable@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Clark Williams <williams@redhat.com>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        "Luis Claudio R. Goncalves" <lclaudio@uudg.org>
Subject: Re: [BUG] stable v3.10.16+ introduced by "ip6tnl: allow to use rtnl
 ops on fb tunnel"
Message-ID: <20131209095404.11b6d38f@gandalf.local.home>
In-Reply-To: <20131209094850.4e97e370@gandalf.local.home>
References: <20131113211430.1ad3bb7d@gandalf.local.home>
	<20131209002531.GB14382@kroah.com>
	<20131209094850.4e97e370@gandalf.local.home>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Dec 2013 09:48:50 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:
sit interfaces.
> 
> CC: Willem de Bruijn <willemb@google.com>
> Reported-by: Steven Rostedt <rostedt@goodmis.org>
> Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>

Note, this is missing:

    Acked-by: Willem de Bruijn <willemb@google.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>

from the real commit. That's because I backported the original email,
not the commit that was added to git.

-- Steve

> ---
>  net/ipv6/ip6_tunnel.c | 18 +++++++++++++-----
>  1 file changed, 13 insertions(+), 5 deletions(-)
> 
