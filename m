Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754468Ab3AWJEt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 04:04:49 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:35845 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753738Ab3AWJEq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 04:04:46 -0500
Message-ID: <50FFA7A9.9040709@ti.com>
Date: Wed, 23 Jan 2013 10:04:41 +0100
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130115 Thunderbird/17.0.2
MIME-Version: 1.0
To: Luciano Coelho <coelho@ti.com>
CC: Tony Lindgren <tony@atomide.com>, <gregkh@linuxfoundation.org>,
        <balbi@ti.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Revert "drivers/misc/ti-st: remove gpio handling"
References: <1358766762-24405-1-git-send-email-coelho@ti.com>  <20130122201453.GR22517@atomide.com> <1358890299.6252.166.camel@cumari.coelho.fi>
In-Reply-To: <1358890299.6252.166.camel@cumari.coelho.fi>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/22/2013 10:31 PM, Luciano Coelho wrote:
> I thought about checking exactly what we need as delays and whether we
> really need to do all that toggling.  At least in some boards, the
> toggles are not needed, but I don't know for sure whether it works in
> all different variations of the chip, so I kept them to be safe.  Also,
> I tried to deviate as little as possible from a plain revert, since I'd
> like to get this into stable as well.

I can not find the documentation for the WiLink, but I would guess that it
needs some delay between high->low(off)->(wait)->high(on)->(power-on-time)->up

-- 
Péter
