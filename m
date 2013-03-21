Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933524Ab3CUPZ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 11:25:26 -0400
Received: from casper.infradead.org ([85.118.1.10]:51037 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753703Ab3CUPZW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 11:25:22 -0400
Date: Thu, 21 Mar 2013 15:25:18 +0000
From: Thomas Graf <tgraf@suug.ch>
To: David Miller <davem@davemloft.net>
Cc: avagin@openvz.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        xemul@parallels.com, edumazet@google.com, paulmck@linux.vnet.ibm.com,
        dhowells@redhat.com
Subject: Re: [PATCH] net: fix *_DIAG_MAX constants
Message-ID: <20130321152518.GG9046@casper.infradead.org>
References: <1363875500-14574-1-git-send-email-avagin@openvz.org>
 <20130321144218.GF9046@casper.infradead.org>
 <20130321.111437.2012746070698745131.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130321.111437.2012746070698745131.davem@davemloft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <tgraf@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/21/13 at 11:14am, David Miller wrote:
> So you're ACK'ing a patch that makes changes to files that don't even
> exist in the repository?

I have been ACK'ing the patch in the context of the previous
patch that I reviewed in the first place which in summary is
now OK. But you are obviously right that a fixed version of
the initial patch should be submitted instead.
