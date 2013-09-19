Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753589Ab3ISV31 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 17:29:27 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:46555 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752885Ab3ISV30 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 17:29:26 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18+/+NNsQ6pHXLtxP56+j3T
Date: Thu, 19 Sep 2013 14:29:22 -0700
From: Tony Lindgren <tony@atomide.com>
To: Pali =?utf-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] RX-51: Add missing max_current to
 rx51_lp5523_led_config
Message-ID: <20130919212922.GA27501@atomide.com>
References: <1379541145-25934-1-git-send-email-pali.rohar@gmail.com>
 <20130918222642.GK9994@atomide.com>
 <201309192301.58761@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201309192301.58761@pali>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Pali Rohár <pali.rohar@gmail.com> [130919 14:10]:
> On Thursday 19 September 2013 00:26:43 Tony Lindgren wrote:
> > * Pali Rohár <pali.rohar@gmail.com> [130918 15:02]:
> > > Without max_current data in board file lp5523 driver does
> > > not change current.
> > 
> > Hmm is this a regression or are there other reasons to merge
> > this during the -rc cycle?
> > 
> 
> I think this is regression, drivers/leds/leds-lp55xx-common.c 
> code refuse to change led_current sysfs attribute if value is 
> higher than max_current specified in board file. And because in 
> board file max_current is not specified it is by default zero as 
> global variable. So changing led_current is not possible because 
> any positive value is more than zero. First I saw this behaviour 
> in 3.10, but I forgot to send this patch.

OK thanks, can you please update the patch description with
that so I can merge it for the -rc cycle? Ideally of course
with the breaking commit too.

Regards,

Tony
