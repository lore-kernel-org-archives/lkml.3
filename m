Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754616AbaIPQKL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 12:10:11 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:59069 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754081AbaIPQKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 12:10:10 -0400
Date: Tue, 16 Sep 2014 17:10:01 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Daniel Thompson <daniel.thompson@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        spear-devel@list.st.com, Arnd Bergmann <arnd@arndb.de>,
        Paul Bolle <pebolle@tiscali.nl>, patches@linaro.org,
        linaro-kernel@lists.linaro.org
Subject: Re: [PATCH] arm: Remove redundant config value DEBUG_UART_NETX
Message-ID: <20140916161001.GL12361@n2100.arm.linux.org.uk>
References: <1410818986-13273-1-git-send-email-daniel.thompson@linaro.org> <541764E9.5030308@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <541764E9.5030308@linaro.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 15, 2014 at 11:15:05PM +0100, Daniel Thompson wrote:
> On 15/09/14 23:09, Daniel Thompson wrote:
> > Commit 880fa9b6fd73 ("ARM: 8144/1: netx: Migrate DEBUG_LL macros to
> > shared directory") spuriously introduces an unused config variable,
> > DEBUG_UART_NETX. Let's remove it.
> 
> Not sure if this is better shared as a new patch (as below) or respun
> from the original (as 8144/2)?

Oh, it's a patch I have... in which case, please respin this patch, and
throw the updated patch into the patch system.  Thanks.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
