Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751422Ab3HSU6C (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 16:58:02 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:18368 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852Ab3HSU57 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 16:57:59 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 72.84.113.162
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+w2Qbd5Vw5ZWf5Z2SwaoH+lrSET2ZvmNw=
Date: Mon, 19 Aug 2013 16:57:36 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: andrew@lunn.ch, gregory.clement@free-electrons.com,
        linux-arm-kernel@lists.infradead.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: linux-next: manual merge of the mvebu tree with the arm-soc
 tree
Message-ID: <20130819205736.GA13964@titan.lakedaemon.net>
References: <20130819160537.1eeb0a9ebc269def138e016b@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130819160537.1eeb0a9ebc269def138e016b@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Mon, Aug 19, 2013 at 04:05:37PM +1000, Stephen Rothwell wrote:
> Today's linux-next merge of the mvebu tree got conflicts in various files
> between merges and commits in the arm-soc tree and merges in the mvebu
> tree.

I'm afraid I'm a bit lost...

> These merges/commits in the mvebu tree appear to be from a previous
> version of the arm-soc tree that the mvebu tree has been rebased upon.
> Please don't do that - the arm-soc tree as a whole is not stable.

I didn't do anything different from the other times I built for-next.
Could you give me a specific example when you build linux-next again?
I'll certainly try to avoid it in the future, but it'll be easier if I
know what 'it' is. ;-)

I'll not change for-next today, and we'll see how it goes.

thx,

Jason.
