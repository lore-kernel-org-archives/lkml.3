Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753420Ab3LMTTe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 14:19:34 -0500
Received: from mail-ie0-f175.google.com ([209.85.223.175]:37593 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753226Ab3LMTTc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 14:19:32 -0500
Date: Fri, 13 Dec 2013 14:19:26 -0500
From: Matt Porter <mporter@linaro.org>
To: Christian Daudt <bcm@fixthebug.org>
Cc: Russell King <linux@arm.linux.org.uk>, Olof Johansson <olof@lixom.net>,
        Stephen Warren <swarren@wwwdotorg.org>, Chris Ball <cjb@laptop.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] ARM: bcm: Add DEBUG_LL console support
Message-ID: <20131213191926.GF23499@beef>
References: <1380987809-4886-1-git-send-email-bcm@fixthebug.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380987809-4886-1-git-send-email-bcm@fixthebug.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 05, 2013 at 08:43:29AM -0700, Christian Daudt wrote:
> This patch adds low level debug uart support to Broadcom
>  mobile based SOCs.
> 
> Signed-off-by: Christian Daudt <bcm@fixthebug.org>
> 
> Changes from V2:
>  - Changed to follow hex ordering on entries
>  - Dropped defconfig changes
> 
> Changes from V1:
>  - Switched to use the common 8250 debug introduced in 3.12-rc1
> 

Also working for me on my Capri board.

Tested-by: Matt Porter <mporter@linaro.org>

-Matt
