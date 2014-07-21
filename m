Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754532AbaGUKXy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 06:23:54 -0400
Received: from mail.skyhub.de ([78.46.96.112]:41248 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754182AbaGUKXx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 06:23:53 -0400
Date: Mon, 21 Jul 2014 12:23:46 +0200
From: Borislav Petkov <bp@alien8.de>
To: Peter Feuerer <peter@piie.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Zhang Rui <rui.zhang@intel.com>, Andreas Mohr <andi@lisas.de>,
        Borislav Petkov <bp@suse.de>, Javi Merino <javi.merino@arm.com>
Subject: Re: [PATCH v4 4/6] acerhdf: Use bang-bang thermal governor
Message-ID: <20140721102346.GC10016@pd.tnic>
References: <1398561815-22033-1-git-send-email-peter@piie.net>
 <1405817480-25347-1-git-send-email-peter@piie.net>
 <1405817480-25347-5-git-send-email-peter@piie.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1405817480-25347-5-git-send-email-peter@piie.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 20, 2014 at 02:51:18AM +0200, Peter Feuerer wrote:
> acerhdf has been doing an on-off fan control using hysteresis by
> post-manipulating the outcome of thermal subsystem trip point handling.
> This patch enables acerhdf to use the bang-bang governor, which is
> intended for on-off controlled fans.

Initial testing looks good.

It wasn't that easy to test though, judging by the current weather
temperatures - I had to go into the fridge with the laptop to cause it
to go under fanoff :-)

Acked-and-tested-by: Borislav Petkov <bp@suse.de>

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
