Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754866Ab3CFBBM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 20:01:12 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:38709 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751087Ab3CFBBK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 20:01:10 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+am2UzmHTyzcibB5YApof6
Date: Tue, 5 Mar 2013 17:01:07 -0800
From: Tony Lindgren <tony@atomide.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        arm@kernel.org, Bill Pemberton <wfp5p@virginia.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 3/9] mfd: remove __exit_p annotation for
 twl4030_madc_remove
Message-ID: <20130306010107.GI11806@atomide.com>
References: <1362521809-22989-1-git-send-email-arnd@arndb.de>
 <1362521809-22989-4-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362521809-22989-4-git-send-email-arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Arnd Bergmann <arnd@arndb.de> [130305 14:23]:
> 4740f73fe5 "mfd: remove use of __devexit" removed the __devexit annotation
> on the twl4030_madc_remove function, but left an __exit_p() present on the
> pointer to this function. Using __exit_p was as wrong with the devexit in
> place as it is now, but now we get a gcc warning about an unused function.
> 
> In order for the twl4030_madc_remove to work correctly in built-in code, we
> have to remove the __exit_p.

Acked-by: Tony Lindgren <tony@atomide.com>
