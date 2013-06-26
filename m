Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751803Ab3FZG1b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 02:27:31 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:23471 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751678Ab3FZG12 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 02:27:28 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19n2ZLIbfym98YYREvr7ZoA
Date: Tue, 25 Jun 2013 23:27:26 -0700
From: Tony Lindgren <tony@atomide.com>
To: Dan Murphy <dmurphy@ti.com>
Cc: Ruslan Bilovol <ruslan.bilovol@ti.com>, b-cousson@ti.com,
        benoit.cousson@linaro.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH v2] ARM: DTS: OMAP4: Add OMAP4 Blaze Tablet support
Message-ID: <20130626062725.GL5523@atomide.com>
References: <1372159970-6361-1-git-send-email-ruslan.bilovol@ti.com>
 <51C9A412.1050802@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51C9A412.1050802@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Dan Murphy <dmurphy@ti.com> [130625 07:13]:
> On 06/25/2013 06:32 AM, Ruslan Bilovol wrote:
> >The OMAP4 Blaze Tablet is TI OMAP4 processor-based
> >development platform in a tablet formfactor.
> >The platform contains many of the features found in
> >present-day handsets (such as audio, video, wireless
> >functions and user interfaces) and in addition
> >contains features for software development and test.
> Why do we want to send this upstream?
> What is the advantage to having this supported?
> 
> I don't believe we need to add another community board.  We have a
> SDP and Panda.

Why not? Just the .dts file is needed nowadays and it
may make it easier to support various other omap4 based
tablets that have similar features.

Regards,

Tony
