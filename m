Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755731Ab3CSNda (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 09:33:30 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:57377 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751860Ab3CSNd3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 09:33:29 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 72.84.113.162
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18XXvNKIfnpvwgk6dJ4XDzn9Ghx7OTCe9w=
Date: Tue, 19 Mar 2013 09:33:24 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-arm-kernel@lists.infradead.org, thomas.petazzoni@free-electrons.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "yrl.pp-manager.tt@hitachi.com" <yrl.pp-manager.tt@hitachi.com>
Subject: Re: [BUG][mvebu] mvneta: cannot request irq 25 on openblocks-ax3
Message-ID: <20130319133324.GS13280@titan.lakedaemon.net>
References: <51486445.8040506@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51486445.8040506@hitachi.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 19, 2013 at 10:12:37PM +0900, Masami Hiramatsu wrote:
> Hi,
> 
> Here I've hit a bug on the recent kernel. As far as I know, this bug
> exists on 3.9-rc1 too.
> 
> When I tried the latest mvebu for-next tree
> (git://git.infradead.org/users/jcooper/linux.git mvebu/for-next),

FYI: that branch isn't stable, it's used as a merge-test of
arm-soc/for-next (also not stable) and any branches I am trying to push
upstream that day.

Gregory has a patch in the works for this.  Hopefully he'll submit
it by the end of the week.

thx,

Jason.
