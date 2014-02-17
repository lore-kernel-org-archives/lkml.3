Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752463AbaBQMsR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 07:48:17 -0500
Received: from cpsmtpb-ews08.kpnxchange.com ([213.75.39.13]:55552 "EHLO
	cpsmtpb-ews08.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751552AbaBQMsP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 07:48:15 -0500
Message-ID: <1392641293.13000.9.camel@x220>
Subject: Re: [PATCH] arm: omap3: cm-t35: remove MACH_CM_T3730
From: Paul Bolle <pebolle@tiscali.nl>
To: Igor Grinberg <grinberg@compulab.co.il>
Cc: Tony Lindgren <tony@atomide.com>, Russell King <linux@arm.linux.org.uk>,
        Richard Weinberger <richard@nod.at>,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Mon, 17 Feb 2014 13:48:13 +0100
In-Reply-To: <5302017F.40900@compulab.co.il>
References: <1392571560.28866.16.camel@x220> <5302017F.40900@compulab.co.il>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 Feb 2014 12:48:13.0888 (UTC) FILETIME=[85762400:01CF2BDE]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Igor,

On Mon, 2014-02-17 at 14:33 +0200, Igor Grinberg wrote:
> On 02/16/14 19:26, Paul Bolle wrote:
> > The Kconfig symbol MACH_CM_T3730 was added in v3.1. It has never been
> > used. Setting it has no effect. There are no calls for
> > machine_is_cm_t3730(). This symbol can safely be removed.
> 
> Indeed...

Please note that I now doubt my reasoning was correct here. I'm going to
revisit my recent batch of patches regarding, in short, arm Kconfig
symbols used in mach-types.h. (lkml.org is sort of down, so I can't
provide a link.)

> Is it such a burden to keep it just until we switch OMAP3 to DT?
> Because, it makes a bit harder to hack on the kernel.
> Well, not too much as it can be reverted, but still one needs
> to remember to do this...

No, not really. The worst that could happen, from your perspective, is
that if it turns out this was the right thing to do, I might send a
reminder in a few months.

> I'd like to keep it just until we remove the board files, please.

Thanks,


Paul Bolle

