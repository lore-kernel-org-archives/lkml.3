Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751875Ab3EISqA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 14:46:00 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:12211 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751257Ab3EISp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 14:45:59 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+cAx1/jo3WPribfdlj6Mae
Date: Thu, 9 May 2013 11:45:48 -0700
From: Tony Lindgren <tony@atomide.com>
To: Dan Murphy <dmurphy@ti.com>
Cc: Vincent =?utf-8?Q?Stehl=C3=A9?= <v-stehle@ti.com>, b-cousson@ti.com,
        linux@arm.linux.org.uk, linux-omap@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2] ARM:dts:omap4-panda:Update the LED support for the
 panda DTS
Message-ID: <20130509184548.GH31554@atomide.com>
References: <1366229760-4808-1-git-send-email-dmurphy@ti.com>
 <516FBD18.3060501@ti.com>
 <51703BEF.6050804@ti.com>
 <20130508234745.GV32546@atomide.com>
 <518BE617.1080509@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <518BE617.1080509@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Dan Murphy <dmurphy@ti.com> [130509 11:13]:
>
> Can we cleanly append to omap4_pmx_core without overriding the whole node?
> I don't want to recreate the pmx_core node in the es file.

Yes that should work just fine.

Regards,

Tony
