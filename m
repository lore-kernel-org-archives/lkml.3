Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758235Ab3BKTAQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 14:00:16 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:56865 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757743Ab3BKTAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 14:00:14 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18RiF8M+Vqi3xb2BFufGQ0B
Date: Mon, 11 Feb 2013 11:00:11 -0800
From: Tony Lindgren <tony@atomide.com>
To: Jon Hunter <jon-hunter@ti.com>
Cc: linux-omap@vger.kernel.org, Ruslan Bilovol <ruslan.bilovol@ti.com>,
        linux@arm.linux.org.uk, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/1] ARM: OMAP4: Add OMAP4 Blaze Tablet support
Message-ID: <20130211190011.GS4801@atomide.com>
References: <1360352269-14922-1-git-send-email-ruslan.bilovol@ti.com>
 <1360352269-14922-2-git-send-email-ruslan.bilovol@ti.com>
 <20130210025225.GB4801@atomide.com>
 <51193DE1.6080704@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51193DE1.6080704@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jon Hunter <jon-hunter@ti.com> [130211 10:58]:
> 
> Please note that the blaze is derived from the omap4-sdp board and so I
> would hope that we can use the existing for sdp dts and board file for
> blaze. In fact this is what I do today for basic booting.
> 
> So unless there is some feature on the blaze that is not compatible with
> the original sdp, we should just use the sdp dts.

Sounds like we need some common .dts file and separate files
for sdp, blaze and tablet that include the common .dts file?

There's a different LCD panel at least between blaze and the
tablet.

Regards,

Tony
