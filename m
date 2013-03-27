Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754781Ab3C0WZe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 18:25:34 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:62285 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752311Ab3C0WZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 18:25:33 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18/hqZwo8rQisdkhR+dW2H5
Date: Wed, 27 Mar 2013 15:25:24 -0700
From: Tony Lindgren <tony@atomide.com>
To: Pali =?utf-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>
Cc: Juha Yrjola <juha.yrjola@solidboot.com>,
        Russell King <linux@arm.linux.org.uk>, Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] OMAP3 ROM Random Number Generator support
Message-ID: <20130327222524.GR10155@atomide.com>
References: <201302281905.48546@pali>
 <20130327210918.GP10155@atomide.com>
 <201303272303.44420@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201303272303.44420@pali>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Pali Rohár <pali.rohar@gmail.com> [130327 15:08]:
> 
> I will remove above code for checking omap type from hw rand 
> driver, because same code is in omap part which creating 
> platform_device for this driver. So soc.h is not needed.

OK thanks,

Tony
