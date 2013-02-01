Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757332Ab3BASzZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 13:55:25 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:10385 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756319Ab3BASzV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 13:55:21 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/dGNMx5f/TjFHp8KpNiEPH
Date: Fri, 1 Feb 2013 10:55:18 -0800
From: Tony Lindgren <tony@atomide.com>
To: Mark Jackson <mpfj-list@mimc.co.uk>
Cc: lkml <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: Re: ARM: OMAP2+: omap2plus_defconfig: enable omap1 rtc
Message-ID: <20130201185518.GP22517@atomide.com>
References: <5107E4C7.6000008@mimc.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5107E4C7.6000008@mimc.co.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Mark Jackson <mpfj-list@mimc.co.uk> [130129 07:07]:
> The BeagleBone dev kit uses the built-in RTC module, so
> it would be nice to have this built by default in the
> omap2plus defconfig.

Thanks applying into omap-for-v3.9/board.

Regards,

Tony
