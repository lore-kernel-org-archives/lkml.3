Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422646Ab3CVQhQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 12:37:16 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:42246 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1160998Ab3CVQhN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 12:37:13 -0400
Date: Fri, 22 Mar 2013 16:36:05 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Lothar =?iso-8859-1?Q?Wa=DFmann?= <LW@KARO-electronics.de>
Cc: linux-arm-kernel@lists.infradead.org, Tony Lindgren <tony@atomide.com>,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [BUGFIX PATCH] ARM: OMAP: fix type of return values in
	omap_device_get_by_hwmod_name()
Message-ID: <20130322163605.GM30923@n2100.arm.linux.org.uk>
References: <1363867990-24593-1-git-send-email-LW@KARO-electronics.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1363867990-24593-1-git-send-email-LW@KARO-electronics.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 21, 2013 at 01:13:10PM +0100, Lothar Waßmann wrote:
> The merge bda5e141fbe96295c669692114d18687730269fb erroneously changed

Don't forget that commit's description as well...
