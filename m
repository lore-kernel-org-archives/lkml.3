Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932212Ab3BKTtQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 14:49:16 -0500
Received: from utopia.booyaka.com ([74.50.51.50]:35257 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758904Ab3BKTtN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 14:49:13 -0500
Date: Mon, 11 Feb 2013 19:49:12 +0000 (UTC)
From: Paul Walmsley <paul@pwsan.com>
To: Roger Quadros <rogerq@ti.com>
cc: sameo@linux.intel.com, balbi@ti.com, tony@atomide.com, kishon@ti.com,
        sshtylyov@mvista.com, bjorn@mork.no, linux@arm.linux.org.uk,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Rajendra Nayak <rnayak@ti.com>,
        Benoit Cousson <b-cousson@ti.com>,
        Mike Turquette <mturquette@linaro.com>
Subject: Re: [PATCH v8 19/22] ARM: OMAP3: clock data: get rid of unused USB
 host clock aliases and dummies
In-Reply-To: <5110EB87.1060704@ti.com>
Message-ID: <alpine.DEB.2.00.1302111948320.8260@utopia.booyaka.com>
References: <1358511445-26656-1-git-send-email-rogerq@ti.com> <1358511445-26656-20-git-send-email-rogerq@ti.com> <alpine.DEB.2.00.1301182027040.19470@utopia.booyaka.com> <50FD0BEF.9000007@ti.com> <alpine.DEB.2.00.1301211502190.8450@utopia.booyaka.com>
 <5110EB87.1060704@ti.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Roger,

On Tue, 5 Feb 2013, Roger Quadros wrote:

> FYI, the usbhost patches are already in linux-next.

Thanks, I think I'll wait for 3.10 cleanup to send the clock cleanup 
patches, they seem non-critical...


- Paul
