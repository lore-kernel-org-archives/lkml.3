Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757163AbaFZQh4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 12:37:56 -0400
Received: from mail-yk0-f175.google.com ([209.85.160.175]:65119 "EHLO
	mail-yk0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754485AbaFZQhy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 12:37:54 -0400
Date: Thu, 26 Jun 2014 13:37:07 -0300
From: Ezequiel =?iso-8859-1?Q?Garc=EDa?= <ezequiel@vanguardiasur.com.ar>
To: Guido =?iso-8859-1?Q?Mart=EDnez?= <guido@vanguardiasur.com.ar>
Cc: Tony Lindgren <tony@atomide.com>, pekon@ti.com, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] arm: mach-omap2: gpmc: ignore non-available nodes
Message-ID: <20140626163707.GA26836@arch.cereza>
References: <1403794923-19511-1-git-send-email-guido@vanguardiasur.com.ar>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1403794923-19511-1-git-send-email-guido@vanguardiasur.com.ar>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26 Jun 12:02 PM, Guido Martínez wrote:
> Currently, child nodes of the gpmc node are iterated and probed
> regardless of their 'status' property. This means adding 'status =
> "disabled";' has no effect.
> 
> This patch changes the iteration to only probe nodes marked as
> available.
> 
> Signed-off-by: Guido Martínez <guido@vanguardiasur.com.ar>

Just a nit: the commit title doesn't match the recent commits. If you
run "git log" on this file, you'll find the pattern should be something
like:

"ARM: OMAP2+: GPMC should only probe enabled devices"

Other than this, the patch looks correct.

Thanks,
-- 
Ezequiel Garcia, VanguardiaSur
www.vanguardiasur.com.ar
