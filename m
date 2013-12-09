Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760964Ab3LIL0f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 06:26:35 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:37385 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753358Ab3LIL0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 06:26:33 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 108.39.110.144
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+BPKTghA9S+NrobaxC2dkKUi1ysHqCtnk=
Date: Mon, 9 Dec 2013 06:26:10 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Cc: andrew@lunn.ch, linux@arm.linux.org.uk, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] arm: plat-orion: remove deprecated IRQF_DISABLED
Message-ID: <20131209112610.GD10053@titan.lakedaemon.net>
References: <1381549760-5432-1-git-send-email-michael.opdenacker@free-electrons.com>
 <20131017125414.GB22434@titan.lakedaemon.net>
 <52A55187.3050907@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52A55187.3050907@free-electrons.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 09, 2013 at 06:13:43AM +0100, Michael Opdenacker wrote:
> Hi Jason,
> 
> On 10/17/2013 02:54 PM, Jason Cooper wrote:
> > On Sat, Oct 12, 2013 at 05:49:20AM +0200, Michael Opdenacker wrote:
> >> This patch proposes to remove the use of the IRQF_DISABLED flag
> >>
> >> It's a NOOP since 2.6.35 and it will be removed one day.
> >>
> >> Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
> >> ---
> >>  arch/arm/plat-orion/time.c | 2 +-
> >>  1 file changed, 1 insertion(+), 1 deletion(-)
> > Applied to mvebu/soc
> 
> Oops, I don't see this patch in mainline yet.
> 
> It is still in the tree? Did it just miss the last merge window?

Yep, It's currently in mvebu/soc and arm-soc/mvebu/soc

  eb4d552b933a arm: plat-orion: remove deprecated IRQF_DISABLED

thx,

Jason.
