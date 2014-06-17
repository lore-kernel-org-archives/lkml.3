Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965071AbaFQWsQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 18:48:16 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:33360 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932818AbaFQWsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 18:48:12 -0400
Date: Tue, 17 Jun 2014 23:48:06 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Mike Turquette <mturquette@linaro.org>
Cc: Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] clkdev: Don't print errors on probe defer
Message-ID: <20140617224805.GN23430@n2100.arm.linux.org.uk>
References: <1402702591-21087-1-git-send-email-sboyd@codeaurora.org> <20140617223305.32686.15540@quantum>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140617223305.32686.15540@quantum>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 17, 2014 at 03:33:05PM -0700, Mike Turquette wrote:
> Quoting Stephen Boyd (2014-06-13 16:36:31)
> > This error message can spam the logs if you have lots of probe
> > deferals due to missing clocks. Just silence the error in this
> > case because the driver should try again later.
> > 
> > Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> 
> Looks OK to me. Russell?

Looks fine to me too.  Should I assume you're looking to take it?

Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
