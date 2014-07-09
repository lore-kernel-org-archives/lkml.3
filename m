Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756547AbaGIPOA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 11:14:00 -0400
Received: from mail.skyhub.de ([78.46.96.112]:40063 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751082AbaGIPN5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 11:13:57 -0400
Date: Wed, 9 Jul 2014 17:13:51 +0200
From: Borislav Petkov <bp@alien8.de>
To: Alex Elder <alex.elder@linaro.org>
Cc: Alex Elder <elder@linaro.org>, akpm@linux-foundation.org,
        ak@linux.intel.com, bp@suse.de, jack@suse.cz, john.stultz@linaro.org,
        pmladek@suse.cz, rostedt@goodmis.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] printk: rename DEFAULT_MESSAGE_LOGLEVEL
Message-ID: <20140709151351.GD5254@pd.tnic>
References: <1404911056-29064-1-git-send-email-elder@linaro.org>
 <1404911056-29064-2-git-send-email-elder@linaro.org>
 <20140709150043.GB5254@pd.tnic>
 <53BD5B64.3010703@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <53BD5B64.3010703@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 09, 2014 at 10:10:28AM -0500, Alex Elder wrote:
> Yes I realized this just sort of moved that sort of problem
> to a different place.  The change was responding to the
> inconsistency in naming in "printk.c".  I can control the
> effects of that, but I can't predict who might be using
> various config options, so I avoided doing that rename.
> 
> Was I being overly cautious on the config option name?
> I could fix that too and have consistency everywhere.

You mean turn it into CONFIG_MESSAGE_LOGLEVEL_DEFAULT?

I think you're free to do so because .config defines are not API anyway
and anyone who thinks so should get off the bad sh*t he's smoking.

:-)

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
