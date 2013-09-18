Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753385Ab3IRSV6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 14:21:58 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:21755 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752116Ab3IRSV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 14:21:56 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18kALqB6eTpyN8hvbwEZlw6
Date: Wed, 18 Sep 2013 11:21:46 -0700
From: Tony Lindgren <tony@atomide.com>
To: Pali =?utf-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>
Cc: linux-kernel@vger.kernel.org, Aaro Koskinen <aaro.koskinen@iki.fi>,
        linux-omap@vger.kernel.org, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, Nishanth Menon <nm@ti.com>,
        Pavel Machek <pavel@ucw.cz>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Ivaylo Dimitrov <freemangordon@abv.bg>
Subject: Re: [PATCH v2 2/2] RX-51: ARM errata 430973 workaround
Message-ID: <20130918182144.GY9994@atomide.com>
References: <1362044548-5398-1-git-send-email-pali.rohar@gmail.com>
 <201309181033.24965@pali>
 <20130918171816.GT9994@atomide.com>
 <201309182013.52975@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201309182013.52975@pali>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Pali Rohár <pali.rohar@gmail.com> [130918 11:21]:
> On Wednesday 18 September 2013 19:18:17 Tony Lindgren wrote:
> > 
> > Hmm hasn't there been pending comments until recently on your
> > patches?
> > 
> 
> Since 10.07.2013 I do not have any emails for patch 2/2. If I 
> missed something from you, please resend me it.

Sorry I noticed it only when looking at them again from "keep
in my inbox for applying" or "mark as read and archive" point
of view. So no other comments from me are pending.
 
> > It seems that with the changes I suggested your patches should
> > work for both legacy booting and DT based booting, so maybe
> > just try to update them over next few weeks, let's say by
> > -rc3 rather than wait 2 to 5 months? :) No need to test them
> > currently on the DT based booting if you don't have that set
> > up, just move the code out of the board-*.c file.
> > 
> 
> Ok, no problem. I will move code as you suggested.

Thanks,

Tony
