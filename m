Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759133Ab3KMJgh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 04:36:37 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:57952 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758464Ab3KMJgd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 04:36:33 -0500
Date: Wed, 13 Nov 2013 09:36:22 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: "Anna, Suman" <s-anna@ti.com>
Cc: Ohad Ben-Cohen <ohad@wizery.com>, Tony Lindgren <tony@atomide.com>,
        Benoit Cousson <bcousson@baylibre.com>,
        Kumar Gala <galak@codeaurora.org>, Paul Walmsley <paul@pwsan.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCHv3 0/8]  omap hwspinlock dt support
Message-ID: <20131113093622.GA21713@e106331-lin.cambridge.arm.com>
References: <1381439735-52888-1-git-send-email-s-anna@ti.com>
 <5282708A.30601@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5282708A.30601@ti.com>
Thread-Topic: [PATCHv3 0/8]  omap hwspinlock dt support
Accept-Language: en-GB, en-US
Content-Language: en-US
acceptlanguage: en-GB, en-US
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 12, 2013 at 06:16:42PM +0000, Anna, Suman wrote:
> 
> > Hi,
> >
> > This is an updated series addressing the review comments from the
> > v2 series. The hwmod patches have been dropped from the repost
> > as per Paul's request, they have already been queued.
> 
> Mark,

Hi Suman,

> 
> Any comments on this series? Tony has picked up the OMAP DTS patches for 
> 3.13, and so
> the "ti,omap4-hwspinlock" compatible string is showing up as 
> undocumented in linux-next.
> How do you want me to proceed here? I will be separating out the 
> bindings into separate patches
> in the future.

The only thing I note that I'm not so keen on is that the
hwlock-specifier is always one cell, rather than using a #hwlock-cells
property on the provider (even if we required it to be <1> for the
moment and just failed if it wasn't).

If possible, I would like an amendment to always use #hwlock-cells, but
otherwise this looks fine to me. Feel free to add my Ack:

Acked-by: Mark Rutland <mark.rutland@arm.com>

Thanks,
Mark.
