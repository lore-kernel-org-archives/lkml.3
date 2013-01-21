Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755640Ab3AUShN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 13:37:13 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:13026 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752685Ab3AUShK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 13:37:10 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+9L56JvI8Se0G9vcsfN1nO
Date: Mon, 21 Jan 2013 10:37:07 -0800
From: Tony Lindgren <tony@atomide.com>
To: Jon Hunter <jon-hunter@ti.com>
Cc: Pantelis Antoniou <panto@antoniou-consulting.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Benoit Cousson <b-cousson@ti.com>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, Matt Porter <mporter@ti.com>,
        Russ Dill <Russ.Dill@ti.com>, Koen Kooi <koen@dominion.thruhere.net>,
        Joel A Fernandes <agnel.joel@gmail.com>,
        Rob Clark <robdclark@gmail.com>,
        Jason Kridner <jkridner@beagleboard.org>,
        Matt Ranostay <mranostay@gmail.com>
Subject: Re: [PATCH] omap: DT node Timer iteration fix
Message-ID: <20130121183706.GJ22517@atomide.com>
References: <1357651902-21966-1-git-send-email-panto@antoniou-consulting.com>
 <50EDEB64.4060800@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50EDEB64.4060800@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jon Hunter <jon-hunter@ti.com> [130109 14:15]:
> Hi Pantelis,
> 
> On 01/08/2013 07:31 AM, Pantelis Antoniou wrote:
> > The iterator correctly handles of_node_put() calls.
> > Remove it before continue'ing the loop.
> > Without this patch you get:
> 
> Thanks for the fix!
> 
> May be worth mentioning that this will only be seen with
> "CONFIG_OF_DYNAMIC" (and explains why I did not catch this one!).

Thanks I'll update the description and apply into omap-for-v3.8-rc4/fixes.

Regards,

Tony
