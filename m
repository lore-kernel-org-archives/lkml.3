Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753204Ab3KSQn1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 11:43:27 -0500
Received: from eddie.linux-mips.org ([78.24.191.182]:43242 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752433Ab3KSQnZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 11:43:25 -0500
Date: Tue, 19 Nov 2013 17:38:12 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Shinya Kuribayashi <skuribay@pobox.com>
Cc: jbaron@akamai.com, mingo@kernel.org, benh@kernel.crashing.org,
        paulus@samba.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
        florian@openwrt.org, jchandra@broadcom.com, ganesanr@broadcom.com
Subject: Re: [PATCH v2] panic: Make panic_timeout configurable
Message-ID: <20131119163811.GD13331@linux-mips.org>
References: <20131118210436.233B5202A@prod-mail-relay06.akamai.com>
 <20131119090211.GN10382@linux-mips.org>
 <528B7AEF.7020805@pobox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <528B7AEF.7020805@pobox.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 19, 2013 at 11:51:27PM +0900, Shinya Kuribayashi wrote:

> IIRC we had set it to 180 seconds for some historical reasons, but
> I'm afraid nobody can recall the reason why it's set so in 2013...
> Anyway I was thinking it too long and reduced to a few seconds locally
> when debugging, so there shouldn't be a problem with this change.

I think one motivation was to have boards reboot automatically avoiding
the need to walk over to the board just powercycle or reset it - let
alone reseting by emailing/phoning an admin!

But that's a development-specific motivation and it shouldn't result
in a hardcoded reboot timeout for everybody.

  Ralf
