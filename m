Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751901Ab3ARKMF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 05:12:05 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:49805 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751686Ab3ARKMC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 05:12:02 -0500
Message-ID: <50F91FE2.3020402@ti.com>
Date: Fri, 18 Jan 2013 11:11:46 +0100
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130115 Thunderbird/17.0.2
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>
CC: Luciano Coelho <coelho@ti.com>, <balbi@ti.com>,
        <linux-omap@vger.kernel.org>, <linux@arm.linux.org.uk>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [[PATCH v2]] OMAP: omap4-panda: add WiLink shared transport power
 functions
References: <1358372702-13102-1-git-send-email-coelho@ti.com> <50F7C4A7.5060202@ti.com> <20130117093417.GH10814@arwen.pp.htv.fi> <50F7CA82.4050509@ti.com> <20130117100510.GI10814@arwen.pp.htv.fi> <20130117100919.GJ10814@arwen.pp.htv.fi> <1358418917.6252.31.camel@cumari.coelho.fi> <50F7D535.6030205@ti.com> <20130117173131.GL14149@atomide.com> <1358445456.6252.64.camel@cumari.coelho.fi> <20130117231608.GP14149@atomide.com>
In-Reply-To: <20130117231608.GP14149@atomide.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tony,

On 01/18/2013 12:16 AM, Tony Lindgren wrote:
> Well we are planning to drop the non-DT support for omap4 as soon as it's
> usable with DT.

Exactly, but right now we do have legacy and legacy should work in order to
help for example Luca to make the final push which allows us to move to DT
only for OMAP4.

> For omap4 we are only carrying SDP and panda support to
> make this transition easier. The only bindings missing AFAIK are wl12xx and
> USB.
>
> If we add this, then it implies we're somehow supporting it, which is not
> the way to go IMHO as we need to get rid of these platform callbacks instead.

IMHO we should keep these boards working as long as we have the legacy board
support for them.

So what is the policy now regarding to 'old' legacy but still used OMAP4 board
files? I think we should still maintain them, but the effort to get rid of
them should be the highest priority.

-- 
Péter
