Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756187AbaGIQcJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 12:32:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48855 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755554AbaGIQcH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 12:32:07 -0400
Date: Wed, 9 Jul 2014 18:32:05 +0200
From: Petr =?iso-8859-1?Q?Ml=E1dek?= <pmladek@suse.cz>
To: Borislav Petkov <bp@alien8.de>
Cc: Alex Elder <elder@linaro.org>, akpm@linux-foundation.org,
        ak@linux.intel.com, bp@suse.de, jack@suse.cz, john.stultz@linaro.org,
        rostedt@goodmis.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] printk: use a clever macro
Message-ID: <20140709163205.GC26508@pathway.suse.cz>
References: <1404911056-29064-1-git-send-email-elder@linaro.org>
 <1404911056-29064-4-git-send-email-elder@linaro.org>
 <20140709161946.GA26508@pathway.suse.cz>
 <20140709162404.GE5254@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140709162404.GE5254@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2014-07-09 18:24:04, Borislav Petkov wrote:
> On Wed, Jul 09, 2014 at 06:19:46PM +0200, Petr Mládek wrote:
> > I wondered if IS_ENABLED() is guaranteed to set 1 when enabled.
> 
> See include/linux/kconfig.h

I know that it sets 1 now. I wondered about possible future
changes. Well, it is probably too paranoid. Anyway, any non-zero value
is fine.

Best Regards,
Petr
