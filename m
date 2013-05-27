Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932239Ab3E0MUn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 08:20:43 -0400
Received: from mail.us.es ([193.147.175.20]:42762 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932177Ab3E0MUl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 08:20:41 -0400
X-Qmail-Scanner-Diagnostics: from 127.0.0.1 by antivirus3 (envelope-from <pneira@us.es>, uid 501) with qmail-scanner-2.10 
 (clamdscan: 0.97.8/17272. spamassassin: 3.3.2.  
 Clear:RC:1(127.0.0.1):SA:0(-97.2/7.5):. 
 Processed in 5.232836 secs); 27 May 2013 12:20:39 -0000
X-Envelope-From: pneira@us.es
Date: Mon, 27 May 2013 14:20:33 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Jiri Slaby <jslaby@suse.cz>
Cc: jirislaby@gmail.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, Jeff Mahoney <jeffm@suse.com>,
        Patrick McHardy <kaber@trash.net>,
        "David S. Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org
Subject: Re: [PATCH -resend 4/6] netfilter: Implement RFC 1123 for FTP
 conntrack
Message-ID: <20130527122033.GA16107@localhost>
References: <1369227552-11743-1-git-send-email-jslaby@suse.cz>
 <1369227552-11743-4-git-send-email-jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1369227552-11743-4-git-send-email-jslaby@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 22, 2013 at 02:59:10PM +0200, Jiri Slaby wrote:
> From: Jeff Mahoney <jeffm@suse.com>
> 
>  The FTP conntrack code currently only accepts the following format for
>  the 227 response for PASV:
>  227 Entering Passive Mode (148,100,81,40,31,161).
> 
>  It doesn't accept the following format from an obscure server:
>  227 Data transfer will passively listen to 67,218,99,134,50,144
> 
>  From RFC 1123:
>  The format of the 227 reply to a PASV command is not
>  well standardized.  In particular, an FTP client cannot
>  assume that the parentheses shown on page 40 of RFC-959
>  will be present (and in fact, Figure 3 on page 43 omits
>  them).  Therefore, a User-FTP program that interprets
>  the PASV reply must scan the reply for the first digit
>  of the host and port numbers.

Applied, thanks.
