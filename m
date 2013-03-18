Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751894Ab3CRN0Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 09:26:16 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:55506 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751156Ab3CRN0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 09:26:15 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 72.84.113.162
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19uyfmVeQ6mNmubTpZ5IJDiatdmrwd9y/Q=
Date: Mon, 18 Mar 2013 09:26:12 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
Cc: Andrew Lunn <andrew@lunn.ch>, Daniel Lezcano <daniel.lezcano@linaro.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers: cpuidle: Use devm_ioremap_resource function
Message-ID: <20130318132612.GI13280@titan.lakedaemon.net>
References: <1363444761-3641-1-git-send-email-gheorghiuandru@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363444761-3641-1-git-send-email-gheorghiuandru@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 16, 2013 at 04:39:21PM +0200, Alexandru Gheorghiu wrote:
> Use devm_ioremap_resource function, which provides better error handling,
> instead of devm_request_and_ioremap.
> Patch found using coccinelle.
> 
> Signed-off-by: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
> ---
>  drivers/cpuidle/cpuidle-kirkwood.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)

Acked-by: Jason Cooper <jason@lakedaemon.net>

thx,

Jason.
