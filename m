Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933857Ab3E1Jur (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 05:50:47 -0400
Received: from mail-wg0-f54.google.com ([74.125.82.54]:38222 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754879Ab3E1Jup (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 05:50:45 -0400
From: Peter Korsgaard <jacmet@sunsite.dk>
To: Lars Poeschel <larsi@wh2.tu-dresden.de>
Cc: poeschel@lemonage.de, b-cousson@ti.com, tony@atomide.com,
        linux@arm.linux.org.uk, linux-omap@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dts: am33xx: Correct properties on gpmc node
References: <1369729497-11897-1-git-send-email-larsi@wh2.tu-dresden.de>
Date: Tue, 28 May 2013 11:50:40 +0200
In-Reply-To: <1369729497-11897-1-git-send-email-larsi@wh2.tu-dresden.de> (Lars
	Poeschel's message of "Tue, 28 May 2013 10:24:57 +0200")
Message-ID: <87mwrfbfgv.fsf@dell.be.48ers.dk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Lars" == Lars Poeschel <larsi@wh2.tu-dresden.de> writes:

 Lars> From: Lars Poeschel <poeschel@lemonage.de>
 Lars> The gpmc driver is actually looking for "gpmc,num-cs" and
 Lars> "gpmc,num-waitpins" properties in DT. The binding doc also states
 Lars> this.
 Lars> Correct the properties in the dts to provide the right values for the
 Lars> gpmc driver.

 Lars> Signed-off-by: Lars Poeschel <poeschel@lemonage.de>

Acked-by: Peter Korsgaard <jacmet@sunsite.dk>

-- 
Bye, Peter Korsgaard
