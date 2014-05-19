Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752696AbaESH0w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 03:26:52 -0400
Received: from mail.skyhub.de ([78.46.96.112]:48978 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750852AbaESH0j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 03:26:39 -0400
Date: Mon, 19 May 2014 09:26:19 +0200
From: Borislav Petkov <bp@alien8.de>
To: Chen Yucong <slaoub@gmail.com>
Cc: tony.luck@intel.com, linux-kernel@vger.kernel.org,
        linux-edac@vger.kernel.org
Subject: Re: [PATCH] x86/mce: Distirbute the clear operation of mces_seen to
 Per-CPU rather than only monarch CPU
Message-ID: <20140519072619.GA6311@pd.tnic>
References: <1400425504-8821-1-git-send-email-slaoub@gmail.com>
 <20140518163508.GA8003@pd.tnic>
 <1400464540.9630.31.camel@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1400464540.9630.31.camel@debian>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2014 at 09:55:40AM +0800, Chen Yucong wrote:
> But all other CPUs also have to wait monarch CPU to exit from mce_end.
> What's the difference between monarch CPU and Per-CPU for clearing
> mces_seen? In practice, there is no difference between them. If we use
> monarch CPU to clear mces_seen, then Per-CPU variable can not play out
> its advantage.

I'll let you stare at mce_reign() a little bit longer... Also, pay
attention to its callsite, that might help.

> Well, in that case, why is there a need for time-out machine in MCE
> handler?

I'll let you figure this out yourself too - it is only fair.

:-)

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
