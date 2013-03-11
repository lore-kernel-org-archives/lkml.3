Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752962Ab3CKNqb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 09:46:31 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:39024 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751695Ab3CKNq3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 09:46:29 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 72.84.113.162
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18Dl539oxd4HnjFW4Ufjb3eVOa4GQFlUAQ=
Date: Mon, 11 Mar 2013 09:46:21 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Silviu-Mihai Popescu <silviupopescu1990@gmail.com>
Cc: cpufreq@vger.kernel.org, rjw@sisk.pl, rui.zhang@intel.com, andrew@lunn.ch,
        rob.lee@linaro.org, len.brown@intel.com, khilman@ti.com,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kirkwood: fix coccicheck warnings
Message-ID: <20130311134621.GA23237@titan.lakedaemon.net>
References: <1362987319-6369-1-git-send-email-silviupopescu1990@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362987319-6369-1-git-send-email-silviupopescu1990@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 11, 2013 at 09:35:19AM +0200, Silviu-Mihai Popescu wrote:
> Convert all uses of devm_request_and_ioremap() to the newly introduced
> devm_ioremap_resource() which provides more consistent error handling.
> 
> devm_ioremap_resource() provides its own error messages so all explicit
> error messages can be removed from the failure code paths.
> 
> Signed-off-by: Silviu-Mihai Popescu <silviupopescu1990@gmail.com>
> ---
>  drivers/cpufreq/kirkwood-cpufreq.c |    8 +++-----
>  drivers/cpuidle/cpuidle-kirkwood.c |    6 +++---
>  drivers/thermal/kirkwood_thermal.c |    8 +++-----
>  3 files changed, 9 insertions(+), 13 deletions(-)

Acked-by: Jason Cooper <jason@lakedaemon.net>

thx,

Jason.
