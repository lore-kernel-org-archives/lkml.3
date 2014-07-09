Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755803AbaGIQYM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 12:24:12 -0400
Received: from mail.skyhub.de ([78.46.96.112]:51826 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750951AbaGIQYK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 12:24:10 -0400
Date: Wed, 9 Jul 2014 18:24:04 +0200
From: Borislav Petkov <bp@alien8.de>
To: Petr =?utf-8?Q?Ml=C3=A1dek?= <pmladek@suse.cz>
Cc: Alex Elder <elder@linaro.org>, akpm@linux-foundation.org,
        ak@linux.intel.com, bp@suse.de, jack@suse.cz, john.stultz@linaro.org,
        rostedt@goodmis.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] printk: use a clever macro
Message-ID: <20140709162404.GE5254@pd.tnic>
References: <1404911056-29064-1-git-send-email-elder@linaro.org>
 <1404911056-29064-4-git-send-email-elder@linaro.org>
 <20140709161946.GA26508@pathway.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140709161946.GA26508@pathway.suse.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 09, 2014 at 06:19:46PM +0200, Petr Mládek wrote:
> I wondered if IS_ENABLED() is guaranteed to set 1 when enabled.

See include/linux/kconfig.h

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
