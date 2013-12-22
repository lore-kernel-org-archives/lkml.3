Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755792Ab3LVTuV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Dec 2013 14:50:21 -0500
Received: from mail-pb0-f50.google.com ([209.85.160.50]:34010 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754569Ab3LVTuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Dec 2013 14:50:20 -0500
Date: Sun, 22 Dec 2013 11:48:12 -0800
From: Olof Johansson <olof@lixom.net>
To: Jonas Jensen <jonas.jensen@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, arm@kernel.org,
        linux@arm.linux.org.uk, arnd@arndb.de
Subject: Re: [PATCH v4 1/2] ARM: mach-moxart: add MOXA ART SoC platform files
Message-ID: <20131222194812.GD9144@quad.lixom.net>
References: <1386945188-8316-1-git-send-email-jonas.jensen@gmail.com>
 <1386945188-8316-2-git-send-email-jonas.jensen@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386945188-8316-2-git-send-email-jonas.jensen@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 13, 2013 at 03:33:07PM +0100, Jonas Jensen wrote:
> The MOXA ART SoC is based on Faraday's FA526. This is a ARMv4 32-bit
> 192 MHz CPU with MMU and 16KB/8KB D/I-cache.
> 
> Add platform support for this SoC.
> 
> Also add UC-7112-LX as a machine.
> 
> Signed-off-by: Jonas Jensen <jonas.jensen@gmail.com>

Applied to next/soc for 3.14. Please follow up on the comments and submit
patches as needed on top of this.

Also, I renamed the patch to be ARM: moxart: ... since we normally leave out
the mach- part.


-Olof
