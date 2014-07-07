Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752855AbaGGLxB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 07:53:01 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:53249 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751409AbaGGLxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 07:53:00 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19OlSiFCvkqBjtxEplLKISk
Date: Mon, 7 Jul 2014 04:53:00 -0700
From: Tony Lindgren <tony@atomide.com>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Felipe Balbi <balbi@ti.com>, Russell King <linux@arm.linux.org.uk>,
        linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arch: arm: mach-omap2: usb-tusb6010.c:  Cleaning up
 variable is set more than once
Message-ID: <20140707115300.GV28884@atomide.com>
References: <1403699310-22960-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403699310-22960-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se> [140625 05:29]:
> A struct member variable is set to the same value more than once
> 
> This was found using a static code analysis program called cppcheck.

Applying into omap-for-v3.17/fixes-not-urgent thanks.

Tony
