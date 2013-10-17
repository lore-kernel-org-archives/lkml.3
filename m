Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755473Ab3JQMyk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 08:54:40 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:45839 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755204Ab3JQMyj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 08:54:39 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 108.39.110.144
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19L1IyUiw9M2QYtjhgFbVdEzurVU1IQZWY=
Date: Thu, 17 Oct 2013 08:54:14 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Cc: andrew@lunn.ch, linux@arm.linux.org.uk, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] arm: plat-orion: remove deprecated IRQF_DISABLED
Message-ID: <20131017125414.GB22434@titan.lakedaemon.net>
References: <1381549760-5432-1-git-send-email-michael.opdenacker@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381549760-5432-1-git-send-email-michael.opdenacker@free-electrons.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 12, 2013 at 05:49:20AM +0200, Michael Opdenacker wrote:
> This patch proposes to remove the use of the IRQF_DISABLED flag
> 
> It's a NOOP since 2.6.35 and it will be removed one day.
> 
> Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
> ---
>  arch/arm/plat-orion/time.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Applied to mvebu/soc

thx,

Jason.
