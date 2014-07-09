Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932081AbaGIPFo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 11:05:44 -0400
Received: from mail.skyhub.de ([78.46.96.112]:49106 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752523AbaGIPFn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 11:05:43 -0400
Date: Wed, 9 Jul 2014 17:05:37 +0200
From: Borislav Petkov <bp@alien8.de>
To: Alex Elder <elder@linaro.org>
Cc: akpm@linux-foundation.org, ak@linux.intel.com, bp@suse.de, jack@suse.cz,
        john.stultz@linaro.org, pmladek@suse.cz, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] printk: use a clever macro
Message-ID: <20140709150537.GC5254@pd.tnic>
References: <1404911056-29064-1-git-send-email-elder@linaro.org>
 <1404911056-29064-4-git-send-email-elder@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1404911056-29064-4-git-send-email-elder@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 09, 2014 at 08:04:15AM -0500, Alex Elder wrote:
> Use the IS_ENABLED() macro rather than #ifdef blocks to set certain
> global values.
> 
> Signed-off-by: Alex Elder <elder@linaro.org>

That's good - every patch which removes ifdeffery is a good patch. :)

Acked-by: Borislav Petkov <bp@suse.de>

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
